package Moksha::Schema::Result::Blog;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("blogs");
__PACKAGE__->add_columns(
  "id",          { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
  "name",        { data_type => "VARCHAR", is_nullable => 0, size => 100 },
  "description", { data_type => "VARCHAR", is_nullable => 1, size => 255 },
  "owner_id",    { data_type => "INTEGER", is_nullable => 0, size => undef },
  "active",      { data_type => "INTEGER", is_nullable => 0, size => undef, default => 1 },
  "created",     { data_type => "datetime", set_on_create => 1 },
  "updated",     { data_type => "datetime", set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(b2_owner => 'Moksha::Schema::Result::User', 'owner_id');


__PACKAGE__->has_many(
 "hm_blog_entries",
 "Moksha::Schema::Result::Entry",
 { "foreign.blog_id" => "self.id" },
);


#
# Set ResultSet Class
#
# __PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Blog');

################
################

=head2 op_by_admin

Can the specified user delete the current object?

=cut

sub op_by_admin {
  my ($self, $user) = @_;

  # Only allow delete if user has one of these roles
  my $has_roles = $user->has_role('admin') ||
                  $user->has_role('superuser');
  
  return( $has_roles );
}

1;
