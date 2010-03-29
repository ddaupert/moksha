package Moksha::Controller::Clear;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Clear;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /clear/
sub base :Chained("/") :PathPart("clear") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{clear_rs} 
    = $c->model('DB::Clear');
}

################
################

# url /clear/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("Clear ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{clear_obj} = $c->stash->{clear_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /clear/list (end of chain)
sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{clears} 
    = $c->stash->{clear_rs}->search(
                            { user_id  => $c->stash->{user_id} }, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'clear/list.tt2';
}

################
################

# url /clear/*/view (end of chain)
sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'clear/view.tt2';
}

################
################

# url /clear/add (end of chain)
sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{clear_obj} = $c->stash->{clear_rs}->new_result({});

    $c->stash->{template} = 'clear/save.tt2';

    $c->forward('save');
}

################
################

# url /clear/*/edit (end of chain)
sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $form = Moksha::Form::Clear->new( item => $c->stash->{clear_obj}  );

    $c->stash( template => 'clear/save.tt2', form => $form );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params   => $c->req->params,
                                  user_id  => $c->stash->{user_id}, );

    $c->flash->{info_msg} = "Successfully saved!";

    $c->response->redirect($c->uri_for_action('/clear/list' ));

}

################
################

=head2 delete
    
Delete clear

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{clear_obj}->op_by_admin($c->tool->get_object);

    # Use the clear object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{clear_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Clear deleted";

    # Redirect the tool back to the list page
    $c->redirect_to_action('Clear', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Clear not found!";
    $c->detach('list');
}

=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
