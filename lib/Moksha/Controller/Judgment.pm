package Moksha::Controller::Judgment;

use strict;
use warnings;
use parent 'Catalyst::Controller';
#use Moksha::Form::Judgment;

=head2 base

Place common logic to start chained dispatch here.
We want to write to TABLE judgment_as, 
but we need to pull questions from TABLE judgment_qs

=cut

# url /judgment/
sub base :Chained("/") :PathPart("judgment") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{judgment_rs} 
    = $c->model('DB::Judgment_A');
}

################
################

# url /judgment/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("Judgment_Q ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{judgment_obj} = $c->stash->{judgment_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /judgment/list (end of chain)
sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{judgments} 
    = $c->stash->{judgment_rs}->search(
                            { user_id  => $c->stash->{user_id} }, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'judgment/list.tt2';
}

################
################

# url /judgment/*/view (end of chain)
sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'judgment/view.tt2';
}

################
################

# url /judgment/add (end of chain)
sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{judgment_obj} = $c->stash->{judgment_rs}->new_result({});

    $c->stash->{template} = 'judgment/save.tt2';

    $c->forward('save');
}

################
################

# url /judgment/*/edit (end of chain)
sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $form = Moksha::Form::Judgment_Q->new( item => $c->stash->{judgment_obj}  );

    $c->stash( template => 'judgment/save.tt2', form => $form );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params   => $c->req->params,
                                  user_id  => $c->stash->{user_id}, );

    $c->flash->{info_msg} = "Successfully saved!";

    $c->response->redirect($c->uri_for_action('/judgment/list' ));

}

################
################

=head2 delete
    
Delete judgment

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{judgment_obj}->op_by_admin($c->tool->get_object);

    # Use the judgment object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{judgment_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Judgment_Q deleted";

    # Redirect the tool back to the list page
    $c->redirect_to_action('Judgment_Q', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Judgment_Q not found!";
    $c->detach('list');
}

=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
