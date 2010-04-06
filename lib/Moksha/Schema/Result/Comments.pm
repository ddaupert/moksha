package Moksha::Schema::Result::Comments;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "InflateColumn::DateTime", 
                              "TimeStamp", 
                              "UTF8Columns",
                              "Core" 
                            );
# Set the table name
__PACKAGE__->table('comments');
# Set columns in table
__PACKAGE__->add_columns(
  "id",            { data_type => 'INTEGER', is_nullable => 0, is_auto_increment => 1 },
  "object_type",   { data_type => 'VARCHAR', is_nullable => 1, size => 12 },
  "object_id",     { data_type => 'INTEGER', is_nullable => 1, size => undef },
  "owner_id",      { data_type => 'INTEGER', is_nullable => 1, size => undef },
  "active",        { data_type => 'INTEGER', is_nullable => 0, size => undef, 
                     default => 1 },
  "title",         { data_type => "VARCHAR", is_nullable => 0, size => 100 },
  "content",       { data_type => "TEXT", is_nullable => 0, size => undef },
  "created",       { data_type => "datetime", set_on_create => 1 },
  "updated",       { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

__PACKAGE__->utf8_columns(qw/title content/);

# Set the primary key for the table
__PACKAGE__->set_primary_key(qw/id/);

__PACKAGE__->belongs_to(b2_owner => 'Moksha::Schema::Result::User', 'owner_id');

#
# Set ResultSet Class
#
# __PACKAGE__->resultset_class('Moksha::Schema::ResultSet::Comment');

=head1 NAME

Moksha::Schema::Result::Comments ‐ A model object representing a comment.

=head1 DESCRIPTION

This is an object that represents a row in the comment table of the application database.  It uses DBIx::Class (aka, DBIC) to do ORM.

For Catalyst, this is designed to be used through Moksha::Schema.
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

1;
