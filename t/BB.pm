package BB;

my $c = 'c:\repos\berrybrew\build\berrybrew';

sub get_avail {
    my $list = `$c available`;
    my @avail = split /\n/, $list;

    @avail = grep {/^\s+/} @avail;

    @avail = grep {$_ !~ /installed/} @avail;

    return @avail;
}
sub get_installed {
    my $list = `$c available`;
    my @avail = split /\n/, $list;

    @avail = grep {/^\s+.*/} @avail;

    my @installed;

    for (@avail){
        s/^\s+//;
        if (/(.*?)\s+.*\[installed\]/){
            push @installed, $1;
        }
    }   

    return @installed;
}

1;
