package Moksha::Schema::Result::InqType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime UTF8Columns TimeStamp Core/);
__PACKAGE__->table("inq_types");
__PACKAGE__->add_columns(
  "id",       { data_type => 'INTEGER', is_nullable => 0, is_auto_increment => 1 },
  "type",     { data_type => 'VARCHAR', is_nullable => 0, size => 20 },
);

__PACKAGE__->utf8_columns(qw/type/);
__PACKAGE__->set_primary_key("id");

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table (aka, foreign key in peer table)
__PACKAGE__->has_many(
"hm_belief_types", 
"Moksha::Schema::Result::InqBeliefType", 
{ "foreign.type_fk" => "self.id" });

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above
#   You must already have the has_many() defined to use a many_to_many().
__PACKAGE__->many_to_many(m2m_beliefs => 'hm_belief_types', 'b2_type');

#
# Set ResultSet Class
#
# __PACKAGE__->resultset_class('Moksha::Schema::ResultSet::InqBeliefType');

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

1;
