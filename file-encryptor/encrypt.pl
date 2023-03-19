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

my @files = grep { !/(^|\/)(encrypt|decrypt)\.pl$/ && !/\.enc$/ } glob("*");

foreach my $file (@files) {
    # Read file contents
    open my $fh, '<', $file or die "Can't open $file: $!";
    my $plaintext = do { local $/; <$fh> };
    close $fh;

    # Encrypt file contents
    my $ciphertext = $cipher->encrypt($plaintext);

    # Write encrypted file
    open $fh, '>', "$file.enc" or die "Can't write to $file.enc: $!";
    print $fh $ciphertext;
    close $fh;

    # Remove original file
    unlink $file or die "Can't remove $file: $!";
}

print "Encryption complete.\n";
