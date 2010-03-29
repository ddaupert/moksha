package Moksha::Schema::Result::Clear;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime UTF8Columns TimeStamp Core/);
__PACKAGE__->table("clears");
__PACKAGE__->add_columns(
  "id",        { data_type => "INTEGER", is_nullable => 0, size => undef, 
                 is_auto_increment => 1 },
  "user_id",   { data_type => "INTEGER", is_nullable => 0, size => undef },
  "situation", { data_type => "TEXT",    is_nullable => 0, size => undef },
  "charge",    { data_type => "VARCHAR", is_nullable => 0, size => undef },
  "intensity", { data_type => "INTEGER", is_nullable => 0, size => undef },
  "belief",    { data_type => "TEXT",    is_nullable => 0, size => undef },
  "is_done",   { data_type => "BOOL",    is_nullable => 0, size => undef },

  # Enable automatic date handling
  "created",  { data_type => "datetime", set_on_create => 1 },
  "updated",  { data_type => "datetime", set_on_create => 1, set_on_update => 1 },
);
__PACKAGE__->utf8_columns(qw/situation charge belief/);
__PACKAGE__->set_primary_key("id");

#
# Set relationships:
#

__PACKAGE__->belongs_to(b2_users => 'Moksha::Schema::Result::User', 'user_id');

#
# Set ResultSet Class
#
#__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Books');


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
