# IMPORTANT: if you delete this file your app will not work as
# expected.  you have been warned
use inc::Module::Install;

name 'Moksha';
all_from 'lib/Moksha.pm';

requires 'Template';
requires 'Content';
requires 'inc::Module::Install';
requires 'Perl6::Junction';
requires 'HTML::FormHandler'; 
requires 'Moose';
requires 'HTML::FormHandler::Moose'; 
requires 'Exporter';                                                           
requires 'Encode';
requires 'DateTime';
requires 'Imager';
requires 'MIME::Types';
requires 'File::MimeInfo';
requires 'Getopt::Long';
requires 'Pod::Usage';
requires 'FindBin';
requires 'Path::Class';
requires 'URI'; 
requires 'Scope::Guard' => '0.12';
requires 'DBIx::Class';
requires 'DBIx::Class::Tree::AdjacencyList'; 
requires 'Catalyst::Runtime' => '5.80013';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Action::StackTrace';
requires 'Catalyst::Action::Authentication';
requires 'Catalyst::Action::Authorization::Roles';
requires 'Catalyst::Action::Session';
requires 'Catalyst::Action::Session::State::Cookie';
requires 'Catalyst::Action::Session::Store::FastMmap';
requires 'Catalyst::Action::Unicode';
requires 'parent';
requires 'Config::General'; 
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
