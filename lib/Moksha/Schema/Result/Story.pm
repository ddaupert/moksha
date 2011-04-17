package Moksha::Schema::Result::Story;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "Tree::AdjacencyList",
                              "InflateColumn::DateTime", 
                              "TimeStamp", 
                              "Core" 
                            );
# Set the table name
__PACKAGE__->table('stories');
# Set columns in table
__PACKAGE__->add_columns(
  "id",            { data_type => 'INTEGER', is_nullable => 0, is_auto_increment => 1 },
  "inspire_story", { data_type => 'INTEGER', is_nullable => 1, size => undef },
  "inspire_quote", { data_type => 'INTEGER', is_nullable => 1, size => undef },
  "inspire_photo", { data_type => 'INTEGER', is_nullable => 1, size => undef },
  "active",        { data_type => 'INTEGER', is_nullable => 0, size => undef, 
                     default => 1 },
  "status",        { data_type => "INTEGER", is_nullable => 0, size => 1, default => 0 },
  "type",          { data_type => "INTEGER", is_nullable => 0, size => undef, default => 0 },
  "title",         { data_type => "VARCHAR", is_nullable => 0, size => 100 },
  "summary",       { data_type => "TEXT", is_nullable => 1, size => undef },
  "content",       { data_type => "TEXT", is_nullable => 0, size => undef },
  "created",       { data_type => "datetime", set_on_create => 1 },
  "updated",       { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/id/);

# Set parent id for Tree::AdjacencyList
__PACKAGE__->parent_column('inspire_story');

# maintain a consistent tree structure
__PACKAGE__->repair_tree( 1 );

# Set relationships for Tree::AdjacencyList
#belongs_to():
#  args:
#    1) Name of relationship, DBIC will create accessor with this name
#    2) Name of the model class referenced by this relationship
#    3) Column name in *this* table
__PACKAGE__->belongs_to(
  "b2_inspire_story",
  "Moksha::Schema::Result::Story",
  { id => "inspire_story" },
);
__PACKAGE__->belongs_to(
  "b2_inspire_quote",
  "Moksha::Schema::Result::Quote",
  { id => "inspire_quote" },
);


# __PACKAGE__->belongs_to(
#   "b2_story_versions",
#   "Moksha::Schema::Result::StoryVersion",
#   { id => "story_id" },
# );


#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table
# __PACKAGE__->has_many( "hm_story_versions", 
#                        "Moksha::Schema::Result::StoryVersion",
#                      { "foreign.story_id" => "self.id", 
#                      },
# );

# example from Book
# __PACKAGE__->has_many(book_authors => 'MyApp::Schema::Result::BookAuthor', 'book_id');
# __PACKAGE__->many_to_many(authors => 'book_authors', 'author');

__PACKAGE__->has_many(
"hm_story_authors", 
"Moksha::Schema::Result::StoryAuthor", 
{ "foreign.story_fk" => "self.id" }
);

__PACKAGE__->many_to_many(m2m_authors => 'hm_story_authors', 'b2_author');


__PACKAGE__->has_many(
  "hm_story_tags", 
  "Moksha::Schema::Result::StoryTag", 
{ "foreign.story_fk" => "self.id" });

__PACKAGE__->many_to_many(m2m_story_tags => 'hm_story_tags', 'b2_tag');

#
# Set ResultSet Class
#
# __PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Story');

=head1 NAME

Moksha::Schema::Result::Story ‐ A model object representing a story.

=head1 DESCRIPTION

This is an object that represents a row in the story table of the application database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through Moksha::Schema.
Offline utilities may wish to use this class directly.

=cut

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
