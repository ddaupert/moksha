package Moksha::Schema;

use strict;
use warnings;

use Config::Any;
use base qw(DBIx::Class::Schema);

__PACKAGE__->load_namespaces;

1;
