package Moksha::Controller::Login;

use strict;
use warnings;
use parent 'Catalyst::Controller';

# use Moksha::Form::Login;

=head1 NAME

MyApp::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

Login logic

=cut

sub index :Path :Args(0) {
  my ($self, $c) = @_;

  # Get the username and password from form
  my $username = $c->request->params->{username} || undef;
  my $password = $c->request->params->{password} || undef;

  # If the username and password values were found in form
  if (defined($username) && defined($password)) {
    # Attempt to log the user in
    if ($c->authenticate({ username => $username,
                           password => $password  } )) {

      if ( $c->user->obj->active == 1
        && $c->user->obj->is_member =~ m/y/i ) {

        $c->response->redirect($c->uri_for('/'));

      }
      else {
        $c->stash->{error_msg} = "Not registered or membership inactive";
        $c->logout;
      }

    } 
    else {
      $c->stash->{error_msg} = "Bad username or password.";
    }
  }

  # If either of above don't work out, send to the login page
  $c->stash->{template} = 'login.tt2';
}


=head1 AUTHOR

root

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
