package Moksha::Controller::User::AuthQnA;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::User::AuthQnA;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /user/*/authqna
sub base :Chained("/user/id") :PathPart("authqna") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{qna_rs} = $c->model('DB::AuthQnA');

}

################
################

# url /user/*/authqna/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{qna_obj} = $c->stash->{qna_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /user/*/authqna/list
sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'user/authqna/list.tt2';
}

################
################

# url /user/*/authqna/view
sub view : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{qna_obj} = 
      $c->stash->{qna_rs}->search(
                                   { user_fk => $c->stash->{user_id} }, 
                                  );

    

    $c->stash->{template} = 'user/authqna/view.tt2';
}

################
################

# url /user/*/authqna/add
sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{qna_obj} = $c->stash->{qna_rs}->new_result({});
    $c->forward('save');
}

################
################

# url /user/*/authqna/*/edit
sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $user_id  = $c->stash->{user_id};

    my $form = Moksha::Form::User::AuthQnA->new( item => $c->stash->{qna_obj}  );

    $c->stash( form => $form, template => 'user/authqna/save.tt2' );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params  => $c->req->params,
                                  user_fk => $user_id,  );

    $c->stash->{template} = 'user/authqna/save.tt2';
    $c->flash->{info_msg} = "Authentication Q&A saved!";
    $c->response->redirect($c->uri_for_action('/user/authqna/view', [$user_id]));
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
