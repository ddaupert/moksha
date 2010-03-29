package Moksha::Schema::Result::EntryTag;

use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('entry_tag');

__PACKAGE__->add_columns(
    entry_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    tag_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key(qw/entry_fk tag_fk/);

__PACKAGE__->belongs_to(b2_tag => 'Moksha::Schema::Result::Tag', 'tag_fk');
__PACKAGE__->belongs_to(b2_entry => 'Moksha::Schema::Result::Entry', 'entry_fk');

1;
