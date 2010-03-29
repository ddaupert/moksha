package Moksha::Form::Article;

use strict;
use warnings;
use HTML::FormHandler::Moose;

extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

has_field 'title'    => ( type => 'Text', required => 1 );
has_field 'ts'       => ( type => 'Date', label => 'Published Date' );
has_field 'content'  => ( type => 'TextArea', required => 0 );
has_field 'tags_str' => ( type => 'TextArea', required => 0, label => 'Tags' );
has_field 'rank'     => ( type => '+Moksha::Form::Field::Rank', default => '0.00' );

has_field 'submit'   => ( type => 'Submit' );

after 'setup_form' => sub {
    my $self = shift;
    my $item = $self->item;

    $self->field('tags_str')->value(
	join ', ', 
        $item->tags->search({}, { order_by => 'name' })->get_column('name')->all
    );
};

around 'update_model' => sub {
    my $orig = shift;
    my $self = shift;
    my $item = $self->item;
    
    $self->schema->txn_do(sub {	
	$orig->($self, @_);

	my @tags = split /\s*,\s*/, $self->field('tags_str')->value;

	$item->article_tags->delete;
	$item->article_tags->create({ tag => { name => $_ } })
	    foreach (@tags);

	my $summary = generate_symmary($item->content);
	$item->update({ summary => $summary }) if $summary;
    });
};

sub generate_symmary {
    my $content = shift;
    return unless $content;

    # eliminate html tags
    $content =~ s/<[^>]+>/ /g;
    # trim whitespace
    $content =~ s/\s{2,}/ /g;
    
    my $len = length $content;
    $content = substr($content, 0, 200) . ($len > 200 ? '...' : '');
    return $content;
}

no HTML::FormHandler::Moose;

1;
