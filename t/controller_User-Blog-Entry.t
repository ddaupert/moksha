use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Moksha' }
BEGIN { use_ok 'Moksha::Controller::User::Blog::Entry' }

ok( request('/user/blog/entry')->is_success, 'Request should succeed' );


