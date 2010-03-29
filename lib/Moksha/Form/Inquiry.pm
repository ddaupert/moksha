package Moksha::Form::Inquiry;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class'   => ( default => 'Inq' );
has 'user_id'       => ( isa => 'Int', is => 'rw' );

has_field 'title'   => ( type => 'Text', label => 'Title', required => 1 );
has_field 'user_id' => ( type => 'Hidden', required => 1 );
has_field 'submit'  => ( type => 'Submit' );

after 'setup_form'  => sub {
  my $self = shift;

  $self->field('user_id')->value( $self->user_id );
};

no HTML::FormHandler::Moose;

1;
