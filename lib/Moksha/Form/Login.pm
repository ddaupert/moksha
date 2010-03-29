package Moksha::Form::Login;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class'    => ( default => 'User' );
has_field 'username' => ( type => 'Text', 
                          label => 'Username', 
                          required => 1,
                          required_message => 'You must enter a username' );
has_field 'password' => ( type => 'Password', 
                          label => 'Password', 
                          minlength => 6, 
                          required => 1,
                          required_message => 'You must enter a password' );

has_field 'submit'   => ( type => 'Submit' );

no HTML::FormHandler::Moose;

1;
