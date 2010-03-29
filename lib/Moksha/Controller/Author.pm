package Moksha::Controller::Author;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Author;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /author
sub base :Chained("/") :PathPart("author") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{author_rs} 
    = $c->model('DB::Author');
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{author_obj} = $c->stash->{author_rs}->find($id)
      || $c->detach('not_found');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{authors} 
    = $c->stash->{author_rs}->search({}, 
                            { order_by => 'lname desc' });

    $c->stash->{template} = 'author/list.tt2';
}

################
################

sub show : Chained('id') Args(0) {}

################
################

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{author_obj} = $c->stash->{author_rs}->new_result({});
    $c->forward('save');
}

################
################

sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $form = Moksha::Form::Author->new( item => $c->stash->{author_obj}  );

    my $all_tags = $c->model('DB::Tag')->search({}, { order_by => 'name' });
    $c->stash( form => $form, template => 'author/save.tt2', m2m_tags => $all_tags );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    $c->stash->{template} = 'author/save.tt2';
    $c->flash->{info_msg} = "Author saved!";
    $c->redirect_to_action('Author', 'list');
}

################
################

=head2 delete
    
Delete author

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{author_obj}->op_by_admin($c->user->get_object);

    # Use the author object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{author_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Author deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Author', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Author not found!";
    $c->detach('list');
}

1;
