package Moksha::Form::User::Register;

use HTML::FormHandler::Moose;

extends 'Moksha::Form::User';

has_field 'submit' => ( type => 'Submit', value => 'Register' );

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;

1;
