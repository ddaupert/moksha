package Moksha::Schema::Result::Quote;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime TimeStamp Core/);
__PACKAGE__->table('quotes');

__PACKAGE__->add_columns(
"id",        { data_type => 'INTEGER', is_nullable => 0, size => undef, is_auto_increment => 1 },
"quote",     { data_type => 'TEXT',    is_nullable => 0, size => undef },
"posted_by", { data_type => 'INTEGER', is_nullable => 1, size => undef },
"active",    { data_type => 'INTEGER', is_nullable => 0, size => undef, default_value => '1'},
# Enable automatic date handling
"created",   { data_type => 'datetime', set_on_create => 1 },
"updated",   { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->set_primary_key(qw/id/);

#
# Set ResultSet Class
#
#__PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Quote');

# has_many():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *foreign* table (aka, foreign key in peer table)
__PACKAGE__->has_many(
  "hm_quote_tags", 
  "Moksha::Schema::Result::QuoteTag", 
{ "foreign.quote_fk" => "self.id" });

__PACKAGE__->many_to_many(m2m_quote_tags => 'hm_quote_tags', 'b2_tag');

# belongs_to():
#   args:
#     1) Name of relationship, DBIC will create accessor with this name
#     2) Name of the model class referenced by this relationship
#     3) Column name in *this* table
__PACKAGE__->belongs_to('b2_users' => 'Moksha::Schema::Result::User', 'posted_by');


=head1 NAME

Moksha::Schema::Result::Quote ‐ A model object representing a quote.

=head1 DESCRIPTION

This is an object that represents a row in the ’quote’ table of the application database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through Catapult::Model::CatapultDB.
Offline utilities may wish to use this class directly.

=cut

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

# =item user_tags 
# 
# Return tags for this quote used by user.
# 
# =cut
# 
# sub user_tags {
#     my ( $self, $user ) = @_;
#     my (@tags) = $self->result_source->related_source('tags')->resultset
# 	->search({ 
# 	    quote=>$self->id, 
# 	    person=> $user,
# 	},{
#              select   => [ 'me.id','me.tag', 'count(me.tag) as refcount' ],
#              as       => [ 'id','tag','refcount' ],
#              order_by => [ 'refcount' ],
# 	     group_by => [ 'tag', 'me.id' ],
# 	});
#     return @tags;
# }
# 
# =item others_tags
# 
# Return tags for this quote used by people other than <user>.
# 
# =cut
# 
# sub others_tags {
#     my ( $self, $user ) = @_;
#     my (@tags) = $self->result_source->related_source('tags')->resultset
# 	->search({ 
# 	    quote=>$self->id, 
# 	    person=> {'!=', $user}
# 	},{
#              select   => [ 'me.id','me.tag', 'count(me.tag) as refcount' ],
#              as       => [ 'id','tag','refcount' ],
#              order_by => [ 'refcount' ],
# 	     group_by => [ 'tag', 'me.id' ],
# 	});
#     return @tags;
# }
# 
# =item tags_with_counts
# 
# Return tags for this quote used by any user.
# 
# =cut
# 
# sub tags_with_counts {
#     my ( $self, $user ) = @_;
#     my (@tags) = $self->result_source->related_source('tags')->resultset
# 	->search({ 
# 	    quote=>$self->id, 
# 	},{
#              select   => [ 'me.id','me.tag', 'count(me.tag) as refcount' ],
#              as       => [ 'id','tag','refcount' ],
#              order_by => [ 'refcount' ],
# 	     group_by => [ 'tag', 'me.id' ],
# 	});
#     return @tags;
# }
# =item get_tag_cloud
# 
# Return tags for this quote used by any user.
# 
# =cut
# 
# sub get_tag_cloud {
#   my ( $self ) = @_;
# 
#   my @quotes_objects = $self->result_source->resultset->search(
#     {
#       'me.active' => 1,
#     },
#     {
#        select   => [ 'me.id','me.quote' ], 
#     }
#   );
# 
#   foreach my $quote_obj ( @quotes_objects ) {
# 
#   }
#     return @quotes_objects;
# }

1;
