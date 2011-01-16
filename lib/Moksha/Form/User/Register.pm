package Moksha::Form::User::Register;

use HTML::FormHandler::Moose;

extends 'Moksha::Form::User';

has 'authcode' => ( isa => 'Str', is => 'rw' );

has_field 'submit' => ( type => 'Submit', value => 'Register' );

after 'setup_form' => sub {
  my $self = shift;
  my $item = $self->item;

  $self->field('active')->value( '0' );
};

before 'update_model' => sub {
    my $self = shift;
    $self->item->authcode( $self->authcode );
};

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;

1;
