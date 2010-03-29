#!/usr/bin/perl
    
use strict;
use warnings;
    
use Moksha::Schema;
    
my $schema = Moksha::Schema->connect('dbi:Pg:dbname=moksha','moksha','moksha');
    
my @users = $schema->resultset('User')->all;
    
foreach my $user (@users) {
    $user->password('testme');
    $user->update;
}
