package Moksha::Form::Field::Rank;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Field::Text';

apply(
    [
     { 
	 transform => sub {
	     my $value = shift;
	     $value =~ s/^\$//;
	     return $value;
	 }},
     {
	 transform => sub { $_[0] =~ /^[\d+.]+$/ ? sprintf '%.2f', $_[0] : $_[0] },
	 message   => 'Value cannot be converted to a decimal',
     },
     {
	 check => sub { $_[0] =~ /^-?\d+\.?\d*$/ && $_[0] >= 0 && $_[0] <= 5 },
	 message => 'Rank must be a decimal number between 0 and 5'
     }
    ]
    );

1;
