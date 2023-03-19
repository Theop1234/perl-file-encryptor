use strict;
use warnings;
use Crypt::CBC;

# Get password from user
print "Enter password: ";
my $password = <STDIN>;
chomp $password;

# Initialize decryption cipher
my $cipher = Crypt::CBC->new(
    -key    => $password,
    -cipher => 'Blowfish',
);

# Get list of files to decrypt
my @files = grep { /\.enc$/ } glob("*");

# Decrypt each file
foreach my $file (@files) {
    # Read file contents
    open my $fh, '<', $file or die "Can't open $file: $!";
    my $ciphertext = do { local $/; <$fh> };
    close $fh;

    # Decrypt file contents
    my $plaintext = $cipher->decrypt($ciphertext);

    # Write decrypted file
    $file =~ s/\.enc$//;
    open $fh, '>', $file or die "Can't write to $file: $!";
    print $fh $plaintext;
    close $fh;

    # Remove encrypted file
    unlink $file.'.enc' or die "Can't remove $file.enc: $!";
}

print "Decryption complete.\n";
