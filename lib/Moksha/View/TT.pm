package Moksha::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';


__PACKAGE__->config({
    TEMPLATE_EXTENSION => '.tt2', 
    INCLUDE_PATH => [
        Moksha->path_to( 'root', 'src' ),
        Moksha->path_to( 'root', 'lib' ),
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0
});


=head1 NAME

Moksha::View::TT - TT View for Moksha

=head1 DESCRIPTION

TT View for Moksha.

=head1 SEE ALSO

L<Moksha>

=head1 AUTHOR

Dennis Daupert

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
