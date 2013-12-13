#!usr/bin/perl
package WebpageAnalyzerMenu;
use Exporter;
use WebpageAnalyzer;
our @ISA = qw(Exporter);
our @EXPORT = qw(operateMenu);
my $analyzer = new WebpageAnalyzer();

sub operateMenu {
  $option = 1;
  while($option){
    $option = presentMenu();
  }
}

sub presentMenu {
  $selection = -1;
  while (!validSelection($selection)){
    print "Please enter the correct number for an option selection:\n";
    print "Enter 1 to see all Webpages currently in the Analyzer.\n";
    print "Enter 2 to add a Webpage to the Analyzer.\n";
    print "Enter 3 to delete a Webpage from the Analyzer.\n";
    print "Enter 4 to see a Webpage's complete information breakdown.\n";
    print "Enter 5 to see a Webpage's totals information.\n";
    print "Enter 6 to see a Webpage's most common elements information.\n";
    print "Enter 7 to compare the total number of elements on each Webpage.\n";
    print "Enter 8 to compare the total number of different element types on each Webpage.\n";
    print "Enter 9 to compare the total number of links on each Webpage.\n";
    print "Enter 10 to compare the total number of images on each Webpage.\n";
    print "Enter 11 to compare the total number of scripts on each Webpage.\n";
    print "Enter 12 to compare the total number of classes on each Webpage.\n";
    print "Enter 13 to compare the total number of ids on each Webpage.\n";
    print "Enter 14 to compare the total number of lines of code on each Webpage.\n";
    print "Enter 0 to end the program.\n";
    $selection = <STDIN>;
    chomp($selection);
  }
  processSelection($selection);
  return $selection;
}
  
sub processSelection {
  $selection = @_[0];
  if($selection == 1){
    seeAllWebpages();
  }
  if($selection == 2){
    addWebpage();
  }
  if($selection == 3){
    deleteWebpage();
  }
  if($selection == 4){
    webpageInfo();
  }
  if($selection == 5){
    webpageTotals();
  }
  if($selection == 6){
    webpageMostCommons();
  }
  if($selection == 7){
    compareElements(); 
  }
  if($selection == 8){
    compareDiffElements();
  }
  if($selection == 9){
    compareLinks();
  }
  if($selection == 10){
    compareImages();
  }
  if($selection == 11){
    compareScripts();
  }
  if($selection == 12){
    compareClasses();
  }
  if($selection == 13){
    compareIds();    
  }
  if($selection == 14){
    compareLines();    
  }
  if($selection == 0){
    print "Thanks for using the Webpage Analyzer.\n";
  }
}

sub validSelection {
  $selection = @_[0];
  $valid = 0;
  foreach(0..15){
    if($selection == $_){
      $valid = 1;
    }
  }
  return $valid;
}

sub selectWebpage{
  $index = -1;
  while(!$analyzer->validIndex($index)){
    print "These are the current webpages that are added:\n";
    seeAllWebpages();
    print "Please enter the correct index of the webpage you wish to perform this operation for.\n";
    $index = <STDIN>;
    chomp $index;
  }
  return $index;
}

sub seeAllWebpages {
  $analyzer->printWebpages();
}

sub addWebpage {
  print "Please enter the url of the webpage you wish to add.\n";
  $webpage = <STDIN>;
  chomp $webpage;
  $analyzer->addWebpage($webpage);
}

sub deleteWebpage {
  print "What is the index of the webpage you wish to delete?\n";
  $index = selectWebpage();
  $deleted = $analyzer->deleteWebpage($index);
  print $deleted . " has been deleted from the added websites.\n";
}

sub webpageInfo {
  print "What is the index of the webpage you wish to view the full breakdown for?\n";
  $index = selectWebpage();
  $analyzer->getWebpage($index)->printAllInfo();
}

sub webpageTotals {
  print "What is the index of the webpage you wish to view the totals for?\n";
  $index = selectWebpage();
  $analyzer->getWebpage($index)->printTotalInfo();
}

sub webpageMostCommons {
  print "What is the index of the webpage you wish to view the most common elements for?\n";
  $index = selectWebpage();
  $analyzer->getWebpage($index)->printCommonInfo();
}

sub compareElements {
  print "Total number of Elements:\n";
  $last_index = @{$analyzer->{webpages}} - 1;
  for my $i(0..$last_index){
    $webpage = @{$analyzer->{webpages}}[$i];
    print $webpage->{url} . ": " . $webpage->numElements() . "\n";
  }
}

sub compareDiffElements {
  print "Total number of different Element Types:\n";
  $last_index = @{$analyzer->{webpages}} - 1;
  for my $i(0..$last_index){
    $webpage = @{$analyzer->{webpages}}[$i];
    print $webpage->{url} . ": " . $webpage->numElementTypes() . "\n";
  }
}

sub compareLinks {
  print "Total number of Links:\n";
  $last_index = @{$analyzer->{webpages}} - 1;
  for my $i(0..$last_index){
    $webpage = @{$analyzer->{webpages}}[$i];
    print $webpage->{url} . ": " . $webpage->numLinks() . "\n";
  }  
}

sub compareImages {
  print "Total number of Images:\n";
  $last_index = @{$analyzer->{webpages}} - 1;
  for my $i(0..$last_index){
    $webpage = @{$analyzer->{webpages}}[$i];
    print $webpage->{url} . ": " . $webpage->numImages() . "\n";
  }
}

sub compareScripts {
  print "Total number of Scripts:\n";
  $last_index = @{$analyzer->{webpages}} - 1;
  for my $i(0..$last_index){
    $webpage = @{$analyzer->{webpages}}[$i];
    print $webpage->{url} . ": " . $webpage->numScripts() . "\n";
  } 
}

sub compareClasses {
print "Total number of Classes:\n";
  $last_index = @{$analyzer->{webpages}} - 1;
  for my $i(0..$last_index){
    $webpage = @{$analyzer->{webpages}}[$i];
    print $webpage->{url} . ": " . $webpage->numClasses() . "\n";
  }  
}

sub compareIds {
  print "Total number of Ids:\n";
  $last_index = @{$analyzer->{webpages}} - 1;
  for my $i(0..$last_index){
    $webpage = @{$analyzer->{webpages}}[$i];
    print $webpage->{url} . ": " . $webpage->numIds() . "\n";
  }
}

sub compareLines {
  print "Total number of Lines:\n";
  $last_index = @{$analyzer->{webpages}} - 1;
  for my $i(0..$last_index){
    $webpage = @{$analyzer->{webpages}}[$i];
    print $webpage->{url} . ": " . $webpage->{num_lines} . "\n";
  }
}

1;