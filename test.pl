#!usr/bin/perl
use Webpage;

#Creates the webpage object
$page = new Webpage("http://www.columbia.edu/");
#Analyzes the webpage through parsing its source code and fills the object's data
$page->analyze();
#Prints the full breakdown of the webpage
$page->printAllInfo();
#Prints the most common elements of the webpage
$page->printCommonInfo();
#Prints the count totals for elements of the webpage
$page->printTotalInfo();