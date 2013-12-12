#!usr/bin/perl
package Webpage;
use LWP::Simple;

sub new {
  my $invocant = shift;
  my $self = {
    url => @_,
    code => "",
    links => [],
    images => [],
    scripts => [],
    elements => {},
  };
  bless($self, $invocant);
  return $self;
}

sub analyze {
  my($self) = @_;
  $self->{code} = get($self->{url});
  #my $rc = getprint($dmsurl);
  #print status_message($rc);
  $self->analyzeElements($self->{code});
}

sub analyzeElements {
  my($self) = @_;
  my @lines = split(/\n/, $self->{code});
  foreach(@lines){
    if($_ =~ m/<([\w]+[\d]*)([\d\w\s].*?)?>/g){
      $self->{elements}{$1} += 1;
      if($1 eq 'a'){
        print "test\n";
        $self->processLink($2);
      }
      elsif($1 eq 'img'){
        print "img\n";

        $self->processImage($2);
      }
    }
  }
  foreach my $key (keys %{$self->{elements}}){
    print $key . ": " . $self->{elements}{$key} . " \n";
  }
  print "       Links       \n";
  foreach(@{$self->{links}}){
    print $_ . " \n";
  }
  print "       Images       \n";
  foreach(@{$self->{images}}){
    print $_ . " \n";
  }
}

sub processLink {
  my($self, $link) = @_;
  print $link . "\n";
  if($link =~ m/href[\s]*=[\s]*"([\s]*[\/\d\w:?&#%=~+!_.-]*[\s]*)??"/g){
    $url = $1;
    if(!((substr($url, 0, 5) eq 'http:') || (substr($url, 0, 6) eq 'https:'))){
      $url = $self->{url} . '/' . $url;
    }
    push(@{$self->{links}}, $url);
  }
}
sub processImage {
  my($self, $image) = @_;
  print $image . "\n";

  if($image =~ m/src[\s]*=[\s]*"([\s]*[\/\d\w:?&#%=~+!_.-]*[\s]*)??"/g){

    $url = $1;
    if(!((substr($url, 0, 5) eq 'http:') || (substr($url, 0, 6) eq 'https:'))){
      $url = $self->{url} . '/' . $url;
    }
    push(@{$self->{images}}, $url);
  }
}

1;