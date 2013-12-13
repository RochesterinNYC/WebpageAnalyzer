
Included in this package is are Perl modules that allow a user to retrieve the source code of webpages and analyze their contents/elements. The modules allow for the counting of different elements from the webpages, determining the most common elements and element types, counting the number of lines in the source code, and comparing these attributes among different sites. A user interfacing menu is included.

To read the documentation for the classes, try:
perldoc Webpage
perldoc WebpageAnalyzer
perldoc WebpageAnalyzerMenu

To run the short test script that exhibits the functionality of a Webpage module object (hardcoded to http://www.columbia.edu at the moment), run:
perl test.pl

It will print out the full content breakdown of the webpage source code, the most common elements info, and the number of element type info.

To run the actual program and the user menu for the WebpageAnalyzer, run:
perl runAnalyzer.pl