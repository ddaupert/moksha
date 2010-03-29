package Moksha::Form::Book;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has 'user_id'           => ( isa => 'Int', is => 'rw' );

has_field 'title'       => ( type => 'Text', required => 1 );
has_field 'subtitle'    => ( type => 'Text', required => 0 );
has_field 'm2m_authors' => ( type => 'Multiple', label => 'Author', required => 0 );
has_field 'posted_by'   => ( type => 'Hidden', required => 1 );
has_field 'url'         => ( type => 'Text', required => 0 );
has_field 'rating'      => ( type => 'Select', required => 0,
options => [
            { value => 1, label => '1'}, 
            { value => 2, label => '2'},
            { value => 3, label => '3'},
            { value => 4, label => '4'},
            { value => 5, label => '5'}
           ] );
has_field 'active'   => ( type => 'Hidden', required => 1, default => 1 );
has_field 'tags_str' => ( type => 'Text', required => 0, label => 'Tags' );
has_field 'submit'   => ( type => 'Submit' );

sub options_m2m_authors {
  my $self = shift; 
  return unless $self->schema;
  my @rows =
      $self->schema->resultset( 'Author' )->
        search( {}, { order_by => ['lname', 'id'] } )->all;
  return [ map { $_->id, $_->lname } @rows ];
}

after 'setup_form' => sub {
    my $self = shift;
    my $item = $self->item;

    $self->field('posted_by')->value( $self->user_id );

    $self->field('tags_str')->value(
	join ', ', 
        $item->m2m_tags->search({}, { order_by => 'name' })->get_column('name')->all
    );
};

around 'update_model' => sub {
    my $orig = shift;
    my $self = shift;
    my $item = $self->item;
    
    $self->schema->txn_do(sub {	
	$orig->($self, @_);

	my @tags = split /\s*,\s*/, $self->field('tags_str')->value;

	$item->hm_book_tags->delete;
  $item->hm_book_tags->create({ b2_tag => { name => $_ } })
	    foreach (@tags);
    });
};


no HTML::FormHandler::Moose;

1;
