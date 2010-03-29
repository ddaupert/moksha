package Moksha::Controller::AuthQuestion;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::AuthQuestion;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /authquestion
sub base :Chained("/") :PathPart("authquestion") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{authquestion_rs} 
    = $c->model('DB::AuthQuestion');
}


################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{authquestion_obj} = $c->stash->{authquestion_rs}->find($id)
  || $c->detach('not_found');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{authquestions} 
    = $c->stash->{authquestion_rs}->search({}, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'authquestion/list.tt2';
}

################
################

sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;


}

################
################

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{authquestion_obj} = $c->stash->{authquestion_rs}->new_result({});
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

    my $form = Moksha::Form::AuthQuestion->new( item => $c->stash->{authquestion_obj}  );

    $c->stash( form => $form, template => 'authquestion/save.tt2' );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params,
                                );

    $c->stash->{template} = 'authquestion/save.tt2';
    $c->flash->{info_msg} = "AuthQuestion saved!";
    $c->redirect_to_action('AuthQuestion', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "AuthQuestion not found!";
    $c->detach('list');
}


=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
