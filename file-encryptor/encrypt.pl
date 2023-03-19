#!/usr/bin/perl

#this encrypts this file


use strict;
use warnings;
use Crypt::CBC;


print "Enter password:\t";
my $password = <STDIN>;
chomp $password;

# Initialize encryption cipher
my $cipher = Crypt::CBC->new(
    -key    => $password,
    -cipher => 'Blowfish',
);

# Encrypt each file in current directory
my @files = grep { -f $_ } glob("*");
foreach my $file (@files) {
    next if $file =~ /\.enc$/;   # Skip already encrypted files
    next unless -f $file;        # Skip non-files
    next unless -r $file;        # Skip unreadable files
    next if -d $file;            # Skip directories
    next if $file eq 'decrypt.pl';  # Skip decrypted.pl
    my $enc_file = $file.'.enc';
    next if -e $enc_file;        # Skip files with existing .enc file

    open my $fh, '<', $file or die "Can't open $file: $!";
    my $plaintext = do { local $/; <$fh> };
    close $fh;

    my $ciphertext = $cipher->encrypt($plaintext);

    # Write encrypted file
    open $fh, '>', $enc_file or die "Can't write to $enc_file: $!";
    print $fh $ciphertext;
    close $fh;

    # Remove plaintext file
    unlink $file or die "Can't remove $file: $!";
}

print "Encryption complete.\n";
