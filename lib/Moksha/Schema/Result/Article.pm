package Moksha::Schema::Result::Article;

use strict;
use warnings;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/TimeStamp InflateColumn::DateTime Core/);
__PACKAGE__->table('articles');

__PACKAGE__->add_columns(
 "article_id", { data_type => 'integer',  is_nullable   => 0, is_auto_increment => 1 },
 "ts",         { data_type => 'datetime', is_nullable   => 1, set_on_create => 1, set_on_update => 1 },     
 "title",      { data_type => 'varchar',  is_nullable => 0,   size    => 250    },
 "content",    { data_type => 'text',     is_nullable => 1 },
 "summary",    { data_type => 'text',     is_nullable => 1 },
 "rank",       { data_type => 'decimal',  is_nullable => 1, size => [3,2]   },
);

__PACKAGE__->set_primary_key('article_id');

__PACKAGE__->has_many(article_tags => 'Moksha::Schema::Result::ArticleTag', 'article_fk');
__PACKAGE__->many_to_many(tags => 'article_tags', 'tag');

################
################

=head2 op_by_admin

Can the specified user delete the current object?

=cut

sub op_by_admin {
  my ($self, $user) = @_;

  # Only allow delete if user has one of these roles
  my $has_roles = $user->has_role('is_admin') ||
                  $user->has_role('is_superuser');
  
  return( $has_roles );
}

1;
