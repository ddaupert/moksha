package Moksha::Schema::Result::StoryAuthor;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table("story_authors");
__PACKAGE__->add_columns(
  "story_fk",   { data_type => "INTEGER", is_nullable => 0, size => undef },
  "author_fk", { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("story_fk", "author_fk");



#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table


__PACKAGE__->belongs_to(b2_story => 'Moksha::Schema::Result::Story', 'story_fk');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(b2_author => 'Moksha::Schema::Result::User', 'author_fk');



1;
