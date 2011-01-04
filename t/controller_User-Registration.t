use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Moksha' }
BEGIN { use_ok 'Moksha::Controller::User::Registration' }

ok( request('/user/registration')->is_success, 'Request should succeed' );
done_testing();
