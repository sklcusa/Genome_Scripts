#!/usr/bin/perl

# Copyright (c) Wang Zhiqiang 2017-
# Author:Zhiqiang Wang <zhqwang@gxu.edu.cn>
# Program Date: 2017-05-31
# Modifier:Zhiqiang Wang
# Last Modified:2018-04-03
# Description: This program is for filter length shredhold from assemlied contigs 
# The input contigs always seperate as Less than, Great and equal; 

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
       Usage :perl $0  -i input_file_name -l length_threshold -o output_file_prefix_name 
                     
USAGE
my %opts;
GetOptions(
	
	"input:s"=>\$opts{in},
	"length_threshold:i"=>\$opts{len},
	"output:s"=>\$opts{out}
	
); 
if (!defined $opts{in} ){
	die $usage;
 
}
if (!defined $opts{len}){
	$opts{len}=500;
}
if (!defined $opts{out}){
	my @titles= split/\./,$opts{in};
	$opts{out}=$titles[0];
}




		
#print "\n\n************************************\n*\n*Now\n*running.....\n*\n*\n************************************\n";
my %seqs;
my $id;

open (I,$opts{in})|| die "please check the input file name!\n";
my ($i,$j,$k) =(0,0,0);
while(<I>){
	chomp;
	if(/^>(\S+)/){
		$id=$1;
		$i++;
	}else{
		$seqs{$id}.=$_;
	}



}

open(GE,">","ge_".$opts{len}."_".$opts{out}."_seq.fa")||die "can not write to the file:$opts{out}\n";
open(LT,">","lt_".$opts{len}."_".$opts{out}."_seq.fa")||die "can not write to the file:$opts{out}\n";

for my $key(keys %seqs){
	if (length($seqs{$key})<$opts{len}){
		print LT ">$key\n";
		print LT &fasta_output($seqs{$key});
		$j++;
	}else{
		print GE ">$key\n";
		print GE &fasta_output($seqs{$key});
		$k++;
	}
}
open (ST,">>","stat.txt") or die "can not append the stat file\n";
my $sample= $1 if ($opts{in} =~ /(\S+)\.\w+$/);
print ST "$sample  $i  $k  $j\n";
print "The input file is :  ",$opts{in},"\t";
print "Total input contigs #:  ",$i,"\n";
print "Contigs great and equal ",$opts{len},"bp #:  ",$k,"\t";
print "Contigs less than ",$opts{len},"bp #:  ",$j,"\n\n";

#print "\n\n************************************\n*\n*Now\n*Done!\n*\n*\n************************************\n";
close(I);
close(GE);
close(LT);
close(ST);
#############################################################

sub fasta_output{ 
	#the input parameter must be like the $char
	my $txt;
	for (my $i=0;$i*50<length($_[0]);){
		$txt.=substr($_[0],$i*50,50)."\n";
		$i++;
	}
	return $txt;
}

############################################################	
