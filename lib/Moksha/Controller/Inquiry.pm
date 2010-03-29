package Moksha::Controller::Inquiry;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Inquiry;

=head1 NAME

Moksha::Controller::Inquiry - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

#     $c->response->body('Matched Moksha::Controller::Inquiry in Inquiry.');

    $c->stash->{template} = 'inquiry/index.tt2';
}

################
################

=head2 base

Place common logic to start chained dispatch here

=cut

# url /inquiry
sub base :Chained("/") :PathPart("inquiry") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{inquiry_rs} 
      = $c->model('DB::Inq');
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("Inquiry ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{inquiry_obj} = $c->stash->{inquiry_rs}->find($id)
      || $c->detach('not_found');
    $c->stash->{inquiry_id}  = $c->stash->{inquiry_obj}->id;
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{inquiries} 
    = $c->stash->{inquiry_rs}->search({}, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'inquiry/list.tt2';
}

################
################

sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'inquiry/view.tt2';
}

################
################

sub add : Chained('base') Args(0) {
  my ($self, $c) = @_;

  $c->stash->{inquiry_obj} 
    = $c->stash->{inquiry_rs}->new_result({});

  $c->stash->{template} = 'inquiry/save.tt2';

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

    my $form = Moksha::Form::Inquiry->new( item => $c->stash->{inquiry_obj}  );

    $c->stash( template => 'inquiry/save.tt2', form => $form );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params  => $c->req->params,
                                  user_id => $c->stash->{user_id},);

    $c->flash->{status_msg} = "Inquiry saved!";
    $c->redirect_to_action('Inquiry', 'list');
}

################
################

=head2 delete
    
Delete inquiry

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{inquiry_obj}->op_by_admin($c->user->get_object);

    # Use the inquiry object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{inquiry_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Inquiry deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Inquiry', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Inquiry not found!";
    $c->detach('list');
}


=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
