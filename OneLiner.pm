# vi:fdm=marker fdl=0 syntax=perl:
# $Id: OneLiner.pm,v 1.3 2004/01/16 16:51:08 jettero Exp $

package Net::SMTP::OneLiner;

use strict;
use Carp;
use Net::SMTP;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw( send_mail );
our $VERSION = '1.0';

sub send_mail {
    my ($from, $to, $subj, $msg, $cc, $bcc, $labl) = @_;
    my $smtp = Net::SMTP->new("localhost", Hello=>"localhost", Timeout=>20, Debug=>0) or croak "$!";

    $to = [ $to ] unless ref($to);
    $cc = []      unless ref($cc);

    $smtp->mail($from);
    $smtp->to(@$to);

    $smtp->data;

    for ($from, @$to, @$cc) {
        $_ = "$labl->{$_} <$_>" if defined $labl->{$_};
    }

    $to = join(", ", @$to);
    $cc = join(", ", @$cc);

    $smtp->datasend("From: $from\n");
    $smtp->datasend("To: $to\n");
    $smtp->datasend("CC: $cc\n") if $cc;
    $smtp->datasend("Subject: $subj\n\n");

    $smtp->datasend($msg);

    $smtp->dataend;
    $smtp->quit;
}

__END__

=head1 NAME

Net::SMTP::OneLiner - extension that polutes the local namespace with a send_mail() function.

=head1 A brief example

    use Net::SMTP::OneLiner;

    my $from = 'me@mydomain.tld';
    my $to   = [qw(some@targ.tld one@targ.tld)];
    my $cc   = [qw(some@targ.tld one@targ.tld)];
    my $bcc  = [qw(some@targ.tld one@targ.tld)];
    my $subj = "The Subject";
    my $msg  = "The Message";
    my $labl = { 'me@mydomain.tld' => "My RealName", 'one@targ.tld' => "Their realname" };

     
    # Examples:

    send_mail($from, $to, $subj, $msg);
    send_mail($from, $to, $subj, $msg, $cc);
    send_mail($from, $to, $subj, $msg, undef, $bcc);
    send_mail($from, $to, $subj, $msg, $cc, $bcc, $labl);
    send_mail($from, $to, $subj, $msg, undef, undef, $labl);

    send_mail('me@domain', ['you@domain'], "heyya there", "supz!?!?");

    # The simplest way:

    send_mail('me@domain', 'you@domain', "heyya there", "supz!?!?");

    # $to will take a scalar argument, $cc and $bcc will not.
    # At this time, the mail server, must be the localhost.

=head1 Bugs

Please report bugs immediately!  The author has not tested this
module worth a lick -- expecting it to work just fine.  If this
is not the case, he would like to know, so he can fix it.

=head1 Author

Jettero Heller jettero@cpan.org

=cut
