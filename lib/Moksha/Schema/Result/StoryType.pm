package Moksha::Schema::Result::StoryType;

use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/UTF8Columns Core/);
__PACKAGE__->table('story_type');

__PACKAGE__->add_columns(
  "id",       { data_type => 'INTEGER', is_nullable => 0, is_auto_increment => 1 },
  "label",    { data_type => 'VARCHAR', is_nullable => 0, size => 20 },
  "active",   { data_type => 'INTEGER', is_nullable => 0, size => 1, default => 1 },
);

__PACKAGE__->utf8_columns(qw/label/);
__PACKAGE__->set_primary_key("id");

1;
