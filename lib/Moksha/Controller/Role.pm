package Moksha::Controller::Role;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Role;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /role
sub base :Chained("/") :PathPart("role") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{role_rs} 
    = $c->model('DB::Role');
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{role_obj} = $c->stash->{role_rs}->find($id)
  || $c->detach('not_found');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{roles} 
    = $c->stash->{role_rs}->search({}, 
                            { order_by => 'role desc' });

    $c->stash->{template} = 'role/list.tt2';
}

################
################

sub show : Chained('id') Args(0) {}

################
################

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{role_obj} = $c->stash->{role_rs}->new_result({});
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

  if ($c->check_user_roles('is_superuser') ||
      $c->check_user_roles('is_admin') 
    ) {

    my $form = Moksha::Form::Role->new( item => $c->stash->{role_obj}  );

    $c->stash( form => $form, template => 'role/save.tt2' );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    $c->stash->{template} = 'role/save.tt2';
    $c->flash->{info_msg} = "Role saved!";
    $c->redirect_to_action('Role', 'list');

  } 
  else {
      $c->flash->{status_msg} = "Unauthorized";
      return;
  }


}

################
################

=head2 delete
    
Delete a role

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{role_obj}->op_by_admin($c->user->get_object);

    # Use the role object saved by 'object' and delete it along
    # with related items
    $c->stash->{role_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Role deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Role', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Role not found!";
    $c->detach('list');
}

1;
