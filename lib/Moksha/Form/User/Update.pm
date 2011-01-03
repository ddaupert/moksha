package Moksha::Form::User::Update;

use HTML::FormHandler::Moose;

extends 'Moksha::Form::User';

has_field 'submit' => ( type => 'Submit', 
                        value => 'Update' );

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;

1;
