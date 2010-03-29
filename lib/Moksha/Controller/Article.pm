package Moksha::Controller::Article;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Article;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /article
sub base :Chained("/") :PathPart("article") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{article_rs} 
    = $c->model('DB::Article')->search({}, 
                               { order_by => 'ts desc' });
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{article_obj} = $c->stash->{article_rs}->find($id)
  || $c->detach('not_found');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{articles} 
    = $c->stash->{article_rs}->search({}, 
                               { order_by => 'ts desc' });

    $c->stash->{template} = 'article/list.tt2';
}

################
################

sub view : Chained('id') Args(0) {}

################
################

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{article_obj} = $c->stash->{article_rs}->new_result({});
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

    my $form = Moksha::Form::Article->new( item => $c->stash->{article_obj}  );

    my $all_tags = $c->model('DB::Tag')->search({}, { order_by => 'name' });
    $c->stash( form => $form, template => 'article/save.tt2', tags => $all_tags );

    # the "process" call has all the saving logic,
    #   if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params  );

    $c->stash->{template} = 'article/save.tt2';
    $c->flash->{info_msg} = "Article saved!";
    $c->redirect_to_action('Article', 'list');
}

################
################

=head2 delete
    
Delete article

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{article_obj}->op_by_admin($c->user->get_object);

    # Use the article object saved by 'object' and delete it along
    # with related items
    $c->stash->{article_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Article deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Article', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Article not found!";
    $c->detach('list');
}

1;
