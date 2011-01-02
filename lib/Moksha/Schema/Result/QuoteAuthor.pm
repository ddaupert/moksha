package Moksha::Schema::Result::QuoteAuthor;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table("quote_authors");
__PACKAGE__->add_columns(
  "quote_fk",   { data_type => "INTEGER", is_nullable => 0, size => undef },
  "author_fk", { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("quote_fk", "author_fk");



#
# Set relationships:
#

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(b2_quote => 'Moksha::Schema::Result::Quote', 'quote_fk');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to(b2_author => 'Moksha::Schema::Result::Author', 'author_fk');



1;
