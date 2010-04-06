package Moksha::Form::Story;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has 'user_id'        => ( isa => 'Int', is => 'rw' );
has 'inspire_story'  => ( isa => 'Int', is => 'rw' );
has 'inspire_quote'  => ( isa => 'Int', is => 'rw' );

has_field 'title'    => ( type => 'Text', required => 1 );
has_field 'content'  => ( type => 'TextArea', required => 1 );
has_field 'tags_str' => ( type => 'TextArea', required => 0, label => 'Tags' );
has_field 'active'   => ( type => 'Hidden', required => 1, default => 1 );
has_field 'status'   => ( type => 'Select', label => 'Status', required => 1, options =>
    [ { value => 0, label => 'Private' }, { value => 1, label => 'Shared' }, { value => 2, label => 'Public' } ]
);
has_field 'type'     => ( type => 'Select', label => 'Type', required => 1 );
has_field 'user_id'  => ( type => 'Hidden', required => 1 );
has_field 'inspire_story' => ( type => 'Hidden', required => 0 );
has_field 'inspire_quote' => ( type => 'Hidden', required => 0 );
has_field 'inspire_photo' => ( type => 'Hidden', required => 0 );

has_field 'submit'   => ( type => 'Submit' );

after 'setup_form'   => sub {
  my $self = shift;
  my $story_obj = $self->item;

  $self->field('user_id')->value( $self->user_id );
  
  if ( $self->inspire_story  ) {
    $self->field('inspire_story')->value( $self->inspire_story );
  }

  if ( $self->inspire_quote  ) {
    $self->field('inspire_quote')->value( $self->inspire_quote );
  }

  $self->field('tags_str')->value(
    join ', ', 
      $story_obj->m2m_story_tags->search({}, 
    { order_by => 'name' })->get_column('name')->all
  );
};

around 'update_model' => sub {
    my $orig = shift;
    my $self = shift;
    my $story_obj = $self->item;
    
    $self->schema->txn_do(sub {	
	$orig->($self, @_);

	my @tags = split /\s*,\s*/, $self->field('tags_str')->value;

	$story_obj->hm_story_tags->delete;
	$story_obj->hm_story_tags->create(
                      { b2_tag => { name => $_,
                                    user_id => $self->field('user_id')->value } })
	    foreach (@tags);

  my $content = filter_content($story_obj->content);
  $story_obj->update({ content => $content }) if $content;

	my $summary = generate_symmary($story_obj->content);
	$story_obj->update({ summary => $summary }) if $summary;

  $story_obj->hm_story_authors->find_or_create(
                         {  story_fk  => $story_obj->id,
                            author_fk => $self->field('user_id')->value 
                                         
                         });
    });
};

sub filter_content {
    my $content = shift;
    return unless $content;
    $content =~ s{\r}{}g;

}

sub generate_symmary {
    my $content = shift;
    return unless $content;

    # eliminate html tags
    $content =~ s/<[^>]+>/ /g;
    # trim whitespace
    $content =~ s/\s{2,}/ /g;
    
    my $len = length $content;
    $content = substr($content, 0, 200) . ($len > 200 ? '...' : '');
    return $content;
}

sub options_type { # for column 'type'
    my $self = shift;
    return unless $self->schema;
    my $type_rs = $self->schema->resultset('StoryType')->search({active => 1});
    my @selections;
    while ( my $t = $type_rs->next ) {
        push @selections, { value => $t->id, label => $t->label };
    }
    return @selections; 
}

no HTML::FormHandler::Moose;

1;
