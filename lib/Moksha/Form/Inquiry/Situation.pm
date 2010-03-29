package Moksha::Form::Inquiry::Situation;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has 'user_id'         => ( isa => 'Int', is => 'rw' );

has_field 'situation' => ( type => 'Text', required => 1 );
has_field 'user_id'   => ( type => 'Hidden', required => 1 );
has_field 'submit'    => ( type => 'Submit' );

after 'setup_form'    => sub {
  my $self = shift;
  my $story_obj = $self->item;

  $self->field('user_id')->value( $self->user_id );
};


no HTML::FormHandler::Moose;

1;
