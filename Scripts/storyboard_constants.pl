#!/usr/bin/perl -CSL

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

use utf8;
use strict;
use Data::Dumper;
use Getopt::Long;
use List::MoreUtils qw(uniq);
use File::Slurp;

my $storyboardPath;
my $swiftPath;

GetOptions(
	"storyboard=s", \$storyboardPath,
	"output=s", \$swiftPath,
);

if (!length $storyboardPath)
{
	die "$0 -storyboard <storyboard path> -output <output file prefix>\n";
}

my $storyboardContent = read_file($storyboardPath);

my ($swiftFileName) = $swiftPath =~ m~([^/]+)$~;
$swiftFileName =~ s/\..*//;


my $swiftContent = "";

$swiftContent .= "import Foundation\n";

$swiftContent .= "\n";


my @sequeIdentifiers = uniq $storyboardContent =~ m~<segue [^>]*?identifier="([^"]+)"~g;
my @reuseIdentifiers = uniq $storyboardContent =~ m~<tableViewCell [^>]*?reuseIdentifier="([^"]+)"~g;
my @storyboardIdentifiers = $storyboardContent =~ m~<[^>]*?storyboardIdentifier="([^"]+)"~g;


sub stringForConstant {
    my ($contant) = @_;
    return sprintf qq(let %sSeque%s = "%s"\n), $swiftFileName, $contant, $contant;
}

foreach my $sequeIdentifier (sort @sequeIdentifiers) {
	$swiftContent .= stringForConstant($sequeIdentifier);
}

$swiftContent .= "\n";

foreach my $reuseIdentifier (sort @reuseIdentifiers) {
	$swiftContent .= stringForConstant($reuseIdentifier);
}

$swiftContent .= "\n";

foreach my $identifier (sort @storyboardIdentifiers) {
	$swiftContent .= stringForConstant($identifier);
}

write_file($swiftPath, $swiftContent);
