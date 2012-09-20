#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package DBIx::ORMapper::Migration::Table;
   
use strict;
use warnings;

use DBIx::ORMapper::Helper;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   # default: create
   $self->{'__get_statement__'} = sub { 
      my $self = shift;
      my $stmt = CREATE()
                     ->table($self->{name})
                        ->fields();

      for my $field (@{$self->{'__fields'}}) {
         my $name = $field->{name};
         $stmt->$name($field->{type}, %{ $field->{args} });
      }

      $stmt = $stmt->end();

      if($self->{'__primary_key'}) {
         $stmt = $stmt->primary_key(@{ $self->{'__primary_key'} });
      }

      return $::db->get_statement($stmt);
   };

   return $self;
}

sub name {
   my ($self, $name) = @_;
   $self->{name} = $name;

   return $self;
}

sub drop {
   my ($self) = @_;

   $self->{'__get_statement__'} = sub {
      my $self = shift;
      my $stmt = DROP()->table($self->{name});
      return $::db->get_statement($stmt);
   };
}

sub add_column {
   my ($self, $col_name, $col_type, $col_opts) = @_;

   $col_type = "\u$col_type";
   $col_opts ||= {};
   
   $self->{'__get_statement__'} = sub {
      my $self = shift;
      my $stmt = ALTER()
                  ->table($self->{name})
                     ->add()
                        ->column()
                           ->$col_name($col_type, %{ $col_opts })
                        ->end();

      return $::db->get_statement($stmt);
   };
}

sub drop_column {
   my ($self, $col_name) = @_;

   $self->{'__get_statement__'} = sub {
      my $self = shift;
      my $stmt = ALTER()
                  ->table($self->{name})
                     ->drop()
                        ->column()
                           ->$col_name()
                        ->end();

      return $::db->get_statement($stmt);
   };
}

sub add_index {
   my ($self, $col_name) = @_;

   $self->{'__get_statement__'} = sub {
      my $self = shift;
      my $stmt = CREATE()->index("idx_$col_name")
                              ->on($self->{name} => [$col_name]);

      return $::db->get_statement($stmt);
   };
}

sub get_statement {
   my ($self) = @_;

   my $code = $self->{'__get_statement__'};
   return &$code($self);
}

sub primary_key {
   my ($self, @keys) = @_;
   $self->{__primary_key} = \@keys;
}

sub AUTOLOAD {
   use vars qw($AUTOLOAD);
   my $self = shift;
   
   return $self if( $AUTOLOAD =~ m/DESTROY/ );
   
   $AUTOLOAD =~ m/^DBIx::ORMapper::Migration::Table::(.*?)$/;
   my $col_name = shift;
   my $col_type = "\u$1";
   my $col_args = { @_ };
   
   push(@{$self->{'__fields'}}, {
      name => $col_name,
      type => $col_type,
      args => $col_args
   });

   return $self;
}


1;
