#!/usr/bin/perl

use warnings;
use strict;

my ($filename, $collectionId) = @ARGV;

if (not defined $filename or not defined $collectionId) {
  die "./cmm-dml-gen.pl <filename> <collection-id>\n";
}

open(FH, "<", $filename) or die $!;

my $title = "";
my $titlePartsCount = 0;

my $text = "";

my @items = ();

while(<FH>) {

    my $currentLine = "$_";
    chomp($currentLine);

    # first part of title
    if($currentLine =~ /\d{1,3}\.\ {0,3}([A-Z](\,|\Ì|\È|\À|\Ù|\Ò|\'|\.|\ |\’|\…|\.|\?|\(|\)|\d{1,3})*)+$/) {
        
        composeDml();

        # trim leading and trailing white spaces
        $currentLine =~ s/^\s+|\s+$//g;

        # replace backslash with double backslash for single quote symbol
        $currentLine =~ s/\'/\\'/g;

        $title = $currentLine;
    
    # possible second part of title
    } elsif($titlePartsCount < 2 and $currentLine =~ /([A-Z](\,|\Ì|\È|\À|\Ù|\Ò|\'|\.|\ |\’|\…|\.|\?|\(|\))*)+$/) {
    
        # trim leading and trailing white spaces
        $currentLine =~ s/^\s+|\s+$//g;

        # replace backslash with double backslash for single quote symbol
        $currentLine =~ s/\'/\\'/g;
        
        $title = "$title"." $currentLine";
        
    } else { # text

        # replace backslash with double backslash for single quote symbol
        $currentLine =~ s/\'/\\'/g;
        
        $text = "$text"."$currentLine\n";
        
    }

    if($titlePartsCount < 2) {
        $titlePartsCount++;
    }
    
}

composeDml();

close(FH);

open(FH, ">", "./output/output.sql") or die $!;

print FH join("\n\n", @items);
print FH "\n\n";

close(FH);


# SUBROUTINES

sub composeDml {
    
    if(length($title) > 0 and length($text) > 0) {

        # trim leading and trailing white spaces
        $text =~ s/^\s+|\s+$//g;

        push(@items, "INSERT INTO cmm.content (title, `text`, collection_id) VALUES(\n'$title',\n'$text',\n$collectionId);");
        
        $title = "";
        
        $titlePartsCount = 0;

        $text = "";

    }

}
