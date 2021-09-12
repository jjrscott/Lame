#!/usr/bin/perl -CS

# MIT License
# 
# Copyright (c) 2018 John Scott
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# This script generates an entire imageset from a single source image (eg a PDF)
# $ imageset_generator -imageset_path <imageset path>  -source_path <source image path>
#
# For example:
# $ imageset_generator -imageset_path Mail/Assets.xcassets/AppIcon.appiconset -source_path Mail/AppIcon.pdf
# 


use strict;
use Data::Dumper;
use Getopt::Long;
use FindBin;
use lib $FindBin::Bin.'/lib';
use JSON::PP;
use File::stat;
use File::Temp qw(tempdir);

my $imagesetPath;
my $sourcePath;

my %options =
(
	"imageset_path=s" => \$imagesetPath,
	"source_path=s" => \$sourcePath,
);

my $tempdir = tempdir();

GetOptions(%options);

my ($imagesetName) = $imagesetPath =~ m!([^/]+)\.[^\.]+$!;

my  $json = JSON::PP->new->ascii->pretty->allow_nonref->canonical;

my $contents = $json->decode( scalar read_file("UTF-8", $imagesetPath.'/Contents.json') );

foreach my $image (@{$contents->{'images'}})
{
	if ("universal" eq $image->{'idiom'})
	{
		my ($extension) = $sourcePath =~ m!([^\.]+)$!;
		my $filename = $image->{'filename'} || sprintf '%s.%s', $imagesetName, $extension;
		if (stat($imagesetPath.'/'.$filename)->mtime() < stat($sourcePath)->mtime())
		{
			system "cp", "-f", $sourcePath, $imagesetPath.'/'.$filename;
		    $image->{'filename'} = $filename;
		}
	}
	else
	{
		my ($width, $height) = $image->{'size'} =~ /^(\d+(?:\.\d+)?)x(\d+(?:\.\d+)?)$/;
		my ($scale) = $image->{'scale'} =~ /^(\d+)x$/;
	
		$width *= $scale;
		$height *= $scale;
		
		my $fileType = "png";
	
		my $filename = $image->{'filename'} || sprintf '%s_%sx%s.%s', $imagesetName, $width, $height, $fileType;
		
		# We're about to use a temporary file because git now doesn't like updates to the file modification time
		# even if nothing else has changed.
		
		my $filePath = $imagesetPath.'/'.$filename;
		my $tempFilePath = $tempdir.'/'.$filename;
		
        system "sips", "--resampleHeightWidth", $width, $height,
               "--setProperty", "format", $fileType,
               "--out", $tempFilePath,
               $sourcePath;
               
        my $fileMd5 = qx(md5 -q '$filePath');
        my $tempFileMd5 = qx(md5 -q '$tempFilePath');
               
		warn sprintf qq(%s\n\t%s\t%s), $filePath, $fileMd5, $tempFileMd5;
               
        if ($fileMd5 ne $tempFileMd5)
        {
            system "cp", "-f", $tempFilePath, $filePath;
    		$image->{'filename'} = $filename;
        }
		$image->{'filename'} = $filename;
	}

# 	print Dumper($image);
}

write_file("UTF-8", $imagesetPath.'/Contents.json', $json->encode($contents));

sub read_file
{
	my ($encoding, $path) = @_;
	open(my($file), '<:encoding('.$encoding.')', $path) || die "error $!: $path\n";
	my $content = "";
	while(<$file>) {
		$content .= $_;
	}
	close $file;
	return $content;
}

sub write_file
{
	my ($encoding, $path, $content) = @_;
	if (defined $content)
	{
		my $parentPath = $path;
		$parentPath =~ s!/?[^/]*$!!;
		
		if (!-e $parentPath)
		{
			system "mkdir", "-p", $parentPath;
		}
	
		if (!-e $path || read_file($encoding, $path) ne $content)
		{
			open(my($file), '>:encoding('.$encoding.')', $path) || die "error $!: $path\n";
			print $file $content;
			close $file;
		}
	}
	elsif (-e $path)
	{
		system "rm", "-f", $path;
	}
}