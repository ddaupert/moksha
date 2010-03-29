package Moksha::Controller::Quote::Story;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Story;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /quote/story
sub base :Chained("/quote/id") :PathPart("story") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{story_rs} 
    = $c->model('DB::Story')->search({}, 
                            { order_by => 'created desc' });
}

################
################

# url /quote/*/story/*
sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{story_obj} = $c->stash->{story_rs}->find($id)
  || $c->detach('not_found');
}

################
################

# url /quote/*/story/list
sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    my $quote_id = $c->stash->{quote_obj}->id;

    $c->stash->{stories} 
    = $c->stash->{story_rs}->search({ inspire_quote => $quote_id }, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'story/list.tt2';
}

################
################

# url /quote/*/story/*/view (end of chain)
sub view : Chained('id') :PathPart("view") Args(0) {
    my ($self, $c) = @_;

    $c->stash->{inspire_story} = $c->stash->{story_obj};
    $c->stash->{template} = 'story/view.tt2';
}

################
################

# url /quote/*/story/add (end of chain)
sub add : Chained('base') :PathPart("add") Args(0) {
    my ($self, $c) = @_;
    $c->stash->{story_obj} = $c->stash->{story_rs}->new_result({});
    $c->forward('save');
}

################
################

# url /quote/*/story/inspired (end of chain)
sub inspired : Chained('base') :PathPart("inspired") Args(0)  {
    my ($self, $c) = @_;
    

    my $quote_obj = $c->stash->{quote_obj}; 
    $c->stash->{quote_id} = $quote_obj->id;

    $c->stash->{story_obj} = $c->stash->{story_rs}->new_result({});

    $c->forward('save');
}

################
################

# url /quote/*/story/*/edit (end of chain)
sub edit : Chained('id') :PathPart("edit") :Args(0) {
    my ($self, $c) = @_;    
    $c->forward('save');
}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $form = Moksha::Form::Story->new( item => $c->stash->{story_obj}  );

#     $c->stash( form => $form, template => 'story/save.tt2' );
    my $all_tags = $c->model('DB::Tag')->search({}, { order_by => 'name' });
    $c->stash( form => $form, template => 'story/save.tt2', m2m_story_tags => $all_tags );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params => $c->req->params,
                                  user_id => $c->stash->{user_id},
                                  inspire_quote => $c->stash->{quote_id} );

    $c->stash->{template} = 'story/save.tt2';
    $c->flash->{info_msg} = "Story saved!";
    $c->redirect_to_action('Story', 'list');
}

################
################

=head2 delete
    
Delete story

=cut

# url /quote/*/story/*/delete (end of chain)
sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{story_obj}->op_by_admin($c->user->get_object);

    # Use the story object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{story_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Entry deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Story', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Story not found!";
    $c->detach('list');
}


=head1 NAME

Moksha::Controller::Quote::Story - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Moksha::Controller::Quote::Story in Quote::Story.');
}


=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
