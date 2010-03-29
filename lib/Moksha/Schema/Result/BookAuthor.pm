package Moksha::Schema::Result::BookAuthor;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table("book_authors");
__PACKAGE__->add_columns(
  "book_fk",   { data_type => "INTEGER", is_nullable => 0, size => undef },
  "author_fk", { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("book_fk", "author_fk");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-03-08 16:39:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QLCxY5CRlWHFoiTgkAvucA


# You can replace this text with custom content, and it will be preserved on regeneration

#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(b2_book => 'Moksha::Schema::Result::Book', 'book_fk');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(b2_author => 'Moksha::Schema::Result::Author', 'author_fk');



1;
