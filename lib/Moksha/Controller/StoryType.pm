package Moksha::Controller::StoryType;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::StoryType;

# url /admin/story
sub base :Chained("/") :PathPart("story_type") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{storytype_rs} = $c->model('DB::StoryType');
}

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{storytype_obj} = $c->stash->{storytype_rs}->find($id)
  || $c->detach('not_found');
}

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{storytypes} 
    = $c->stash->{storytype_rs}->search();

}

sub show : Chained('id') Args(0) {}

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{storytype_obj} = $c->stash->{storytype_rs}->new_result({});
    $c->forward('save');
}

sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

sub save : Private {
    my ($self, $c) = @_;

  if ($c->check_user_roles('is_superuser') ||
      $c->check_user_roles('is_admin') 
    ) {

    my $form = Moksha::Form::StoryType->new( item => $c->stash->{storytype_obj}  );

    $c->stash( form => $form, template => 'storytype/save.tt2' );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    $c->stash->{template} = 'storytype/save.tt2';
    $c->flash->{info_msg} = "storytype saved!";
    $c->redirect_to_action('StoryType', 'list');

  } 
  else {
      $c->flash->{status_msg} = "Unauthorized";
      return;
  }


}

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{storytype_obj}->op_by_admin($c->user->get_object);

    # Use the storytype object saved by 'object' and delete it along
    # with related items
    $c->stash->{storytype_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "storytype deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('StoryType', 'list');
}


################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "StoryType not found!";
    $c->detach('list');
}


1;
