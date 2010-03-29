package Moksha::Controller::User;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::User;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /user
sub base :Chained("/") :PathPart("user") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{user_rs} 
    = $c->model('DB::User');
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("User ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{user_obj} = $c->stash->{user_rs}->find($id)
  || $c->detach('not_found');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{users} 
    = $c->stash->{user_rs}->search({}, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'user/list.tt2';
}

################
################

sub view : Chained('id') Args(0) {}

################
################

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{user_obj} = $c->stash->{user_rs}->new_result({});
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

    my $form = Moksha::Form::User->new( item => $c->stash->{user_obj}  );

    $c->stash( form => $form, template => 'user/save.tt2' );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    $c->stash->{template} = 'user/save.tt2';
    $c->flash->{info_msg} = "User saved!";
    $c->redirect_to_action('User', 'list');
}

################
################

=head2 delete
    
Delete user

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{user_obj}->op_by_admin($c->user->get_object);

    # Use the user object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{user_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "User deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('User', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "User not found!";
    $c->detach('list');
}

1;
