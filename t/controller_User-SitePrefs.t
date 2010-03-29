use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Moksha' }
BEGIN { use_ok 'Moksha::Controller::User::SitePrefs' }

ok( request('/user/siteprefs')->is_success, 'Request should succeed' );


