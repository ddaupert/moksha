package Moksha::Controller::User::Blog::Entry;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::User::Blog::Entry;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /entry
sub base :Chained("/user/blog/id") :PathPart("entry") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{entries_rs} = $c->model('DB::Entry');

}

################
################

# url /user/*/blog/*/entry/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("Entry ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{entry_obj} = $c->stash->{entries_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /user/*/blog/*/entry/list (end of chain)
sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    my $entries_rs = $c->stash->{entries_rs};
    my $blog_id = $c->stash->{blog_obj}->id;

    $c->stash->{entries} 
      = $entries_rs->search({ blog_id  => $blog_id }, 
                            { order_by => 'created desc' }
                           );

    $c->stash->{template} = 'user/blog/entry/list.tt2';
}

################
################

# url /user/*/blog/*/entry/view (end of chain)
sub view : Chained('id') Args(0) {}

################
################

# url /user/*/blog/*/entry/add (end of chain)
sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;

    my $entries_rs = $c->stash->{entries_rs};
    $c->stash->{entry_obj} = $entries_rs->new_result({});
    $c->forward('save');
}

################
################

# url /user/*/blog/*/entry/edit (end of chain)
sub edit : Chained('id') {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $user_id  = $c->stash->{user_id};
    my $blog_obj = $c->stash->{blog_obj};
    my $blog_id  = $blog_obj->id;

    my $form = Moksha::Form::User::Blog::Entry->new( item => $c->stash->{entry_obj}  );

    my $all_tags = $c->model('DB::Tag')->search({}, { order_by => 'name' });
    $c->stash( form => $form, template => 'user/blog/entry/save.tt2', tags => $all_tags );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params,
                                  user_id => $c->stash->{user_id},
                                  blog_id => $blog_id );

    $c->flash->{info_msg} = "Entry saved!";

# Aristotle's suggestions
#     my @caps = ( $user_id, $blog_id );
#     $c->go( '/user/blog/entry/list', \@caps );
# 
#     $c->go( '/user/blog/entry/list', [$user_id, $blog_id] );

# This works
    $c->response->redirect($c->uri_for_action('/user/blog/entry/list', [$user_id, $blog_id]));

}

################
################

=head2 delete
    
Delete entry

=cut

# url /user/*/blog/*/entry/delete (end of chain)
sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{entry_obj}->op_by_admin($c->user->get_object);

    my $user_id  = $c->stash->{user_id};
    my $blog_obj = $c->stash->{blog_obj};
    my $blog_id  = $blog_obj->id;

    # Use the entry object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{entry_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Entry deleted";

    # Redirect the user back to the list page
    $c->response->redirect($c->uri_for_action('/user/blog/entry/list', [$user_id, $blog_id]));
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Entry not found!";
    $c->detach('list');
}

1;
