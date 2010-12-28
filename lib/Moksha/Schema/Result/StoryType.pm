package Moksha::Schema::Result::StoryType;

use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('story_type');

__PACKAGE__->add_columns(
  "id",       { data_type => 'INTEGER', is_nullable => 0, is_auto_increment => 1 },
  "label",    { data_type => 'VARCHAR', is_nullable => 0, size => 20 },
  "active",   { data_type => 'INTEGER', is_nullable => 0, size => 1, default => 1 },
);

__PACKAGE__->set_primary_key("id");

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
