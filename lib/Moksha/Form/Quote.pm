package Moksha::Form::Quote;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class'      => ( default => 'Quote' );
has 'posted_by'        => ( isa => 'Int', is => 'rw' );
# has 'book_fk'          => ( isa => 'Int', is => 'rw' );

has_field 'quote'      => ( type => 'TextArea', required => 1 );
has_field 'title'      => ( type => 'Text', label => 'Book Title', required => 0 );
has_field 'pages'      => ( type => 'Text', label => 'Page(s)', required => 0 );
has_field 'author_fk'  => ( type => 'Select', label => 'Author', required => 0 );
has_field 'book_fk'    => ( type => 'Hidden', required => 0 );
has_field 'tags_str'   => ( type => 'Text', required => 0, label => 'Tags' );
has_field 'posted_by'  => ( type => 'Hidden', required => 1 );
has_field 'active'     => ( type => 'Hidden', required => 1, default => 1 );
has_field 'submit'     => ( type => 'Submit' );

sub options_author_fk {
  my $self = shift; 
  return unless $self->schema;
  my @rows =
      $self->schema->resultset( 'Author' )->
        search( {}, { order_by => ['id', 'lname'] } )->all;
  return [ map { $_->id, $_->lname } @rows ];
}

after 'setup_form' => sub {
  my $self = shift;
  my $item = $self->item;

  $self->field('posted_by')->value( $self->posted_by );
  $self->field('active')->value( '1' );

  $self->field('tags_str')->value(
    join ', ', 
      $item->m2m_quote_tags->search({}, 
    { order_by => 'name' })->get_column('name')->all
  );
};

around 'update_model' => sub {
    my $orig = shift;
    my $self = shift;
    my $item = $self->item;
    
    $self->schema->txn_do(sub {	
	$orig->($self, @_);

	my @tags = split /\s*,\s*/, $self->field('tags_str')->value;

	$item->hm_quote_tags->delete;
  $item->hm_quote_tags->create({ b2_tag => { name => $_ } })
	    foreach (@tags);
    });
};


no HTML::FormHandler::Moose;

1;
