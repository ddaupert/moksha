package Moksha::Form::User::Blog;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has 'owner_id'          => ( isa => 'Int', is => 'rw' );
has '+item_class'       => ( default => 'Blog' );
has_field 'name'        => ( type => 'Text', required => 1 );
has_field 'description' => ( type => 'TextArea', required => 1, label => 'Purpose' );
has_field 'owner_id'    => ( type => 'Hidden', required => 1 );
has_field 'active'      => ( type => 'Hidden', required => 1, default => 1 );

has_field 'submit'      => ( type => 'Submit' );

after 'setup_form' => sub {
    my $self = shift;
    my $item = $self->item;

  $self->field('owner_id')->value( $self->owner_id );
};

no HTML::FormHandler::Moose;

1;
