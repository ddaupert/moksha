package Moksha::Schema::Result::InqBelief;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("inq_beliefs");
__PACKAGE__->add_columns(
  "id",         { data_type => 'INTEGER', is_nullable => 0, is_auto_increment => 1 },
  "inquiry_fk", { data_type => 'INTEGER', is_nullable => 0, size => undef },
  "user_id",    { data_type => 'INTEGER', is_nullable => 0, size => undef },
  "belief",     { data_type => 'TEXT', is_nullable => 0, size => undef },
  "type_fk",    { data_type => 'INTEGER', is_nullable => 0, size => undef },
  "created",    { data_type => 'datetime', set_on_create => 1 },
  "updated",    { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->set_primary_key("id");

#
# Set relationships:
#

__PACKAGE__->belongs_to(b2_inquiry => 'Moksha::Schema::Result::Inq', 'inquiry_fk');

__PACKAGE__->belongs_to(b2_users => 'Moksha::Schema::Result::User', 'user_id');

__PACKAGE__->belongs_to(b2_types => 'Moksha::Schema::Result::InqType', 'type_fk');

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table (aka, foreign key in peer table)
__PACKAGE__->has_many(
"hm_belief_type", 
"Moksha::Schema::Result::InqBeliefType", 
{ "foreign.belief_fk" => "self.id" });

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above
#   You must already have the has_many() defined to use a many_to_many().
__PACKAGE__->many_to_many(m2m_types => 'hm_belief_type', 'b2_belief');

#
# Set ResultSet Class
#
# __PACKAGE__->resultset_class('Moksha::Schema::ResultSet::InqBelief');

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
