package Moksha::Controller::Comments;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Comments;
use Scope::Guard 'guard';

sub save : Private {
    my ($self, $c, $item) = @_;
    
    # get all comments
    my $guard = guard {
        $c->stash->{comments} = [ $c->model('DB::Comments')->search( {
            object_type => $item->object_type,
            object_id   => $item->object_id
        } )->all ];
    };

    my $form = Moksha::Form::Comments->new( item => $item );
    $c->stash->{comment_form} = $form;
    
    my %hash = (
        params => $c->req->params,
    );
    
    return unless $form->process( %hash );
    $form->clear; # clear after insert/update
    $c->stash->{comment_posted} = 1;
}

1;