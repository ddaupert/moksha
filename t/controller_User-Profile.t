use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Moksha' }
BEGIN { use_ok 'Moksha::Controller::User::Profile' }

ok( request('/user/profile')->is_success, 'Request should succeed' );


