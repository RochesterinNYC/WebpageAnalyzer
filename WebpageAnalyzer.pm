#!usr/bin/perl

#!usr/bin/perl

#!usr/bin/perl

=head1 NAME

WebpageAnalyzer

=head1 SYNOPSIS

A module that represents an analyzer for Webpage objects that handles a collection 
of websites and presenting the information and comparisons between them.

=head1 DESCRIPTION

The Website Analyzer primary acts as a Processor that holds the collection of webpage objects
as an array in its instance variables and then interfaces with the WebsiteAnalyzerMenu
to add, delete, compare, and print information for Webpages.

=head2 Methods

=over

=item C<new>

Returns a new WebpageAnalyzer object.

=item C<addWebpage>

Analyzes a webpage and adds it to the stored webpages the analyzer holds.
If the retrieving of the source code or analysis fails, the webpage will not be added.
Takes in url of webpage to add as an argument.

=item C<deleteWebpage>

Deletes a webpage from the stored webpages the analyzer holds.
Takes in the index of the webpage to delete as an argument.
Returns url of deleted webpage.

=item C<printWebpages>

Prints the urls of all the Webpages currently stored.

=item C<getWebpage>

Returns a specific webpage that is currently stored.
Takes in the index of the webpage to return as an argument.

=item C<seeAllWebpages>

Prints out all the webpages.

=item C<validIndex>

Returns whether a webpage is currently stored at the specified index.
Takes in the index as an argument.

=back

=head1 AUTHOR

James Wen

=cut

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
  $url_www = substr($url, 0, 3);
  $url_http = substr($url, 0, 4);
  #Fix formatting of url if necessary since LWP requires http://www.
  if($url_http eq "http"){
    $final_url = $url;
  }
  elsif($url_www eq "www"){
    $final_url = "http://" . $url;
  }
  else{
    $final_url = "http://www." . $url;
  }
  $webpage = new Webpage($final_url);
  if($webpage->analyze()){
    push(@{$self->{webpages}}, $webpage);
    print $final_url . " was successfully added.\n";
  }
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