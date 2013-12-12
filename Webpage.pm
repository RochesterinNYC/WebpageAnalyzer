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
    if($_ =~ m/<([\w]+[\d]*)/g){
      print $_ . "\n";
      $self->{elements}{$1} += 1;
      if($1 eq 'a'){
        $self->processImage($2);
      }
      elsif($1 eq 'img'){
        $self->processLink($2);
      }
    }
  }
  foreach my $key (keys %{$self->{elements}}){
    print $key . ": " . $self->{elements}{$key} . " \n";
  }
}

sub processLink {
  my($self, $link) = @_;
  if($link =~ m/href[\s]*=[\s]*"[\s]([\w]*)[\s]"/g){
    push(@{$self->{links}}, $1);
  }
}
sub processImage {
  my($self, $image) = @_;
  if($image =~ m/src[\s]*=[\s]*"[\s]([\w]*)[\s]"/g){
    push(@{$self->{images}}, $1);
  }
}

1;