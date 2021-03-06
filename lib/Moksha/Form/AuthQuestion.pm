package Moksha::Form::AuthQuestion;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has_field 'question' => ( type => 'Text', size => 100,required => 1 );
has_field 'active'   => ( type => 'Hidden', required => 1, default => 1 );
has_field 'submit'   => ( type => 'Submit' );

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
