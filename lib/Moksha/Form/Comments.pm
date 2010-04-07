package Moksha::Form::Comments;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has 'object_type' => ( isa => 'Str', is => 'rw' );
has 'object_id'   => ( isa => 'Int', is => 'rw' );
has 'owner_id'    => ( isa => 'Int', is => 'rw' );

has_field 'title'    => ( type => 'Text', required => 1 );
has_field 'content'  => ( type => 'TextArea', required => 1 );

has_field 'submit'   => ( type => 'Submit' );

sub filter_content {
    my $content = shift;
    return unless $content;
    $content =~ s{\r}{}g;
}

no HTML::FormHandler::Moose;

1;
