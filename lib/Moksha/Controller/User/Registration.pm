package Moksha::Controller::User::Registration;
use Moose;
use namespace::autoclean;
use Moksha::Form::User::Register;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Moksha::Controller::User::Registration - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Moksha::Controller::User::Registration in User::Registration.');
}

=head2 base

Place common logic to start chained dispatch here

=cut

# url /user/registration
sub base :Chained("/user/base") :PathPart("registration") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{user_rs} 
    = $c->model('DB::User');
}

################
################

# url /user/registration/register
sub register : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{user_obj} = $c->stash->{user_rs}->new_result({});
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;
    
    my $authcode = $c->stash->{user_obj}->make_authcode();
    
    $c->log->debug("authcode: $authcode");

    my $form = 
      Moksha::Form::User::Register->new( 
        item => $c->stash->{user_obj} );

    $c->stash( form => $form, template => 'user/registration/save.tt2' );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params, authcode => $authcode );

    $c->flash->{info_msg} = "Registration has begun";
    $c->redirect_to_action('Registration', 'expect_email');
}

################
################

# url /user/registration/expect_email
sub expect_email :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'user/registration/inform.tt2';

}


################
################

# url /user/registration/verify
sub verify :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'user/registration/inform.tt2';

}


=head1 AUTHOR

perl,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
