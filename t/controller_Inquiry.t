use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Moksha' }
BEGIN { use_ok 'Moksha::Controller::Inquiry' }

ok( request('/inquiry')->is_success, 'Request should succeed' );


