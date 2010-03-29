package Moksha::Controller::Inquiry::Situation;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Inquiry::Situation;

=head1 NAME

Moksha::Controller::Inquiry::Situation - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Moksha::Controller::Inquiry::Situation in Inquiry::Situation.');
}

################
################

=head2 base

Place common logic to start chained dispatch here

=cut

# url /inquiry/*/situation/
sub base :Chained("/inquiry/id") :PathPart("situation") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{situation_rs} 
    = $c->model('DB::InqSituation');
}

################
################

# url /inquiry/*/situation/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("Belief ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{situation_obj} = $c->stash->{situation_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /inquiry/*/situation/list (end of chain)
sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{situations} 
      = $c->stash->{situation_rs}->search(
                            { user_id  => $c->stash->{user_id} }, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'inquiry/situation/list.tt2';
}

################
################

# url /inquiry/*/situation/*/view (end of chain)
sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'inquiry/situation/view.tt2';
}

################
################

# url /inquiry/*/situation/add (end of chain)
sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{situation_obj} = $c->stash->{situation_rs}->new_result({});

    $c->stash->{template} = 'inquiry/situation/save.tt2';

    $c->forward('save');
}

################
################

# url /inquiry/*/situation/*/edit (end of chain)
sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $form = Moksha::Form::InqSituation->new( item => $c->stash->{situation_obj}  );

    $c->stash( template => 'inquiry/situation/save.tt2', form => $form );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params   => $c->req->params,
                                  user_id  => $c->stash->{user_id}, );

    $c->flash->{info_msg} = "Successfully saved!";

    $c->response->redirect($c->uri_for_action('/inquiry/situation/list' ));

}

################
################

=head2 delete
    
Delete situation

=cut

# url /inquiry/*/situation/*/delete (end of chain)
sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{situation_obj}->op_by_admin($c->tool->get_object);

    # Use the situation object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{situation_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Belief deleted";

    # Redirect the tool back to the list page
    $c->redirect_to_action('Situation', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Situation not found!";
    $c->detach('list');
}

=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
