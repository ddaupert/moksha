package Moksha::Schema::Result::StoryTag;

use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('story_tag');

__PACKAGE__->add_columns(
    story_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    tag_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key(qw/story_fk tag_fk/);

__PACKAGE__->belongs_to(b2_story => 'Moksha::Schema::Result::Story', 'story_fk');
__PACKAGE__->belongs_to(b2_tag => 'Moksha::Schema::Result::Tag', 'tag_fk');

1;
