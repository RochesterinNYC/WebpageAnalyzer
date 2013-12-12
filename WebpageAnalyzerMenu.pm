#!usr/bin/perl
package WebpageAnalyzerMenu;
use Exporter;
use WebpageAnalyzer;
our @ISA = eq(Exporter);
our @EXPORT = qw(operateMenu);
my $analyzer = new WebpageAnalyzer();

sub operateMenu {
  while(presentMenu()){}
}

sub presentMenu {
  $selection = -1;
  while (!validSelection($selection)){
    print "Press 1 to see all Webpages currently in the Analyzer.\n;"
    print "Press 2 to add a Webpage to the Analyzer.\n;"
    print "Press 3 to delete a Webpage from the Analyzer.\n;"
    print "Press 4 to see a Webpage's information.\n;"
    print "Press 5 to compare specific Webpages.\n;"
    print "Press 6 to compare all webpages.\n;"

    print "Press 7 to delete a Webpage from the Analyzer.\n;"
    print "Press 8 to delete a Webpage from the Analyzer.\n;"
    print "Press 9 to delete a Webpage from the Analyzer.\n;"
    print "Press 10 to delete a Webpage from the Analyzer.\n;"
    print "Press 11 to delete a Webpage from the Analyzer.\n;"  
  }
  processSelection($selection);
  return $selection;
}
  
sub processSelection {
  $selection = @_;
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
    compareWebpages();
  }
  if($selection == 6){
    compareAllWebpages();
  }
  if($selection == 7){
    
  }
  if($selection == 8){
    
  }
  if($selection == 9){
    
  }
  if($selection == 10){
    
  }
  if($selection == 11){
    
  }
  if($selection == 0){
    print "Thanks for using the Webpage Analyzer.\n;"
  }
}

sub validSelection {
  $selection = @_;
  $valid = 0;
  foreach(0..10){
    if($selection == $_){
      $valid = 1;
    }
  }
  return $valid;
}

sub seeAllWebpages {
  $webpages = $analyzer->getAllWebpages();
}
sub addWebpage {
  while(){
    print "  What is the url of the webpage you wish to add?";
  }
}
sub deleteWebpage {
  print "  What is the index of the webpage you wish to delete?"; 
}
sub webpageInfo {
  print "  What is the index of the webpage you wish to see info for?";  
}
sub compareWebpages {
  print "  What are the indices of the webpages you wish to compare?"; 
}
sub compareAllWebpages {
  
}

1;