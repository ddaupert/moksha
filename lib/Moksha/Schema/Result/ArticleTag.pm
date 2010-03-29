package Moksha::Schema::Result::ArticleTag;

use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('article_tag');

__PACKAGE__->add_columns(
    article_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    tag_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key(qw/article_fk tag_fk/);

__PACKAGE__->belongs_to(tag => 'Moksha::Schema::Result::Tag', 'tag_fk');
__PACKAGE__->belongs_to(article => 'Moksha::Schema::Result::Article', 'article_fk');

1;
