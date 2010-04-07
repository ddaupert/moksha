package Moksha::Controller::Story;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Story;

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    #$c->response->body("Moksha::Controller::Story");

    $c->stash->{template} = 'story/index.tt2';
}

=head2 base

Place common logic to start chained dispatch here

=cut

# url /story
sub base :Chained("/") :PathPart("story") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{story_rs} 
    = $c->model('DB::Story');
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{story_obj} = $c->stash->{story_rs}->find($id)
  || $c->detach('not_found');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{stories} 
    = $c->stash->{story_rs}->search({}, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'story/list.tt2';
}

################
################

sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;
    
    my $story = $c->stash->{story_obj};
    my $item = $c->model('DB::Comments')->new_result({
        object_type => 'story', object_id => $story->id, owner_id => $c->user->id,
        active => 1
    });
    $c->forward('/comments/save', [ $item ]);

    $c->stash->{inspire_story} = $story;
    $c->stash->{template} = 'story/view.tt2';
}

################
################

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{story_obj} = $c->stash->{story_rs}->new_result({});
    $c->forward('save');
}

################
################

sub inspired : Chained('id') {
    my ($self, $c) = @_;
    
#     my $story_obj             = $c->stash->{story_obj}; 
    $c->stash->{parent_id}    = $c->stash->{story_obj}->id;
    $c->stash->{parent_title} = $c->stash->{story_obj}->title;

    $c->stash->{story_obj} = $c->stash->{story_rs}->new_result({});

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

    my $form = Moksha::Form::Story->new( item => $c->stash->{story_obj}  );

#     $c->stash( form => $form, template => 'story/save.tt2' );
    my $all_tags = $c->model('DB::Tag')->search({}, { order_by => 'name' });
    $c->stash( form => $form, template => 'story/save.tt2', m2m_story_tags => $all_tags );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened

    my %hash = ( params => $c->req->params,
                 user_id => $c->stash->{user_id}, );

    if ( $c->stash->{parent_id} ) {
      $hash{inspire_story} = $c->stash->{parent_id};
    };

    return unless $form->process( %hash );

    $c->stash->{template} = 'story/save.tt2';
    $c->flash->{info_msg} = "Story saved!";
    $c->redirect_to_action('Story', 'list');
}

################
################

=head2 delete
    
Delete story

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{story_obj}->op_by_admin($c->user->get_object);

    # Use the story object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{story_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Story deleted";

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


=head1 AUTHOR

perl

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
