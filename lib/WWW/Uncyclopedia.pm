package WWW::Uncyclopedia;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";
our $BASE_URL = 'http://ja.uncyclopedia.info/';
our $TIMEOUT = 60;

use Carp;
use URI;
use Furl;
use XML::XPath::Diver;
use HTML::Tidy::libXML;

my $agent = Furl->new(agent => __PACKAGE__.'/'.$VERSION, timeout => $TIMEOUT);
my $tidy = HTML::Tidy::libXML->new;

sub search {
    my ($class, $word) = @_;

    my $uri = URI->new($BASE_URL);
    $uri->path('/wiki/'. $word);

    my $res = $agent->get($uri->as_string);
    unless ($res->is_success) {
        carp(sprintf('GET %s : %s', $uri->as_string, $res->status_line));
        return;
    }

    $class->_parse($res->content);
}

sub _parse {
    my ($class, $html) = @_;

    my $content = $tidy->html2dom($html, 'UTF-8');

    my $diver = XML::XPath::Diver->new(xml => $content);
    my $text = join("\n", map {$_->text} $diver->dive('//div[@class="mw-content-ltr"]/p') );
    $text =~ s/\n\n+/\n/g;
    $text =~ s/^[\n\t\s]+//;
    $text;
}


1;
__END__

=encoding utf-8

=head1 NAME

WWW::Uncyclopedia - Perl interface class for Uncyclopedia(L<http://ja.uncyclopedia.info>)

=head1 SYNOPSIS

    use WWW::Uncyclopedia;
    my $text = WWW::Uncyclopedia->search('盥回し');

=head1 DESCRIPTION

WWW::Uncyclopedia is an interface class for Uncyclopedia.

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

