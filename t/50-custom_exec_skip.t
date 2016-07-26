use warnings;
use strict;

use Test::More;
use lib 't/';
use BB;

my $c = 'c:/repos/berrybrew/build/berrybrew';
my $customfile = 'c:/repos/berrybrew/build/data/perls_custom.json';
my $conf = 'c:/repos/berrybrew/build/data/config.json';

my $o;

my @avail = BB::get_avail();
my @installed = BB::get_installed();

if (! @installed){
    `$c install $avail[-1]`;    
}

# clone custom

$o = `$c clone 5.10.1_32 custom`;
ok -s $customfile > 5, "custom perls file size ok after add";

@installed = BB::get_installed();

$o = `$c exec perl -e ''`;
unlike $o, qr/custom/, "custom clone not included in exec";

# manipulate the config file

open my $fh, '<', $conf or die $!;
my @config = <$fh>;
close $fh;

for (@config){
    if (/custom_exec/){
        s/false/true/;
    }
}

open my $wfh, '>', $conf or die $!;

for (@config){
    print $wfh $_;
}
close $wfh;

$o = `$c exec perl -e ''`;
like $o, qr/custom/, "custom clone included in exec when set in conf";

for (@config){
    if (/custom_exec/){
        s/true/false/;
    }
}

open $wfh, '>', $conf or die $!;

for (@config){
    print $wfh $_;
}
close $wfh;

$o = `$c exec perl -e ''`;
unlike $o, qr/custom/, "custom clone not included in exec after setting config to false";

$o = `$c remove custom`;
like $o, qr/Successfully/, "remove custom install ok";

@avail = BB::get_avail();
ok ! grep {'custom' eq $_} @avail, "custom not in avail";

@installed = BB::get_installed();
ok ! grep {'custom' eq $_} @installed, "custom not in installed";

is -s $customfile, 2, "custom perls file size ok after remove";

done_testing();
