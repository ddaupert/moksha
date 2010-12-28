package Moksha::Schema::Result::Photo;

use strict;
use warnings;

use base 'DBIx::Class';

#__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::FS TimeStamp Core/);
__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("photos");
__PACKAGE__->add_columns(
  "id",       { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
  "name",     { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "mime",     { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "uploaded", { data_type => "datetime", set_on_create => 1 },
  "path",     { data_type => "TEXT", is_nullable => 0, size => undef },
  "caption",  { data_type => "TEXT", is_nullable => 0, size => undef },
  "updated",  { data_type => "datetime", set_on_create => 1, set_on_update => 1 },
);

# use Moksha;
#  __PACKAGE__->add_columns(
#  "path",
#      {
#         data_type      => 'TEXT',
#         is_fs_column   => 1,
#         fs_column_path => Moksha->path_to( 'root', 'static', 'photos' ) . ""
#      }
# );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
  "hm_photo_tags", 
  "Moksha::Schema::Result::PhotoTag", 
{ "foreign.photo_fk" => "self.id" });

__PACKAGE__->many_to_many(m2m_photo_tags => 'hm_photo_tags', 'b2_tag');

#
# Set ResultSet Class
#
#__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Photo');

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
