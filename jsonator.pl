#!/usr/bin/perl
######################################################################
# Salió de un CUFP (cool uses for Perl). Ma-ra-vi-llo-so.
######################################################################

use strict;
use warnings;
use Data::Dumper;

@ARGV = qw{
--keyed_array_from_multiple_arguments a b 
--keyed_array_from_multiple_arguments c 
--keyed_array_from_multiple_arguments 1 
--keyed_with_equals=1 
--switch 
--multi.level a 
--funny_numbers -99.999
--switchable_switch
--noswitchable_switch
} unless @ARGV;

use JSON::XS;
use Scalar::Util qw{looks_like_number};

my ( $arguments, $data );
$arguments = join $", @ARGV;
$arguments =~ s{
    \s*             # some space
        --([\.\w]+) # an argument
    \s*?=?\s*       # some space or =
        (.*?)       # some values
    \s*(?=--|$)     # followed by another argument or end of line
}{
    my ($opt_name, $values)=($1,$2);
    for my $opt_value ( $values ? ( split /\s+/, $values ) : $opt_name =~s/^no// ? JSON::XS::false : JSON::XS::true ) {
        my $pointer = \$data;
        for my $opt_key ( split /\./, $opt_name ) { $pointer = \$$pointer->{$opt_key} };
        $opt_value = ( ref($opt_value) || !looks_like_number($opt_value) ) ? $opt_value : 0 + $opt_value;

        $$pointer = $$pointer && ! (ref($opt_value) =~/Bool/) ? [ ( ref($$pointer) eq 'ARRAY' ? @$$pointer : $$pointer ), $opt_value ] : $opt_value;
    }
}xeg;

print JSON::XS->new->pretty->encode($data);
