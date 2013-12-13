#!usr/bin/perl
package Webpage;
use LWP::Simple;

sub new {
  my $invocant = shift;
  my $self = {
    url => @_,
    code => "",
    links => {},
    images => {},
    scripts => {},
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
  if($self->{code} eq ''){
    print "An error has occurred in the attempt to pull the source code for the url: " . $self->{url} . "\n";
    return 0;
  } 
  #my $rc = getprint($dmsurl);
  #print status_message($rc);
  $self->analyzeElements($self->{code});
  $self->{num_lines} = $self->{code} =~ tr/\n//;
  return 1;
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
    $self->{links}{$url} += 1;
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
    $self->{images}{$url} += 1;
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
    $self->{scripts}{$url} += 1;
  }
}

sub printAllInfo {
  my($self) = @_;
  print "Information for " . $self->{url} . "\n";
  foreach my $key (sort keys %{$self->{elements}}){
    print "     " . $key . ": " . $self->{elements}{$key} . " \n";
  }
  print "Links\n";
  foreach my $key (sort keys %{$self->{links}}){
    print "     " . $key . ": " . $self->{links}{$key} . " \n";
  }
  print "Images\n";
  foreach my $key (sort keys %{$self->{images}}){
    print "     " . $key . ": " . $self->{images}{$key} . " \n";
  }
  print "Scripts       \n";
  foreach my $key (sort keys %{$self->{scripts}}){
    print "     " . $key . ": " . $self->{scripts}{$key} . " \n";
  }
  print "Classes       \n";
  foreach my $key (sort keys %{$self->{classes}}){
    print "     " . $key . ": " . $self->{classes}{$key} . " \n";
  }
  print "Ids       \n";
  foreach my $key (sort keys %{$self->{ids}}){
    print "     " . $key . ": " . $self->{ids}{$key} . " \n";
  }
}

sub printCommonInfo {
  my($self) = @_;
  print "Most Common Information for " . $self->{url} . "\n";
  print "    Most Common Element: " . $self->mostCommonElement() . " \n";
  print "    Most Common Link: " . $self->mostCommonLink() . " \n";
  print "    Most Common Image: " . $self->mostCommonImage() . " \n";
  print "    Most Common Script: " . $self->mostCommonScript() . " \n";
  print "    Most Common Class: " . $self->mostCommonClass() . " \n";
  print "    Most Common Id: " . $self->mostCommonId() . " \n";
}

sub printTotalInfo {
  my($self) = @_;
  print "Totals Information for " . $self->{url} . "\n";
  print "    Total number of Elements: " . $self->numElements() . " \n";
  print "    Total number of Links: " . $self->numLinks() . " \n";
  print "    Total number of Images: " . $self->numImages() . " \n";
  print "    Total number of Scripts: " . $self->numScripts() . " \n";
  print "    Total number of Classes: " . $self->numClasses() . " \n";
  print "    Total number of Ids: " . $self->numIds() . " \n";
}

sub mostCommonLink {
  my($self) = @_;
  return $self->mostFromHash(%{$self->{links}});  
}

sub mostCommonImage {
  my($self) = @_;
  return $self->mostFromHash(%{$self->{images}});  
}

sub mostCommonScript {
  my($self) = @_;
  return $self->mostFromHash(%{$self->{scripts}});  
}

sub mostCommonElement {
  my($self) = @_;
  return $self->mostFromHash(%{$self->{elements}});
}

sub mostCommonClass {
  my($self) = @_;
  return $self->mostFromHash(%{$self->{classes}});  
}

sub mostCommonId {
  my($self) = @_;
  return $self->mostFromHash(%{$self->{ids}});  
}

sub numLinks {
  my($self) = @_;
  return $self->numFromHash(%{$self->{links}});  
}

sub numImages {
  my($self) = @_;
  return $self->numFromHash(%{$self->{images}});  
}

sub numScripts {
  my($self) = @_;
  return $self->numFromHash(%{$self->{scripts}});  
}

sub numElements {
  my($self) = @_;
  return $self->numFromHash(%{$self->{elements}});  
}

sub numElementTypes {
  my($self) = @_;
  return scalar keys %{$self->{elements}};  
}

sub numClasses {
  my($self) = @_;
  return $self->numFromHash(%{$self->{classes}});  
}

sub numIds {
  my($self) = @_;
  return $self->numFromHash(%{$self->{ids}});
}

sub numFromHash {
  my($self, %hash) = @_;
  $total_val = 0;
  foreach my $key (keys %hash){
    $total_val += $hash{$key};
  }
  return $total_val;
}

sub mostFromHash {
  my($self, %hash) = @_;
  $max_key = '';
  $max_val = 0;
  foreach my $key (keys %hash){
    if($hash{$key} > $max_val){
      $max_val = $hash{$key};
      $max_key = $key;
    }
  }
  return $max_key;
}

1;