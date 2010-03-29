package Moksha::Controller::Address;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Address;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /address
sub base :Chained("/") :PathPart("address") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{address_rs} 
    = $c->model('DB::Address');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{addresss} 
    = $c->stash->{address_rs}->search({}, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'address/list.tt2';
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{address_obj} = $c->stash->{addresses}->find($id)
	|| $c->detach('not_found');
}

################
################

sub show : Chained('id') Args(0) {}

################
################

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{address_obj} = $c->stash->{address_rs}->new_result({});
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

    my $form = Moksha::Form::Address->new( item => $c->stash->{address_obj}  );

    $c->stash( form => $form, template => 'address/save.tt2' );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    $c->stash->{template} = 'address/save.tt2';
    $c->flash->{info_msg} = "Address saved!";
    $c->redirect_to_action('Address', 'list');
}

################
################

=head2 delete
    
Delete address

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{address_obj}->op_by_admin($c->user->get_object);

    # Use the address object saved by 'object' and delete it along
    # with related items
    $c->stash->{address_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Address deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Address', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Address not found!";
    $c->detach('list');
}

1;
