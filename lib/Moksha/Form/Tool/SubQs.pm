package Moksha::Form::Tool::SubQs;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has '+item_class'       => ( default => 'Ex_belief_sub_q' );
has_field 'name'        => ( type => 'Text', required => 1 );
has_field 'submit'      => ( type => 'Submit' );

# after 'setup_form' => sub {
#     my $self = shift;
#     my $item = $self->item;
# 
#   $self->field('owner_id')->value( $self->owner_id );
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
# 	$item->hm_book_tags->delete;
#   $item->hm_book_tags->create({ b2_tag => { name => $_ } })
# 	    foreach (@tags);
#     });
# };


no HTML::FormHandler::Moose;

1;
