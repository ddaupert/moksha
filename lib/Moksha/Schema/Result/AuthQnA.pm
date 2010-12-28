package Moksha::Schema::Result::AuthQnA;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table("auth_qna");
__PACKAGE__->add_columns(
  "id",        { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
  "user_fk",   { data_type => "INTEGER", is_nullable => 0, size => undef },
  "quest1_fk", { data_type => "INTEGER", is_nullable => 1, size => undef },
  "answer1",   { data_type => "VARCHAR", is_nullable => 0, size => 255 },
  "quest2_fk", { data_type => "INTEGER", is_nullable => 1, size => undef },
  "answer2",   { data_type => "VARCHAR", is_nullable => 0, size => 255 },
);

__PACKAGE__->set_primary_key("id");

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table

__PACKAGE__->belongs_to(b2_users => "Moksha::Schema::Result::User", "user_fk");

__PACKAGE__->belongs_to(b2_quest1 => "Moksha::Schema::Result::AuthQuestion",
"quest1_fk");

__PACKAGE__->belongs_to(b2_quest2 => "Moksha::Schema::Result::AuthQuestion",
"quest2_fk");

#
# Set ResultSet Class
#
#__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::AuthQnA');

=head2 delete_allowed_by

Can the specified user delete the current item?

=cut

sub delete_allowed_by {
  my ($self, $user) = @_;

  # Only allow delete if user has 'admin' role
  return $user->has_role('admin');
}

1;
