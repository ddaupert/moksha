package Moksha::Form::KtyBelief;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has 'user_id'           => ( isa => 'Int', is => 'rw' );

has_field 'belief'      => ( type => 'TextArea', required => 1 );
has_field 'is_true'     => ( type => 'Text', label => 'Is it true', required => 1 );
has_field 'abs_true'    => ( type => 'Text', label => 'Do you absolutely know if it is true', required => 1 );
has_field 'how_react'   => ( type => 'TextArea', label => 'How do you react when you believe that thought', required => 1 );
has_field 'who_be'      => ( type => 'TextArea', label => 'Who would you be without that thought', required => 0, );
has_field 'turn_opp'    => ( type => 'TextArea', label => 'Turn it around to the opposite', required => 1 );
has_field 'turn_self'   => ( type => 'TextArea', label => 'Turn it around to the self', required => 1 );
has_field 'turn_oth'    => ( type => 'TextArea', label => 'Turn it around to the other', required => 1 );
has_field 'user_id'     => ( type => 'Hidden', required => 1 );
has_field 'submit'      => ( type => 'Submit' );


after 'setup_form' => sub {
    my $self = shift;
    my $item = $self->item;

    $self->field('user_id')->value( $self->user_id );

};

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
