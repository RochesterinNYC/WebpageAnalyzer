#!usr/bin/perl

=head1 NAME

Webpage

=head1 SYNOPSIS

A module representing a webpage and its analyzed source code content

=head1 DESCRIPTION

A Website object contains a url, the source code of the webpage associated with
the url, the number of lines the source code has, and links, images, scripts, 
elements, classes, and ids. All of these are stored as hashes where the keys are
the name or location of the link, image, script, etc. and the values are the number
of times it's referenced on the webpage. For the class, ids, and elements, the 
keys is the name of the element, class, or id, and the value is the number
of times it's used.

=head2 Methods

=over

=item C<new>

Returns a new Webpage object. Takes in webpage url as argument.

=item C<analyze>

Initiates the parsing and analysis of the webpage source code.
Returns whether the analysis was successful.

=item C<analyzeElements>

Parses the webpage source code and counts and tracks things like elements, 
links, images, scripts, classes, ids.

=item C<processLink>

Parses the contents of a link element and records the url of the link.

=item C<processImage>

Parses the contents of an image element and records the url of the image.

=item C<processScript>

Parses the contents of a script element and records the url of the script.

=item C<processClass>

Parses the contents of an element and records any classes it may have.

=item C<processId>

Parses the contents of an element and records any ids it may have.

=item C<printAllInfo>

Prints all the elements, links, images, scripts, classes, ids for this webpage.

=item C<printCommonInfo>

Prints all the most common elements, links, images, scripts, classes, ids for this webpage.

=item C<printTotalInfo>

Prints all the total counts for the elements, links, images, scripts, classes, ids for this webpage.

=item C<mostCommonLink>

Returns the most common link on this webpage.

=item C<mostCommonImage>

Returns the most common image on this webpage.

=item C<mostCommonScript>

Returns the most common script on this webpage.

=item C<mostCommonElement>

Returns the most common element on this webpage.

=item C<mostCommonClass>

Returns the most common class on this webpage.

=item C<mostCommonId>

Returns the most common id on this webpage.

=item C<numLinks>

Returns the number of links on this webpage.

=item C<numImages>

Returns the number of images on this webpage.

=item C<numScripts>

Returns the number of scripts on this webpage.

=item C<numElements>

Returns the number of elements on this webpage.

=item C<numElementTypes>

Returns the number of types of elements on this webpage.

=item C<numClasses>

Returns the number of classes on this webpage.

=item C<numIds>

Returns the number of ids on this webpage.

=item C<numFromHash>

Returns the total number of an element from a hash where the keys are elements 
or references and the values are their counts.
Takes in the hash as argument.

=item C<mostFromHash>

Returns the element with the greatest count from a hash where the keys are elements 
or references and the values are their counts.
Takes in the hash as argument.

=back

=head1 AUTHOR

James Wen

=cut

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
  #Return and don't do element analysis if get request failed and no source code pulled
  if($self->{code} eq ''){
    print "An error has occurred in the attempt to pull the source code for the url: " . $self->{url} . "\n";
    return 0;
  }
  #Source code was successfully retrieved and will be analyzed
  $self->analyzeElements($self->{code});
  $self->{num_lines} = $self->{code} =~ tr/\n//;
  return 1;
}

sub analyzeElements {
  my($self) = @_;
  my @lines = split(/\n/, $self->{code});
  foreach(@lines){
    #Match structure of an HTML element
    my @matches = ($_ =~ m/<([\w]+[\d]*[\d\w\s].*?)?>/g);
    foreach my $match (@matches) {
      #Break down HTML element into its element type and attributes
      if($_ =~ m/<([\w]+[\d]*)([\d\w\s].*?)?>/g){
        $self->{elements}{$1} += 1;
        $element = $1;
        #Strip whitespace
        $element =~ s/^\s+|\s+$//g;
        #Element is link
        if($element eq 'a'){
          $self->processLink($2);
        }
        #Element is image
        elsif($element eq 'img'){
          $self->processImage($2);
        }
        #Element is script
        elsif($element eq 'script'){
          $self->processScript($2);
        }
        $self->processClass($2);
        $self->processId($2);
      }
    }
  }
}

sub processLink {
  my($self, $link) = @_;
  if($link =~ m/href[\s]*=[\s]*"([\s]*[\/\d\w:?&#%=~+!_.-]*[\s]*)??"/g){
    $url = $1;
    #Link is a relative route and root is website host (adds the root)
    if(!((substr($url, 0, 5) eq 'http:') || (substr($url, 0, 6) eq 'https:'))){
      $url = $self->{url} . '/' . $url;
    }
    $self->{links}{$url} += 1;
  }
}
sub processImage {
  my($self, $image) = @_;
  if($image =~ m/src[\s]*=[\s]*"([\s]*[\/\d\w:?&#%=~+!_.-]*[\s]*)??"/g){
    $url = $1;
    #Image is a relative route and root is website host (adds the root)
    if(!((substr($url, 0, 5) eq 'http:') || (substr($url, 0, 6) eq 'https:'))){
      $url = $self->{url} . '/' . $url;
    }
    $self->{images}{$url} += 1;
  }
}
sub processScript {
  my($self, $script) = @_;
  if($script =~ m/src[\s]*=[\s]*"([\s]*[\/\d\w:?&#%=~+!_.-]*[\s]*)??"/g){
    $url = $1;
    #Script is a relative route and root is website host (adds the root)    
    if(!((substr($url, 0, 5) eq 'http:') || (substr($url, 0, 6) eq 'https:'))){
      $url = $self->{url} . '/' . $url;
    }
    $self->{scripts}{$url} += 1;
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