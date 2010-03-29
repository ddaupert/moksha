package Moksha::Schema::Result::Role;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime UTF8Columns Core/);
__PACKAGE__->table("roles");
__PACKAGE__->add_columns(
  "id",   { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
  "role", { data_type => "VARCHAR", is_nullable => 0, size => 50 },
);

__PACKAGE__->utf8_columns(qw/role/);
__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "hm_role_users",
  "Moksha::Schema::Result::UserRole", 
  { "foreign.role_fk" => "self.id" }
);

################
################

=head2 op_by_admin

Can the specified user delete the current object?

=cut

sub op_by_admin {
  my ($self, $user) = @_;

  # Only allow delete if user has one of these roles
  my $has_roles = $user->has_role('is_admin') ||
                  $user->has_role('is_superuser');
  
  return( $has_roles );
}


#
# Set ResultSet Class
#
#__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Role');

1;
