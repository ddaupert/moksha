package Moksha::Controller::Inquiry::Belief;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Inquiry::Belief;

=head1 NAME

Moksha::Controller::Inquiry::Belief - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Moksha::Controller::Inquiry::Belief in Inquiry::Belief.');
}

=head2 base

Place common logic to start chained dispatch here

=cut

# url /inquiry/*/belief/
sub base :Chained("/inquiry/id") :PathPart("belief") :CaptureArgs(0) {
# sub base :Chained("/inquiry") :PathPart("belief") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{belief_rs} 
    = $c->model('DB::InqBelief');
}

################
################

# url /inquiry/*/belief/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("Belief ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{belief_obj} = $c->stash->{belief_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /inquiry/*/belief/list (end of chain)
sub list : Chained('base') Args(0) {
  my ($self, $c) = @_;

  $c->stash->{beliefs} 
    = $c->stash->{belief_rs}->search(
                            { user_id  => $c->stash->{user_id} }, 
                            { order_by => 'created desc' });

  $c->stash->{template} = 'inquiry/belief/list.tt2';
}

################
################

# url /inquiry/*/belief/*/view (end of chain)
sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'inquiry/belief/view.tt2';
}

################
################

# url /inquiry/*/belief/add (end of chain)
sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{belief_obj} 
      = $c->stash->{belief_rs}->new_result({});

    $c->stash->{template} = 'inquiry/belief/save.tt2';

    $c->forward('save');
}

################
################

# url /inquiry/*/belief/*/edit (end of chain)
sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $inquiry_id = $c->stash->{inquiry_id};

    my $form = Moksha::Form::Inquiry::Belief->new( item => $c->stash->{belief_obj}  );

    $c->stash( template => 'inquiry/belief/save.tt2', form => $form );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params     => $c->req->params,
                                  user_id    => $c->stash->{user_id},
                                  inquiry_fk => $inquiry_id );

    $c->flash->{info_msg} = "Successfully saved!";

    $c->response->redirect($c->uri_for_action('/inquiry/belief/list', [ $inquiry_id ] ));

}

################
################

=head2 delete
    
Delete belief

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    my $inquiry_id = $c->stash->{inquiry_id};

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{belief_obj}->op_by_admin($c->user->get_object);

    # Use the belief object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{belief_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Belief deleted";

    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for_action('/inquiry/belief/list', [ $inquiry_id ] ));
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Belief not found!";
    $c->detach('list');
}

=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
