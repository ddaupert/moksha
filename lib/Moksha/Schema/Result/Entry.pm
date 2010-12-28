package Moksha::Schema::Result::Entry;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("entries");
__PACKAGE__->add_columns(
  "id",         { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
  "blog_id",    { data_type => "INTEGER", is_nullable => 0, size => undef },
  "content",    { data_type => "TEXT",    is_nullable => 0, size => undef },
  "view_perms", { data_type => "INTEGER", is_nullable => 1, size => undef },
  "active",     { data_type => "INTEGER", is_nullable => 0, size => undef, default => 1 },
  "created",    { data_type => "datetime", set_on_create => 1 },
  "updated",    { data_type => "datetime", set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(b2_blog => 'Moksha::Schema::Result::Blog', 'blog_id');

__PACKAGE__->has_many(
  "hm_entry_tags", 
  "Moksha::Schema::Result::EntryTag", 
{ "foreign.entry_fk" => "self.id" });

__PACKAGE__->many_to_many(m2m_entry_tags => 'hm_entry_tags', 'b2_tag');


#
# Set ResultSet Class
#
# __PACKAGE__->resultset_class('Moksha::Schema::ResultSet::BlogEntry');

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
