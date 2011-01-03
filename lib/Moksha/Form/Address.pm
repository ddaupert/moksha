package Moksha::Form::Address;

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

no HTML::FormHandler::Moose;
__PACKAGE__->meta->make_immutable;

1;
