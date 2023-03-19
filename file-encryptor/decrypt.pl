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

# Decrypt each file in current directory
my @files = grep { -f $_ } glob("*");
foreach my $file (@files) {
    next if $file =~ /\.enc$/;   # Skip encrypted files
    next unless -f $file;        # Skip non-files
    next unless -r $file;        # Skip unreadable files
    next if -d $file;            # Skip directories
    my $enc_file = $file.'.enc';
    next unless -e $enc_file;    # Skip files with no corresponding .enc file

    # Read file contents
    open my $fh, '<', $enc_file or die "Can't open $enc_file: $!";
    my $ciphertext = do { local $/; <$fh> };
    close $fh;

    # Decrypt file contents
    my $plaintext = $cipher->decrypt($ciphertext);

    # Write decrypted file
    open $fh, '>', $file or die "Can't write to $file: $!";
    print $fh $plaintext;
    close $fh;

    # Remove encrypted file
    unlink $enc_file or die "Can't remove $enc_file: $!";
}

print "Decryption complete.\n";
