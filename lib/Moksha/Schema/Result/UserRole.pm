package Moksha::Schema::Result::UserRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table("user_roles");
__PACKAGE__->add_columns(
  "user_fk",  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "role_fk",  { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("user_fk", "role_fk");


# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(b2_user => 'Moksha::Schema::Result::User', 'user_fk');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(b2_role => 'Moksha::Schema::Result::Role', 'role_fk');

1;
