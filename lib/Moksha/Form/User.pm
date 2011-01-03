package Moksha::Form::User;

use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ('NoSpaces', 'WordChars', 'NotAllDigits' );

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class'    => ( default => 'User' );

has_field 'fname'    => ( type => 'Text', 
                          label => 'First Name', 
                          required => 1 );
has_field 'mname'    => ( type => 'Text', 
                          label => 'Middle', 
                          required => 0 );
has_field 'lname'    => ( type => 'Text', 
                          label => 'Last Name', 
                          required => 1 );
has_field 'username' => ( type => 'Text', 
                          label => 'Username', 
                          required => 1,
                          required_message => 
                            'You must enter a username', 
                          unique => 1,
                          unique_message => 
                            'Username already registered' );

has_field 'email'    => ( type => 'Text', 
                          label => 'Email Address', 
                          required => 1,
                          required_message => 
                             'You must enter a valid email address', 
                          unique => 1,
                          unique_message => 
                             'Email address already registered' );
has_field 'password' => ( type => 'Password', 
                          ne_username => 'username',
                          label => 'Password', 
                          minlength => 6, 
                          required => 1,
                          required_message => 
                            'Letters & digits, no spaces',
                          apply => [ NoSpaces, WordChars, NotAllDigits ] );
has_field 'password2' => ( type => 'PasswordConf' );
has_field 'active'    => ( type => 'Hidden', 
                           required => 1, 
                           default => 1 );


after 'setup_form' => sub {
  my $self = shift;
  my $item = $self->item;

  $self->field('active')->value( '1' );
};


no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;

1;
