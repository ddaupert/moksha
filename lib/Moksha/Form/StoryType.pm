package Moksha::Form::StoryType;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has_field 'label'    => ( type => 'Text', required => 1, label => 'Label', size => 24 );
has_field 'active'   => ( type => 'Select', default => 1, options => [ { value => 1, label => 'Active' }, { value => 0, label => 'Disabled' } ] );
has_field 'submit'   => ( type => 'Submit' );

no HTML::FormHandler::Moose;

1;
