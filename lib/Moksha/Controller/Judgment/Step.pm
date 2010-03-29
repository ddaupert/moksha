package Moksha::Controller::Judgment::Step;

use strict;
use warnings;
use parent 'Catalyst::Controller';
#use Moksha::Form::Judgment::Step;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /judgment/*/step
sub base :Chained("/judgment/id") :PathPart("step") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{entries_rs} = $c->model('DB::Entry');

}

################
################

# url /judgment/*/step/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("Step ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{step_obj} = $c->stash->{entries_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /judgment/*/step/list (end of chain)
sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    my $entries_rs = $c->stash->{entries_rs};
    my $moksha_id = $c->stash->{moksha_obj}->id;

    $c->stash->{entries} 
      = $entries_rs->search({ moksha_id  => $moksha_id }, 
                            { order_by => 'created desc' }
                           );

    $c->stash->{template} = 'user/moksha/step/list.tt2';
}

################
################

# url /judgment/*/step/view (end of chain)
sub view : Chained('id') Args(0) {}

################
################

# url /judgment/*/step/add (end of chain)
sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;

    my $entries_rs = $c->stash->{entries_rs};
    $c->stash->{step_obj} = $entries_rs->new_result({});
    $c->forward('save');
}

################
################

# url /judgment/*/step/edit (end of chain)
sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $user_id  = $c->stash->{user_id};
    my $moksha_obj = $c->stash->{moksha_obj};
    my $moksha_id  = $moksha_obj->id;

    my $form = Moksha::Form::User::Judgment::Step->new( item => $c->stash->{step_obj}  );

    my $all_tags = $c->model('DB::Tag')->search({}, { order_by => 'name' });
    $c->stash( form => $form, template => 'user/moksha/step/save.tt2', tags => $all_tags );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params,
                                  user_id => $c->stash->{user_id},
                                  moksha_id => $moksha_id );

    $c->flash->{info_msg} = "Step saved!";

# Aristotle's suggestions
#     my @caps = ( $user_id, $moksha_id );
#     $c->go( '/judgment/step/list', \@caps );
# 
#     $c->go( '/judgment/step/list', [$user_id, $moksha_id] );

# This works
    $c->response->redirect($c->uri_for_action('/judgment/step/list', [$user_id, $moksha_id]));

}

################
################

=head2 delete
    
Delete step

=cut

# url /judgment/*/step/delete (end of chain)
sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{step_obj}->op_by_admin($c->user->get_object);

    my $user_id  = $c->stash->{user_id};
    my $moksha_obj = $c->stash->{moksha_obj};
    my $moksha_id  = $moksha_obj->id;

    # Use the step object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{step_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Step deleted";

    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for_action('/judgment/step/list', [$user_id, $moksha_id]));
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Step not found!";
    $c->detach('list');
}

1;
