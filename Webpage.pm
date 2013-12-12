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
    classes => {},
    ids => {},
    num_lines => 0,
  };
  bless($self, $invocant);
  return $self;
}

sub analyze {
  my($self) = @_;
  $self->{code} = get($self->{url});
  $self->analyzeElements($self->{code});
  $self->{num_lines} = $self->{code} =~ tr/\n//;
}

sub analyzeElements {
  my($self) = @_;
  my @lines = split(/\n/, $self->{code});
  foreach(@lines){
    my @matches = ($_ =~ m/<([\w]+[\d]*[\d\w\s].*?)?>/g);
    foreach my $match (@matches) {
      if($_ =~ m/<([\w]+[\d]*)([\d\w\s].*?)?>/g){
        $self->{elements}{$1} += 1;
        $element = $1;
        $element =~ s/^\s+|\s+$//g;
        if($element eq 'a'){
          $self->processLink($2);
        }
        elsif($element eq 'img'){
          $self->processImage($2);
        }
        elsif($element eq 'script'){
          $self->processScript($2);
        }
        $self->processClass($2);
        $self->processId($2);
      }
    }
  }
}
 
sub processClass {
  my($self, $class) = @_;
  if($class =~ m/class[\s]*=[\s]*"([\s\d\w.:_-]*)"/g){
    my @classes = split(/\s+/, $1);
    foreach(@classes){
      $self->{classes}{$_} += 1;
    }
  }
}

sub processId {
  my($self, $id) = @_;
  if($id =~ m/id[\s]*=[\s]*"([\s\d\w.:_-]*)"/g){
    my @ids = split(/\s+/, $1);
    foreach(@ids){
      $self->{ids}{$_} += 1;
    }
  }
}

sub processLink {
  my($self, $link) = @_;
#  print $link . "\n";
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
#  print $image . "\n";
  if($image =~ m/src[\s]*=[\s]*"([\s]*[\/\d\w:?&#%=~+!_.-]*[\s]*)??"/g){
    $url = $1;
    if(!((substr($url, 0, 5) eq 'http:') || (substr($url, 0, 6) eq 'https:'))){
      $url = $self->{url} . '/' . $url;
    }
    push(@{$self->{images}}, $url);
  }
}
sub processScript {
  my($self, $script) = @_;
#  print $script . "\n";
  if($script =~ m/src[\s]*=[\s]*"([\s]*[\/\d\w:?&#%=~+!_.-]*[\s]*)??"/g){
    $url = $1;
    if(!((substr($url, 0, 5) eq 'http:') || (substr($url, 0, 6) eq 'https:'))){
      $url = $self->{url} . '/' . $url;
    }
    push(@{$self->{scripts}}, $url);
  }
}

sub printInfo {
  my($self) = @_;
  print "       Information for " . $self->{url} . "\n";
  foreach my $key (sort keys %{$self->{elements}}){
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
  print "       Scripts       \n";
  foreach(@{$self->{scripts}}){
    print $_ . " \n";
  }
  print "       Classes       \n";
  foreach my $key (sort keys %{$self->{classes}}){
    print $key . ": " . $self->{classes}{$key} . " \n";
  }
  print "       Ids       \n";
  foreach my $key (sort keys %{$self->{ids}}){
    print $key . ": " . $self->{ids}{$key} . " \n";
  }
}
1;