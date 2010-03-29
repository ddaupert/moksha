package Moksha::Schema::Result::Tag;

use strict;
use warnings;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/UTF8Columns Core/);
__PACKAGE__->table('tags');

__PACKAGE__->add_columns(
 "tag_id",        { data_type => "integer", is_nullable => 0, is_auto_increment => 1 },
 "name",          { data_type => "varchar", is_nullable => 0, size => 100   },
 "user_id",       { data_type => "INTEGER", is_nullable => 1, size => undef },
 "blog_entry_id", { data_type => "INTEGER", is_nullable => 1, size => undef },
 "quote_id",      { data_type => "INTEGER", is_nullable => 1, size => undef },  
 "photo_id",      { data_type => "INTEGER", is_nullable => 1, size => undef },
);

__PACKAGE__->utf8_columns(qw/name/);

__PACKAGE__->set_primary_key('tag_id');

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
