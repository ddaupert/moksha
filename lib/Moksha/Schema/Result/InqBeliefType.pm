package Moksha::Schema::Result::InqBeliefType;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table("inq_belief_types");
__PACKAGE__->add_columns(
  "belief_fk",   { data_type => 'INTEGER', is_nullable => 0, size => undef },
  "type_fk",     { data_type => 'INTEGER', is_nullable => 0, size => undef },
);

__PACKAGE__->set_primary_key( "belief_fk","type_fk" );

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(b2_belief => 'Moksha::Schema::Result::InqBelief', 'belief_fk');
__PACKAGE__->belongs_to(b2_type   => 'Moksha::Schema::Result::InqType', 'type_fk');


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
