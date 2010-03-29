package Moksha::Form::User::Blog::Entry;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class'    => ( default => 'Entry' );
has 'blog_id'        => ( isa => 'Int', is => 'rw' );
has 'user_id'        => ( isa => 'Int', is => 'rw' );

has_field 'content'  => ( type => 'TextArea', required => 1 );
has_field 'blog_id'  => ( type => 'Hidden', required => 1 );
has_field 'user_id'  => ( type => 'Hidden', required => 1 );
has_field 'active'   => ( type => 'Hidden', required => 1, default => 1 );
has_field 'tags_str' => ( type => 'TextArea', required => 0, label => 'Tags' );

has_field 'submit'   => ( type => 'Submit' );

after 'setup_form'   => sub {
  my $self = shift;
  my $entry_obj = $self->item;

  $self->field('blog_id')->value( $self->blog_id );
  $self->field('user_id')->value( $self->user_id );
 
  $self->field('tags_str')->value(
    join ', ', 
      $entry_obj->m2m_entry_tags->search({}, 
    { order_by => 'name' })->get_column('name')->all
  );
};

around 'update_model' => sub {
    my $orig = shift;
    my $self = shift;
    my $entry_obj = $self->item;
    
    $self->schema->txn_do(sub {	
	$orig->($self, @_);

	my @tags = split /\s*,\s*/, $self->field('tags_str')->value;

	$entry_obj->hm_entry_tags->delete;
	$entry_obj->hm_entry_tags->create(
                      { b2_tag => { name => $_,
                                    user_id => $self->field('user_id')->value } })
	    foreach (@tags);

  my $content = filter_content($entry_obj->content);
  $entry_obj->update({ content => $content }) if $content;

    });
};

sub filter_content {
    my $content = shift;
    return unless $content;
    $content =~ s{\r}{}g;

}

no HTML::FormHandler::Moose;

1;
