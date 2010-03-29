package Moksha::Form::Inquiry::Belief;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class'      => ( default => 'InqBelief' );

has 'user_id'          => ( isa => 'Int', is => 'rw' );
has 'inquiry_fk'       => ( isa => 'Int', is => 'rw' );

has_field 'type_fk'    => ( type => 'Select', label => 'Type of Experience', 
                         required => 1 );
has_field 'belief'     => ( type => 'Text', required => 1 );
has_field 'user_id'    => ( type => 'Hidden', required => 1 );
has_field 'inquiry_fk' => ( type => 'Hidden', required => 1 );
has_field 'submit'     => ( type => 'Submit' );

after 'setup_form'     => sub {
  my $self = shift;

  $self->field('user_id')->value( $self->user_id );
  $self->field('inquiry_fk')->value( $self->inquiry_fk );
};

sub options_type_fk {
  my $self = shift; 
  return unless $self->schema;
  my @rows =
      $self->schema->resultset( 'InqType' )->
        search( {}, { order_by => ['id', 'type'] } )->all;
  return [ map { $_->id, $_->type } @rows ];
}

no HTML::FormHandler::Moose;

1;
