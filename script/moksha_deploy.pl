#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw($Bin);
use Path::Class;
use lib dir($Bin, '..', 'lib')->stringify;

use Moksha::Schema qw(load_schema);

my $schema = load_schema();
$schema->deploy;
