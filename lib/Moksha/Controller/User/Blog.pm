package Moksha::Controller::User::Blog;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::User::Blog;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /user/*/blog/
sub base :Chained("/user/id") :PathPart("blog") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{blog_rs} 
    = $c->model('DB::Blog');
}

################
################

# url /user/*/blog/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("Moksha ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{blog_obj} = $c->stash->{blog_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /user/*/blog/list (end of chain)
sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    my $user_id = $c->stash->{user_obj}->id;

    $c->stash->{blogs} 
    = $c->stash->{blog_rs}->search(
                            { owner_id =>  $user_id }, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'user/blog/list.tt2';
}

################
################

# url /user/*/blog/*/view (end of chain)
sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'user/blog/view.tt2';
}

################
################

# url /user/*/blog/add (end of chain)
sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{blog_obj} = $c->stash->{blog_rs}->new_result({});

    $c->stash->{template} = 'user/blog/save.tt2';

    $c->forward('save');
}

################
################

# url /user/*/blog/*/edit (end of chain)
sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $user_id = $c->stash->{user_id};

    my $form = Moksha::Form::User::Blog->new( item => $c->stash->{blog_obj}  );

    $c->stash( template => 'user/blog/save.tt2', form => $form );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params   => $c->req->params,
                                  owner_id => $user_id );

    $c->flash->{info_msg} = "Blog saved!";

    $c->response->redirect($c->uri_for_action('/user/blog/list', [$user_id]));

}

################
################

=head2 delete
    
Delete user's blog

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{blog_obj}->op_by_admin($c->user->get_object);

    # Use the blog object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{blog_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "User Blog deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Blog', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Blog not found!";
    $c->detach('list');
}

=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
