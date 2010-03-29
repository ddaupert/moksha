package Moksha::Schema::Result::Address;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime UTF8Columns TimeStamp Core/);
__PACKAGE__->table("addresses");
__PACKAGE__->add_columns(
  "id",         { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
  "user_id",    { data_type => "INTEGER", is_nullable => 0, size => undef },
  "address1",   { data_type => "VARCHAR", is_nullable => 0, size => 80 },
  "address2",   { data_type => "VARCHAR", is_nullable => 1, size => 80 },
  "city",       { data_type => "VARCHAR", is_nullable => 0, size => 20 },
  "state",      { data_type => "VARCHAR", is_nullable => 0, size => 4 },
  "zip",        { data_type => "VARCHAR", is_nullable => 0, size => 10 },
  "phone_home", { data_type => "VARCHAR", is_nullable => 1, size => 20 },
  "phone_work", { data_type => "VARCHAR", is_nullable => 1, size => 20 },
  "phone_cell", { data_type => "VARCHAR", is_nullable => 1, size => 20 },
  "created",    { data_type => "datetime", set_on_create => 1 },
  "updated",    { data_type => "datetime", set_on_create => 1, set_on_update => 1 },
);
__PACKAGE__->utf8_columns(qw/address1 address2 city state/);
__PACKAGE__->set_primary_key("id");

#
# Set relationships:
#

__PACKAGE__->belongs_to(b2_user => 'Moksha::Schema::Result::User', 'user_id');

#
# Set ResultSet Class
#
#__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Addresses');


# =head2 delete_allowed_by
# 
# Can the specified user delete the current book?
# 
# =cut
# 
# sub delete_allowed_by {
#     my ($self, $user) = @_;
# 
#     # Only allow delete if user has 'admin' role
#     return $user->has_role('admin');
# }

1;
