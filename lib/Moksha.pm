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

__PACKAGE__->config->{authentication} = 
                {  
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
#                                 ignore_fields_in_find => [ 'remote_name' ],
#                                 use_userdata_from_session => 1,          
                            }
                        }
                    }
                };

# # Configure SimpleDB Authentication
# __PACKAGE__->config->{'Plugin::Authentication'} = {
#         default => {
#             class           => 'SimpleDB',
#             user_model      => 'DB::User',
#             password_type   => 'clear',
#         },
#     };

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
