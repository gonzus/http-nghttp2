use 5.008009;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME           => 'HTTP::NGHTTP2',
    VERSION_FROM   => 'lib/HTTP/NGHTTP2.pm',
    ABSTRACT_FROM  => 'lib/HTTP/NGHTTP2.pm',
    LICENSE        => 'mit',
    MIN_PERL_VERSION => 5.008009,
    PREREQ_PM      => {
        'XSLoader'    => 0,
    },
    TEST_REQUIRES  => {
        'Test::More'            => 0,
        'Test::LeakTrace'       => 0,
        'Data::Dumper'          => 0,
    },
    AUTHOR         => [
        'Gonzalo Diethelm (gonzus@cpan.org)',
        'Sawyer X (xsawyerx@cpan.org)',
        'Andrei Vereha (avereha@cpan.org)',
        'Vickenty Fesunov (kent@setattr.net)',
        'Mickey Nasriachi (mickey@cpan.org)',
    ],
    LIBS           => ['-lnghttp2'],
#    DEFINE         => '-DGMEM_CHECK',
    INC            => '-I.',
    OBJECT         => '$(O_FILES)',
    test => {
        'TESTS' => 't/*.t t/client/*.t',
    },
    META_MERGE     => {
        'meta-spec' => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url  => 'git@github.com:gonzus/http-nghttp2',
                web  => 'https://github.com/gonzus/http-nghttp2',
            },
        },
    },
);

# Add options CCFLAGS without overwriting the defaults
package MY;
sub cflags {
    my $self   = shift;
    my $cflags = $self->SUPER::cflags(@_);
    my @cflags = split /\n/, $cflags;

    $self->{CCFLAGS} .= ' -Wall';                # Flag all warnings
    $self->{CCFLAGS} .= ' -std=c89';             # Compile according to C89 standard

    # Need this define for localtime_r(), except on FreeBSD
    if ($^O ne 'freebsd') {
        $self->{CCFLAGS} .= ' -D_XOPEN_SOURCE=700';
    }

    foreach (@cflags) {
        $_ = "CCFLAGS = $self->{CCFLAGS}" if /^CCFLAGS/;
    }
    return $self->{CFLAGS} = join("\n", @cflags) . "\n";
}
