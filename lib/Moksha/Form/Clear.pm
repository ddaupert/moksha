package Moksha::Form::Clear;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has 'user_id'           => ( isa => 'Int', is => 'rw' );

has_field 'situation'   => ( type => 'TextArea', label => 'Situation', required => 1 );
has_field 'charge'      => ( type => 'Text',     label => 'Charge', required => 1 );
has_field 'intensity'   => ( type => 'Select',   label => 'Intensity', required => 1,
options => [
            { value => 1, label => '1'}, 
            { value => 2, label => '2'},
            { value => 3, label => '3'},
            { value => 4, label => '4'},
            { value => 5, label => '5'}
           ] );
has_field 'belief'      => ( type => 'TextArea', label => 'Belief', required => 1 );
has_field 'is_done'     => ( type => 'Select',   label => 'Done?', required => 1,
options => [
            { value => 'y', label => 'Yes'}, 
            { value => 'n', label => 'No'},
           ] );

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
