package Moksha::Form::User::AuthQnA;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class'     => ( default => 'AuthQnA' );
has 'user_fk'         => ( isa => 'Int', is => 'rw' );

has_field 'user_fk'   => ( type => 'Hidden', required => 1 );
has_field 'quest1_fk' => ( type => 'Select', label => 'Question 1' );
has_field 'answer1'   => ( type => 'Text', required => 1, label => 'Answer 1' );
has_field 'quest2_fk' => ( type => 'Select', label => 'Question 2' );
has_field 'answer2'   => ( type => 'Text', required => 1, label => 'Answer 2' );

has_field 'submit'   => ( type => 'Submit' );

after 'setup_form' => sub {
    my $self = shift;
    my $item = $self->item;

  $self->field('user_fk')->value( $self->user_fk );
};

sub options_quest1_fk {
  my $self = shift; 
  return unless $self->schema;
  my @rows =
      $self->schema->resultset( 'AuthQuestion' )->
        search( {}, { order_by => ['id', 'question'] } )->all;
  return [ map { $_->id, $_->question } @rows ];
}

sub options_quest2_fk {
  my $self = shift; 
  return unless $self->schema;
  my @rows =
      $self->schema->resultset( 'AuthQuestion' )->
        search( {}, { order_by => ['id', 'question'] } )->all;
  return [ map { $_->id, $_->question } @rows ];
}

# around 'update_model' => sub {
#     my $orig = shift;
#     my $self = shift;
#     my $item = $self->item;
#     
#     $self->schema->txn_do(sub {	
# 	$orig->($self, @_);
# 
# 	my @tags = split /\s*,\s*/, $self->field('tags_str')->value;
# 
# 	$item->hm_quote_tags->delete;
#   $item->hm_quote_tags->create({ b2_tag => { name => $_ } })
# 	    foreach (@tags);
#     });
# };


no HTML::FormHandler::Moose;

1;
