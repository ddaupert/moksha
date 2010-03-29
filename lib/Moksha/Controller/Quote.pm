package Moksha::Controller::Quote;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Quote;

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    #$c->response->body("Moksha::Controller::Quote");

    $c->stash->{template} = 'quote/index.tt2';
}

=head2 base

Place common logic to start chained dispatch here

=cut

# url /quote
sub base :Chained("/") :PathPart("quote") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{quote_rs} 
    = $c->model('DB::Quote');
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{quote_obj} = $c->stash->{quote_rs}->find($id)
  || $c->detach('not_found');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{quotes} 
    = $c->stash->{quote_rs}->search({}, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'quote/list.tt2';
}

################
################

sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{inspire_quote} = $c->stash->{quote_obj};
    $c->stash->{template} = 'quote/view.tt2';
}

################
################

sub add : Chained('base') Args(0) {
  my ($self, $c) = @_;

  $c->stash->{quote_obj} = $c->stash->{quote_rs}->new_result({});
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

    my $form = Moksha::Form::Quote->new( item => $c->stash->{quote_obj}  );

    my $all_tags = $c->model('DB::Tag')->search({}, { order_by => 'name' });
    $c->stash( form => $form, template => 'quote/save.tt2', m2m_quote_tags => $all_tags );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params    => $c->req->params,
                                  posted_by => $c->stash->{user_id},);


    $c->stash->{template} = 'quote/save.tt2';
    $c->flash->{status_msg} = "Quote saved!";
    $c->redirect_to_action('Quote', 'list');

}

################
################

=head2 delete
    
Delete quote

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{quote_obj}->op_by_admin($c->user->get_object);

    # Use the quote object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{quote_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Quote deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Quote', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Quote not found!";
    $c->detach('list');
}

=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
