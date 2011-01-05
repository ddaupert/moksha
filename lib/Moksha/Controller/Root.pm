package Moksha::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

Moksha::Controller::Root - Root Controller for Moksha

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'index.tt2';
}

################
################

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

################
################

=head2 error_noperms

Permissions error screen

=cut
    
sub error_noperms :Chained('/') :PathPart('error_noperms') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'error_noperms.tt2';
}

################
################

=head2 auto

Check if there is a user and, if not, forward to login page

=cut

# Note that 'auto' runs after 'begin' but before your actions and that
# 'auto's "chain" (all from application path to most specific class are run)
# See the 'Actions' section of 'Catalyst::Manual::Intro' for more info.

sub auto : Private {
    my ($self, $c) = @_;

    # Allow unauthed users to reach the main site frontpage
    # This is locked down to a single action
    if ($c->action eq $c->controller('Root')->action_for('index')
       ) {
      $c->log->debug('*** Root::auto MATCH index action ');
      return 1;
    }

    if ($c->req->path eq '/'  ) {
      $c->log->debug('*** Root::auto path MATCH / ');
      return 1;
    }

    # Allow unauthed users to reach the registration area
    if ( $c->req->path =~ m/registration/ ) {
      $c->log->debug('*** Root::auto MATCH registration area ');
      return 1;
    }


    # Allow unauthenticated users to reach the login page.  This
    # allows unauthenticated users to reach any action in the Login
    # controller.  To lock it down to a single action, we could use:
    #   if ($c->action eq $c->controller('Login')->action_for('index'))
    # to only allow unauthenticated access to the 'index' action we
    # added above.
    if ($c->controller eq $c->controller('Login')) {
        return 1;
    }

    # If a user doesn't exist, force login
    if (!$c->user_exists) {
        # Dump a log message to the development server debug output
        $c->log->debug('***Root::auto User not found, forwarding to /login');
        # Redirect the user to the login page
        $c->response->redirect($c->uri_for('/login'));
        # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }
    elsif ($c->user_exists) {
      $c->stash->{fname}   = $c->user->obj->fname;
      $c->stash->{lname}   = $c->user->obj->lname;
      $c->stash->{user_id} = $c->user->obj->id;

      # User found, so return 1 to continue with processing after this 'auto'
      return 1;
    }


}

#### End auto function

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Alexandru Nedelcu,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
