package Moksha::Schema::Result::AuthQuestion;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table("auth_questions");
__PACKAGE__->add_columns(
  "id",       { data_type => "INTEGER", is_nullable => 0, is_auto_increment => 1 },
  "question", { data_type => "VARCHAR", is_nullable => 0, size => 100 },
  "active",   { data_type => "INTEGER", is_nullable => 0, size => undef, default => 1 },
  "created",  { data_type => "datetime", set_on_create => 1 },
  "updated",  { data_type => "datetime", set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->set_primary_key("id");


#
# Set ResultSet Class
#
#__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::AuthQuestion');

1;
