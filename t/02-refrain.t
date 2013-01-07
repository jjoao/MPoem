#!perl -T

use Test::More tests => 4;
use Test::Output ;
use Lingua::MPoem;

my $txt="v1=
linha1

v2=
linha2
linha2

+v1

+v2";

my $txt2="1 aaa

1 aaa
2 bbb
3 ccc
4 ddd";

is(Lingua::MPoem::generate($txt), "linha1\nlinha2\nlinha1\nlinha2\n", "Teste generate");
is(Lingua::MPoem::generate($txt2), "aaa\naaa\n", "Teste generate");
is(Lingua::MPoem::_choice(33), 33, "Teste choice1");
my $r= Lingua::MPoem::_choice(33..39);
ok(($r >= 33 && $r <= 39), "Teste choice2");
