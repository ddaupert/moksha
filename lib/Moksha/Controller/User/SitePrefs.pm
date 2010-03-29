package Moksha::Controller::User::SitePrefs;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Moksha::Controller::User::SitePrefs - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Moksha::Controller::User::SitePrefs in User::SitePrefs.');
}


=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
