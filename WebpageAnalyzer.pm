#!usr/bin/perl
package WebpageAnalyzer;

sub new {
  my $invocant = shift;
  my $self = {
    webpages => [],
  }
  bless($self, $invocant);
  return $self;
}

sub addWebpage {
  my($self, $url) = @_;
  $webpage = new Webpage($url);
  push(@{$self->{webpages}}, $webpage);
}

sub deleteWebpage {
  my($self, $delete_index) = @_;
  splice(@{$self->{webpages}}, $delete_index, 1); 
}

sub printWebpages {
  my($self, $delete_index) = @_;
  for my $i (0..$#@{$self->{webpages}}){
    print "$i: " . @{$self->{webpages}}[$i]->getURL() . "\n"; 
  }
}

sub validIndex {
  my($self, $index) = @_;
  $valid = 0;
  foreach(0..$#@{$self->{webpages}}){
    if($selection == $_){
      $valid = 1;
    }
  }
  return $valid;
}

1;