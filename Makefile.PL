# vi:set syntax=perl:
# $Id: Makefile.PL,v 1.2 2004/01/15 20:23:04 jettero Exp $

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'Net::SMTP::OneLiner',
    'VERSION_FROM' => 'OneLiner.pm',
    'PREREQ_PM'    => {'Net::SMTP'},

);
