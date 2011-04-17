package Moksha::Schema::Result::Book;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("books");
__PACKAGE__->add_columns(
  "id",       { data_type => "INTEGER", is_nullable => 0, size => undef, is_auto_increment => 1 },
  "title",    { data_type => "VARCHAR", is_nullable => 0, size => 100 },
  "subtitle", { data_type => "VARCHAR", is_nullable => 1, size => 100 },
  "posted_by",{ data_type => "INTEGER", is_nullable => 1, size => undef },
  "url",      { data_type => "TEXT",    is_nullable => 1, size => undef },
  "rating",   { data_type => "INTEGER", is_nullable => 1, size => undef },
  "active",   { data_type => "INTEGER", is_nullable => 0, size => undef, default => 1 },
  "created",  { data_type => "datetime", set_on_create => 1 },
  "updated",  { data_type => "datetime", set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->set_primary_key("id");

#
# Set relationships:
#

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table (aka, foreign key in peer table)
__PACKAGE__->has_many(
"hm_book_authors", 
"Moksha::Schema::Result::BookAuthor", 
{ "foreign.book_fk" => "self.id" });

# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above
#   You must already have the has_many() defined to use a many_to_many().
__PACKAGE__->many_to_many(m2m_authors => 'hm_book_authors', 'b2_author');

__PACKAGE__->has_many(
  "hm_book_tags", 
  "Moksha::Schema::Result::BookTag", 
{ "foreign.book_fk" => "self.id" });

__PACKAGE__->many_to_many(m2m_tags => 'hm_book_tags', 'b2_tag');

__PACKAGE__->belongs_to(b2_users => 'Moksha::Schema::Result::User', 'posted_by');

#
# Set ResultSet Class
#
__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Book');


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
