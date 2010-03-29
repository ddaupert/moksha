package Moksha::Schema::Result::QuoteTag;

use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('quote_tag');

__PACKAGE__->add_columns(
    quote_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    tag_fk => {
        data_type   => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key(qw/quote_fk tag_fk/);

__PACKAGE__->belongs_to(b2_tag => 'Moksha::Schema::Result::Tag', 'tag_fk');
__PACKAGE__->belongs_to(b2_quote => 'Moksha::Schema::Result::Quote', 'quote_fk');

1;
