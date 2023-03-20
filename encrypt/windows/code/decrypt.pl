use strict;
use warnings;
use Crypt::CBC;

print "Enter password:\t";
my $password = <STDIN>;
chomp $password;

my $cipher = Crypt::CBC->new(
    -key    => $password,
    -cipher => 'Blowfish',
);

my @files = grep { /\.enc$/ } glob("*");

foreach my $file (@files) {
    # Read file contents
    open my $fh, '<', $file or die "Can't open $file: $!";
    my $ciphertext = do { local $/; <$fh> };
    close $fh;

    my $plaintext = $cipher->decrypt($ciphertext);

    $file =~ s/\.enc$//;
    open $fh, '>', $file or die "Can't write to $file: $!";
    print $fh $plaintext;
    close $fh;

    unlink $file.'.enc' or die "Can't remove $file.enc: $!";
}

print "Decryption complete.\n";