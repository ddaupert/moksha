package Moksha::View::Email;

use strict;
use base 'Catalyst::View::Email';

__PACKAGE__->config(
    stash_key => 'email'
);

=head1 NAME

Moksha::View::Email - Email View for Moksha

=head1 DESCRIPTION

View for sending email from Moksha. 

=head1 AUTHOR

perl,,,

=head1 SEE ALSO

L<Moksha>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;