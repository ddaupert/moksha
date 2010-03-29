package Moksha::Schema::Result::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime UTF8Columns TimeStamp Core/);
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "id",        { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
  "fname",     { data_type => "VARCHAR", is_nullable => 0, size => 20 },
  "mname",     { data_type => "VARCHAR", is_nullable => 1, size => 20 },
  "lname",     { data_type => "VARCHAR", is_nullable => 0, size => 20 },
  "username",  { data_type => "VARCHAR", is_nullable => 0, size => 20 },
  "email",     { data_type => "VARCHAR", is_nullable => 0, size => 70 },
  "password",  { data_type => "VARCHAR", is_nullable => 0, size => 20 },
  "is_member", { data_type => "BOOLEAN", is_nullable => 1, size => undef },
  "authcode",  { data_type => "INTEGER", is_nullable => 1, size => undef },
  "active",    { data_type => "INTEGER", is_nullable => 0, default => 1 },
  "created",   { data_type => "datetime", set_on_create => 1 },
  "updated",   { data_type => "datetime", set_on_create => 1, set_on_update => 1 },
);
__PACKAGE__->utf8_columns(qw/fname mname lname username password/);
__PACKAGE__->set_primary_key("id");

#
# Set relationships:
#

__PACKAGE__->has_many(
  "hm_auth_qnas",
  "Moksha::Schema::Result::AuthQnA", 
  { "foreign.user_fk" => "self.id" }
);

__PACKAGE__->has_many(
  "hm_user_roles",
  "Moksha::Schema::Result::UserRole", 
  { "foreign.user_fk" => "self.id" }
);

__PACKAGE__->has_many(
  "hm_user_blogs",
  "Moksha::Schema::Result::Blog", 
  { "foreign.owner_id" => "self.id" }
);

__PACKAGE__->has_many(
"hm_author_stories", 
"Moksha::Schema::Result::StoryAuthor", 
{ "foreign.author_fk" => "self.id"}
);

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above
#   You must already have the has_many() defined to use a many_to_many().
__PACKAGE__->many_to_many(m2m_roles => 'hm_user_roles', 'b2_role');
__PACKAGE__->many_to_many(m2m_stories => 'hm_author_stories', 'b2_story');
__PACKAGE__->many_to_many(m2m_qnas1 => 'hm_auth_qnas', 'b2_quest1');
__PACKAGE__->many_to_many(m2m_qnas2 => 'hm_auth_qnas', 'b2_quest2');

#
# Set ResultSet Class
#
#__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::User');

=head 2 has_role

Check if a user has the specified role

=cut

use Perl6::Junction qw/any/;
sub has_role {
  my ($self, $role) = @_;

  # Does this user posses the required role?
  return any(map { $_->role } $self->m2m_roles) eq $role;
}


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
