#!/usr/bin/perl

use warnings;
use strict;

my $filename = "./input/training_input.txt";

open(FH, "<", $filename) or die $!;

#----------VARS----------

my $collectionId = "1";

my $title = "";
my $titleCompleted = 0;

my $text = "";

my @items = ();

#----------VARS----------

while(<FH>) {

    my $currentLine = "$_";
    chomp($currentLine);

    if($currentLine =~ /\d{1,3}\.\ {0,3}([A-Z](\,|\Ì|\È|\À|\Ù|\Ò|\'|\.|\ |\’|\…|\.|\?|\d{1,3})*)+$/) { # first part of title
        
        compose();

        if(!$titleCompleted) {

            $currentLine =~ s/^\s+|\s+$//g; # trim leading and trailing white spaces

            $title = $currentLine;

        }
    
    #                                           /([A-Z](\,|\Ì|\È|\À|\Ù|\Ò|\'|\.|\ |\’|\…|\.|\?|\d{1,3})*)+$/
    } elsif(!$titleCompleted && $currentLine =~ /([A-Z](\,|\Ì|\È|\À|\Ù|\Ò|\'|\.|\ |\’|\…|\.|\?)*)+$/) { # possible second part of title
    
        $currentLine =~ s/^\s+|\s+$//g; # trim leading and trailing white spaces
        
        $title = "$title"." $currentLine";

        $titleCompleted = 1;
        
    } else { # title

        $currentLine =~ s/\"/\\"/g;
        
        $text = "$text"."$currentLine\n";
        
    }
    
}

compose();

close(FH);

open(FH, ">", "./output/output.sql") or die $!;

print FH join("\n\n", @items);
print FH "\n\n";

close(FH);


# SUBROUTINES

sub compose {
    
    if(length($title) > 0 && length($text) > 0) {

        $text =~ s/^\s+|\s+$//g; # trim leading and trailing white spaces

        push(@items, "INSERT INTO cmm.content (title, `text`, collection_id) VALUES(\n\"$title\",\n\"$text\",\n$collectionId);");
        
        $title = "";
        $titleCompleted = 0;

        $text = "";

    }

}
