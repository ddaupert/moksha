package Moksha::Controller::Book;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Moksha::Form::Book;

=head2 base

Place common logic to start chained dispatch here

=cut

# url /book
sub base :Chained("/") :PathPart("book") :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{book_rs} 
    = $c->model('DB::Book');
}

################
################

sub id : Chained('base') PathPart('') CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    
    $c->error("ID isn't valid!") unless $id =~ /^\d+$/;
    $c->stash->{book_obj} = $c->stash->{book_rs}->find($id)
      || $c->detach('not_found');
}

################
################

sub list : Chained('base') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{books} 
    = $c->stash->{book_rs}->search({}, 
                            { order_by => 'created desc' });

    $c->stash->{template} = 'book/list.tt2';
}

################
################

sub view : Chained('id') Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template} = 'book/view.tt2';
}

################
################

sub add : Chained('base') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{book_obj} 
      = $c->stash->{book_rs}->new_result({});
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

sub search : Chained('base') Args(0) {
  my ($self, $c) = @_;  

  my ( $title, $author, $book_id );

  my $books_rs = $c->stash->{book_rs};

  if ( $c->req->param('title') ) {
    $title = $c->req->param('title');
  }
  if ( $c->req->param('author') ) {
    $author = $c->req->param('author');
  }
  if ( $c->req->param('book_id') ) {
    $book_id = $c->req->param('book_id');
  }

  $c->stash->{books} 
    = $books_rs->title_like( $title );

  $c->stash->{template} = 'book/search.tt2';

}

################
################

sub save : Private {
    my ($self, $c) = @_;

    my $form = Moksha::Form::Book->new( item => $c->stash->{book_obj}  );

    my $all_tags = $c->model('DB::Tag')->search({}, { order_by => 'name' });
    $c->stash( form => $form, template => 'book/save.tt2', m2m_tags => $all_tags );

    # the "process" call has all the saving logic,
    # if it returns False, then a validation error happened
    return unless $form->process( params  => $c->req->params,
                                  user_id => $c->stash->{user_id},  );

    $c->stash->{template} = 'book/save.tt2';
    $c->flash->{info_msg} = "Book saved!";
    $c->redirect_to_action('Book', 'list');
}

################
################

=head2 delete
    
Delete book

=cut

sub delete :Chained('id') :PathPart('delete') :Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
        unless $c->stash->{book_obj}->op_by_admin($c->user->get_object);

    # Use the book object saved by 'object' and delete it 
    # along with any related items
    $c->stash->{book_obj}->delete;

    # Use 'flash' to save information across requests until it's read
    $c->flash->{status_msg} = "Book deleted";

    # Redirect the user back to the list page
    $c->redirect_to_action('Book', 'list');
}

################
################

sub not_found : Local {
    my ($self, $c) = @_;
    $c->response->status(404);
    $c->stash->{error_msg} = "Book not found!";
    $c->detach('list');
}

1;
