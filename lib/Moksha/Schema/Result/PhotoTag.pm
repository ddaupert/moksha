package Moksha::Schema::Result::PhotoTag;

use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('photo_tag');

__PACKAGE__->add_columns(
    photo_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    tag_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key(qw/photo_fk tag_fk/);

__PACKAGE__->belongs_to(b2_tag => 'Moksha::Schema::Result::Tag', 'tag_fk');
__PACKAGE__->belongs_to(b2_photo => 'Moksha::Schema::Result::Photo', 'photo_fk');

1;
