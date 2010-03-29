package Moksha::Schema::Result::Author;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/UTF8Columns Core/);
__PACKAGE__->table("authors");
__PACKAGE__->add_columns(
  "id",       { data_type => "INTEGER", is_nullable => 0, size => undef, is_auto_increment => 1 },
  "prefix",   { data_type => "VARCHAR", is_nullable => 1, size => 10 },
  "fname",    { data_type => "VARCHAR", is_nullable => 1, size => 20 },
  "mname",    { data_type => "VARCHAR", is_nullable => 1, size => 20 },
  "lname",    { data_type => "VARCHAR", is_nullable => 0, size => 20 },
  "suffix",   { data_type => "VARCHAR", is_nullable => 1, size => 10 },
  "known_as", { data_type => "VARCHAR", is_nullable => 0, size => 50 },
);
__PACKAGE__->utf8_columns(qw/prefix fname mname lname suffix known_as/);
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
"hm_book_author", 
"Moksha::Schema::Result::BookAuthor", 
{ "foreign.author_fk" => "self.id" });

__PACKAGE__->has_many(
"hm_quotes", 
"Moksha::Schema::Result::Quote", 
{ "foreign.author_fk" => "self.id" });


# many_to_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of has_many() relationship this many_to_many() is shortcut for
#     3) Name of belongs_to() relationship in model class of has_many() above
#   You must already have the has_many() defined to use a many_to_many().
__PACKAGE__->many_to_many(m2m_books => 'hm_book_author', 'b2_book');


#
# Helper methods
#

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

sub full_name {
    my ($self) = @_;

    return $self->first_name . ' ' . $self->last_name;
}


1;
