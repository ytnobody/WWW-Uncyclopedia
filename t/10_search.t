use strict;
use utf8;
use Test::More;
use WWW::Uncyclopedia;
use Capture::Tiny 'capture';

subtest '日本' => sub {
    my $text = WWW::Uncyclopedia->search('日本');
    like $text, qr/^小日本ブラック自治国（State of brack\(engrish\;miss spell\) Japan）はガラパゴス諸島の何処かで沈みつつある島国で/;
};

subtest 'not found' => sub {
    my ($stdout, $stderr) = capture {
        WWW::Uncyclopedia->search('Jkfhjkglじゃfdkgl');
    };
    like $stderr, qr|GET http://ja.uncyclopedia.info/wiki/Jkfhjkgl%E3%81%98%E3%82%83fdkgl : 404 Not Found|;
};

done_testing;
