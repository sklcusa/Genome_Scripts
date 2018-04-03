#!/usr/bin/perl

# Copyright (c) Wang Zhiqiang 2018
# Author:Zhiqiang Wang <zhqwang@gxu.edu.cn>
# Program Date: 2018-04-03
# Modifier:Zhiqiang Wang
# Last Modified:2018-04-03
# Description: This program is for counting Pacbio or Nanopore reads 
# It is also provide the depth results if you want to know; 

#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License
#   as published by the Free Software Foundation.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

my $ver="0.10";
use strict;
use warnings;
use Getopt::Long;

my $usage=<<"USAGE";

      

       Program : $0
       Version : $ver
       Contact : Zhiqiang Wang[zhqwang\@gxu.edu.cn]
       Usage :perl $0  -i input_fastq_file  -g genome_size 
                     
USAGE
my %opts;
GetOptions(
	
	"input:s"=>\$opts{in},
	"genomesize:i"=>\$opts{sz}
	
); 
if (!defined $opts{in} ){
	die $usage;
 
}

if (!defined $opts{sz}){
	$opts{sz}=1;
}




		
#print "\n\n************************************\n*\n*Now\n*running.....\n*\n*\n************************************\n";


open (I,$opts{in})|| die "please check the input file name!\n";
my ($len,$ct,$sz) =(0,0,$opts{sz});
while(<I>){
	chomp;

	if($.%4 == 2 ){
		$len+=length($_);
		$ct++;
	}

}
my $dep = $len/$sz;
my $avg = $len/$ct;
print "Input is: $opts{in}     Total base:$len\n";
print "Reads Average Length:$avg     Seq Depth:$dep\n";


#print "\n\n************************************\n*\n*Now\n*Done!\n*\n*\n************************************\n";
close(I);

