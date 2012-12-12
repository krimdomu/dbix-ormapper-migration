#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package DBIx::ORMapper::Migration;

our $VERSION = "0.0.2";
   
use strict;
use warnings;
use Data::Dumper;

use DBIx::ORMapper::Migration::Table;

require Exporter;

use base qw(Exporter);

use vars qw(@EXPORT);
@EXPORT = qw(
               create_table drop_table add_column drop_column add_index drop_index sql change_column
               NULL FALSE TRUE
            );

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   return $self;
}

#
# EXPORTED FUNCTIONS
#

sub create_table(&) {
   my ($code) = @_;
   my $t = DBIx::ORMapper::Migration::Table->new;

   &$code($t);

   my $stmt = $t->get_statement();
   $stmt->execute;
}

sub drop_table {
   my ($table) = @_;
   my $t = DBIx::ORMapper::Migration::Table->new;

   my $code = sub {
      my $t = shift;
      $t->name($table);
      $t->drop;
   };

   &$code($t);

   my $stmt = $t->get_statement();
   $stmt->execute;
}

sub add_column {
   my ($table, $col_name, $col_type, $col_opts) = @_;
   my $t = DBIx::ORMapper::Migration::Table->new;

   my $code = sub {
      my $t = shift;
      $t->name($table);
      $t->add_column($col_name, $col_type, $col_opts);
   };

   &$code($t);

   my $stmt = $t->get_statement();
   $stmt->execute;
}

sub change_column {
   my ($table, $col_name, $col_type, $col_opts) = @_;
   my $t = DBIx::ORMapper::Migration::Table->new;

   my $code = sub {
      my $t = shift;
      $t->name($table);
      $t->change_column($col_name, $col_type, $col_opts);
   };

   &$code($t);

   my $stmt = $t->get_statement();
   $stmt->execute;
}

sub drop_column {
   my ($table, $col_name) = @_;
   my $t = DBIx::ORMapper::Migration::Table->new;

   my $code = sub {
      my $t = shift;
      $t->name($table);
      $t->drop_column($col_name);
   };

   &$code($t);

   my $stmt = $t->get_statement();
   $stmt->execute;
}

sub add_index {
   my ($table, $col_name) = @_;
   my $t = DBIx::ORMapper::Migration::Table->new;

   my $code = sub {
      my $t = shift;
      $t->name($table);
      $t->add_index($col_name);
   };

   &$code($t);

   my $stmt = $t->get_statement();
   $stmt->execute;
}

sub drop_index {
}

sub sql {
}

sub NULL { return undef; }
sub TRUE { return 1; }
sub FALSE { return 0; }

1;
