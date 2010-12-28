package Moksha::Schema::Result::InqSituation;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("inq_situations");
__PACKAGE__->add_columns(
  "id",         { data_type => 'INTEGER', is_nullable => 0, is_auto_increment => 1 },
#   "inquiry_fk", { data_type => 'INTEGER', is_nullable => 0, size => undef },
  "user_id",    { data_type => 'INTEGER', is_nullable => 0, size => undef },
  "situation",  { data_type => 'TEXT', is_nullable => 0, size => undef },
  "created",    { data_type => 'datetime', set_on_create => 1 },
  "updated",    { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->set_primary_key("id");

#
# Set relationships:
#

# __PACKAGE__->belongs_to(b2_inquiry => 'Moksha::Schema::Result::Inquiry', 'inquiry_fk');

__PACKAGE__->belongs_to(b2_users => 'Moksha::Schema::Result::User', 'user_id');

#
# Set ResultSet Class
#
# __PACKAGE__->resultset_class('Moksha::Schema::ResultSet::InqSituation');

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
