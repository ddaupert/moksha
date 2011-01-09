package Moksha;

use strict;
use warnings;

use Catalyst::Runtime 5.70;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use parent qw/Catalyst/;
use Catalyst qw/-Debug
                ConfigLoader
                Static::Simple
                StackTrace

                Authentication
                Authorization::Roles

                Session
                Session::State::Cookie
                Session::Store::FastMmap

                Unicode
               /;

# Add this later:
# Catalyst::Plugin:RequireSSL


our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in moksha.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'Moksha',
                     session => {flash_to_stash => 1},
 );

__PACKAGE__->config->{authentication} = {  
  default_realm => 'members',
  realms => {
    members => {
      credential => {
        # ...
      },
      store => {
        class         => 'DBIx::Class',
        user_model    => 'DB::User',
        role_relation => 'm2m_roles',
        role_field    => 'role',
#         ignore_fields_in_find => [ 'remote_name' ],
#         use_userdata_from_session => 1,          
      }
    }
  }
};

# __PACKAGE__->config(
#   'View::Email' => {
#     # Where to look in the stash for the email information.
#     # 'email' is the default, so you don't have to specify it.
#     stash_key => 'email',
#     # Define the defaults for the mail
#     default => {
#       # Defines the default content type (mime type). Mandatory
#       content_type => 'text/plain',
#       # Defines the default charset for every MIME part with the 
#       # content type text.
#       # According to RFC2049 a MIME part without a charset should
#       # be treated as US-ASCII by the mail client.
#       # If the charset is not set it won't be set for all MIME parts
#       # without an overridden one.
#       # Default: none
#       charset => 'utf-8'
#     },
#     # Setup how to send the email
#     # all those options are passed directly to Email::Sender::Simple
#     sender => {
#       # if mailer doesn't start with Email::Sender::Simple::Transport::,
#       # then this is prepended.
#       mailer => 'SMTP',
#       # mailer_args is passed directly into Email::Sender::Simple 
#       mailer_args => {
# 	Host     => 'mail.moksha.com', # defaults to localhost
# 	username => 'username',
# 	password => 'password',
#       }
#     }
#   }
# );

__PACKAGE__->config(
  'View::Email::Template' => {
    # Where to look in the stash for the email information.
    # 'email' is the default, so you don't have to specify it.
    stash_key => 'email',
    template_prefix => 'email',
    # Define the defaults for the mail
    default => {
      # Defines the default view used to render the templates.
      # If none is specified neither here nor in the stash
      # Catalysts default view is used.
      # Warning: if you don't tell Catalyst explicit which of your views should
      # be its default one, C::V::Email::Template may choose the wrong one!
      view => 'TT',
      # Defines the default content type (mime type). Mandatory
      content_type => 'text/plain',
      # Defines the default charset for every MIME part with the 
      # content type text.
      # According to RFC2049 a MIME part without a charset should
      # be treated as US-ASCII by the mail client.
      # If the charset is not set it won't be set for all MIME parts
      # without an overridden one.
      # Default: none
      charset => 'utf-8'
    },
    # Setup how to send the email
    # all those options are passed directly to Email::Sender::Simple
    sender => {
      # if mailer doesn't start with Email::Sender::Simple::Transport::,
      # then this is prepended.
      mailer => 'SMTP',
      # mailer_args is passed directly into Email::Sender::Simple 
      mailer_args => {
	Host     => 'mail.moksha.com', # defaults to localhost
	username => 'username',
	password => 'password',
      }
    }
  }
);

# Start the application
__PACKAGE__->setup();

sub redirect_to_action {
    my ($c, $controller, $action, @params) =@_;
    $c->response->redirect($c->uri_for($c->controller($controller)->action_for($action), @params));
    $c->detach;
}

sub action_uri {
    my ($c, $controller, $action, @params) = @_;
    return eval {$c->uri_for($c->controller($controller)->action_for($action), @params)};
}

=head1 NAME

Moksha - Catalyst based application

=head1 SYNOPSIS

    script/moksha_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Moksha::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Alexandru Nedelcu,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
