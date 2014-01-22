package Lingua::MPoem;

use warnings;
use strict;

use strict;
use Encode;
use Encode::Guess;

=head1 NAME

Lingua::MPoem - Poetry generation form Mpoem files

=head1 SYNOPSIS

 use Lingua::MPoem;
 my $foo = Lingua::MPoem::generate($mpoem1, $mpeom2, ...)
 my $foo = Lingua::MPoem::generate([$file1, $file2, ...])

=head1 Mpoem format

Mpoem format (simple)

 Mpoem   = strophe ("\n=\n" strophe)*
 strophe = versehs ("\n\n"  versehs)*
 versehs = verse   ("\n"    verse)*

Mpoem format (complete)

 Mpoem   = strophe ("\n=\n" strophe)*
 strophe = versehs ("\n\n"  versehs)*
         | "s\d+=" strophe            (save a strophe)
         | "+s\d+"                    (repeat a strophe)
 versehs = verse   ("\n"    verse)*
         | (v\d+=) versehs            (save a verse)
         | "+v\d+"                    (repeat a verse)
 verse   = ("\d+")? line         (restricted agreement)

Example


=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
my $res=0;    ## verse with restrictions
my %v=();     ## repeated verses
my %s=();     ## repeated strophes and refrain


=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 generate(mpoem)

 $p = generate($mpoem+)
 $p = generate([filename+])

=cut

sub generate{ my ($txt,@r)=@_;
  if   (ref($txt)) {$txt = _fileread(_choice_res( @$txt));}
  elsif(@r)        {$txt = _choice_res( $txt,@r);}
  my $r="";
  for my $est( split(/\n+=\n+/,$txt)  ){
    undef $res;
    my $stro="";
    my @vs = ( split(/\n{2,}/,$est));
    if($vs[0] =~ /\+e(\d+)/){ 
      $stro = $s{$1} or warn("Error e$1=... missing\n"); }
    else{
      my $vid=0;
      if($vs[0] =~ s/^e(\d+)=\s*//){ $vid=$1; }
      for my $ver (@vs){
        $stro .=  _choice_res( split(/\n/,$ver)) . "\n"
      }
      $s{$vid}=$stro if $vid;
    }
    
    $r.= "$stro\n";
  }
  $r =~ s/\n$//;
  $r; 
}

sub _choice{ $_[int(rand(@_))] }

sub _choice_res{ 
 my $stv=0;
 my $final;
 if($_[0] =~ m/^v(\d+)=/){$stv=$1; shift(@_)} #verse to be saved
 my $a = _choice(@_);
 
 #regenerate if verse constraint is not satisfied
 while($res and $a =~ m/^(\d+)\s*(.*)/ and $res != $1)
    {$a = _choice(@_);}

 if($a =~ /^(\d+)\s*(.*)/){
    if   (not $res){ $res = $1 ; $final= $2;}
    elsif($res and $res == $1) { $final= $2;}
 }
 elsif($a =~ /^\+v(\d+)/){ $a =~ s/\+v(\d+)/$v{$1}/g;
                           $final= $a;}
 elsif($a =~ /^\+e(\d+)/){ $a =~ s/\+e(\d+)/$s{$1}/;
                           $a =~ s/\s*$//;
                           $final= $a;}
 else { $final= $a}

 $v{$stv}=$final if $stv;

 $final
}

sub _fileread{
  local $/;
  undef $/;
  open(F,"<",$_[0]) or die("can open $_[0]\n");
  my $txt = <F>;
  close F;
  _enc_norm($txt);
}

sub _enc_norm{
 my $t = shift;
 my $decoder = Encode::Guess->guess($t);  ### is it utf8, ascii, utf?
 if(ref($decoder)){ $t = $decoder->decode($t);}
 $t
}

=head1 Sea Also

poeta command 

=head1 AUTHOR

JJoao, C<< <jj at di.uminho.pt> >>

=head1 BUGS

=cut

1; # End of Lingua::MPoem
