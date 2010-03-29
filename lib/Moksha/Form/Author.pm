package Moksha::Form::Author;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has_field 'prefix'     => ( type => 'Text', label => 'Prefix',     required => 0 );
has_field 'fname'      => ( type => 'Text', label => 'First Name', required => 0 );
has_field 'mname'      => ( type => 'Text', label => 'Middle',     required => 0 );
has_field 'lname'      => ( type => 'Text', label => 'Last Name',  required => 1 );
has_field 'suffix'     => ( type => 'Text', label => 'Suffix',     required => 0 );
has_field 'known_as'   => ( type => 'Text', label => 'Known As',   required => 1 );
has_field 'submit'     => ( type => 'Submit' );


# after 'setup_form' => sub {
#     my $self = shift;
#     my $item = $self->item;
# 
#     $self->field('tags_str')->value(
# 	join ', ', 
#         $item->m2m_tags->search({}, { order_by => 'name' })->get_column('name')->all
#     );
# };

# around 'update_model' => sub {
#     my $orig = shift;
#     my $self = shift;
#     my $item = $self->item;
#     
#     $self->schema->txn_do(sub {	
# 	$orig->($self, @_);
# 
# 	my @tags = split /\s*,\s*/, $self->field('tags_str')->value;
# 
# 	$item->hm_quote_tags->delete;
#   $item->hm_quote_tags->create({ b2_tag => { name => $_ } })
# 	    foreach (@tags);
#     });
# };


no HTML::FormHandler::Moose;

1;
