#! /usr/bin/perl -w
eval 'exec perl -S $0 ${1+"$@"}'
    if 0; #$running_under_some_shell

# ======================================================================
# splitindex.pl
# Copyright (c) Markus Kohm, 2002
#
# $Id: splitindex.pl,v 1.5 2002/11/05 10:54:27 mjk Exp $
#
# This file is part of the SplitIndex package
#
# This file can be redistributed and/or modified under the conditions
# of the LaTeX Project Public License, either version 1.2 of this
# license or (at your option) any later version.
# The latest version of this license is in
#       http://www.latex-project.org/lppl.txt
# and version 1.2 or later is part of all distributions of LaTeX
# version 1999/12/01 or later.
#
# You are not allowed to redistribute this file without all the
# other files of the SplitIndex package
# ======================================================================

use strict;
use Getopt::Long;

my $makeindex = "makeindex";
# my $identify = "^(.*)\\\\UseIndex *\\{([^\\}]*)\\}(.*)\$";
my $identify = "^(\\\\indexentry)\\[([^]]*)\\](.*)\$";
my $suffixis = "-\$2";
my $lineis = "\$1\$3";
my $verbose = 0;   # option verbose with default value 
my $result = GetOptions(
			'help' => sub { help() },
			'makeindex=s' => \$makeindex,
			'identify=s' => \$identify,
			'resultis=s' => \$lineis,
			'suffixis=s' => \$suffixis,
			'verbose|v+' => \$verbose,
			 'version' => sub { version(); exit 0; } 
			);

usage("missing raw index file") if ( $#ARGV < 0 );

my $indexinput = shift;
my $jobname    = ( $indexinput =~ /^(.*)\.idx$/ ) ? $1 : $indexinput;

my %idxfile;
my %linesatidxfile;

version() if ($verbose > 0);

if ( !( open (IDX,"<$indexinput") ) ) {
    if ( $indexinput ne "$jobname.idx" ) {
	open (IDX,"<$jobname.idx") ||
	    die "Cannot read raw index file $indexinput nor $jobname.idx";
	$indexinput = "$jobname.idx";
    } else {
	die "Cannot read raw index file $indexinput";
    }
}

while (<IDX>) {
    my $line;
    my $suffix;
    if ( /$identify/ ) {
	my $eval = "\$line = \"$lineis\n\"";
	eval $eval;
	$eval = "\$suffix = \"$suffixis\"";
	eval $eval;
    } else {
	$line = $_;
	$suffix = "";
	$suffix .= "$1" if ( $suffixis =~ /^(.*)\$/ );
	$suffix .= "idx";
	$suffix .= "$1" if ( $suffixis =~ /\$[123456789](.*)$/ );
    }
    while ( $suffix =~ /(^[^,]+)(.*)$/ ) {
	$suffix = $2;
	writetoidx ($1,$line);
    }
}

closeallind();

close(IDX);

generateallind(@ARGV);

exit 0;

sub generateallind {
    my $name;
    my $file;
    
    if ( $makeindex ne "" ) {
	while (($name,$file) = each %idxfile) {
	    system( "$makeindex @ARGV $jobname$name.idx" );
	}
    }
}

sub closeallind {
    my $name;
    my $file;
    my $lines;
    while (($name,$file) = each %idxfile) {
	print "Close $jobname$name.idx\n" 
	    if ( $verbose > 1 );
	close( $file );
	$idxfile{$name}=0;
    }
    if ( $verbose > 0 ) {
	print "\n";
	while (($name,$lines) = each %linesatidxfile) {
	    print "$jobname$name.idx with $lines lines\n";
	}
    }
}

sub writetoidx {
    my $suffix = $_[0];
    my $line = $_[1];
    my $file = $idxfile{$suffix};
    if ( ! $file ) {
	open ( $file, ">$jobname$suffix.idx" ) ||
	    die "Cannot write to file $jobname$suffix.idx";
	$idxfile{$suffix} = $file;
	$linesatidxfile{$suffix} = 0;
	print( "New index file $jobname$suffix.idx\n" )
	    if ( $verbose > 1 );
    }
    print ($file $line);
    $linesatidxfile{$suffix}++;
}

sub help {
    version();
    print "\n";
    usage();
    print  	
	"Split a single raw index file into multiple raw index files.\n".
	"Example: splitindex.pl foo.idx.\n".
	"\n".
	"Options:\n" .
	"  -h, --help    " .
	"\tshow this help and terminate\n" .
	"  -m, --makeindex PROGNAME\n" .
	"\t\t\tcall PROGNAME instead of default \`makeindex\'.\n" .
	"  -i, --identify EXPRESSION\n" .
	"\t\t\tuse regular EXPRESSION to match entries\n".
	"\t\t\t(see also option --resultis and --suffixis).\n".
	"\t\t\tDefault is \'$identify\'.\n".
	"  -r, --resultis PATTERN\n" .
	"\t\t\tcreate line to be written from PATTERN after matching\n".
	"\t\t\tlines (see also option --identify).\n".
	"\t\t\tDefault is \'$lineis\'.\n".
	"  -s, --suffixis PATTERN\n" .
	"\t\t\tcreate suffix to be used from PATTERN after matching\n".
	"\t\t\tlines (see also option --identify).\n".
	"\t\t\tDefault is \'$suffixis\'.\n".
	"  -v, --verbose " .
	"\tbe more verbose\n".
	"\t\t\t(can be used multiple to increase verbosity)\n" .
	"      --version " .
	"\tshow version and terminate\n";
    exit 0;
}

sub version {
    print "splitindex.pl 0.1\n" .
	"Copyright (c) 2002 Markus Kohm \<kohm\@gmx.de\>\n";
}

sub usage {
    my $text = "Usage: splitindex.pl [OPTION]... RAWINDEXFILE [MAKEINDEXOPTION]...\n";
    if ( $#_ >= 0 ) {
	print STDERR @_;
	print STDERR "\n$text";
	print STDERR "Try \`splitindex.pl --help\' for more information.\n";
	exit 1;
    } else {
	print $text;
    }
}
