#!usr/bin/perl
package WebpageAnalyzer;

sub new {
  my $invocant = shift;
  my $self = {
    webpages => [],
  };
  bless($self, $invocant);
  return $self;
}

sub addWebpage {
  my($self, $url) = @_;
  $webpage = new Webpage($url);
  $webpage->analyze();
  push(@{$self->{webpages}}, $webpage);
}

sub deleteWebpage {
  my($self, $delete_index) = @_;
  $deleted = splice(@{$self->{webpages}}, $delete_index, 1);
  return $deleted->{url};
}

sub printWebpages {
  my($self) = @_;
  if(!@{$self->{webpages}}){
    print "No webpages added yet.\n"
  }
  else{
    for my $i (0..(@{$self->{webpages}} - 1)){
      $webpage = @{$self->{webpages}}[$i];
      print "$i: " . $webpage->{url} . "\n"; 
    }  
  }
}

sub getWebpage {
  my($self, $index) = @_;
  return @{$self->{webpages}}[$index];
}

sub validIndex {
  my($self, $index) = @_;
  $valid = 0;
  foreach(0..(@{$self->{webpages}} - 1)){
    if($index == $_){
      $valid = 1;
    }
  }
  return $valid;
}

1;