requires 'perl', '5.008001';

requires 'Carp' => 0;
requires 'URI' => 0;
requires 'Furl' => 0;
requires 'XML::XPath::Diver' => 0;
requires 'HTML::Tidy::libXML' => 0;

on 'test' => sub {
    requires 'Test::More', '0.98';
};

