package Moksha::Form::Address;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has_field 'address1'   => ( type => 'Text', label => 'Address1', required => 1 );
has_field 'address2'   => ( type => 'Text', label => 'Address2', required => 0 );
has_field 'city'       => ( type => 'Text', label => 'City', required => 1 );
has_field 'state'      => ( type => 'Text', label => 'State', required => 1 );
has_field 'zip'        => ( type => 'Text', label => 'Zip', required => 1 );
has_field 'phone_home' => ( type => 'Text', label => 'Home Phone', required => 0 );
has_field 'phone_work' => ( type => 'Text', label => 'Work Phone', required => 0 );
has_field 'phone_cell' => ( type => 'Text', label => 'Mobile Phone', required => 0 );
has_field 'submit'     => ( type => 'Submit' );

has '+dependency' => ( default => sub {
        [
            ['address1', 'city', 'state', 'zip' ],
        ],
    }
);


# sub validate_password {
#   my ( $self, $field ) = @_;
#   $field->add_error("passwords do not match")
#       if ( $field->value ne $self->value->password2 );
# }

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
