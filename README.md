Webpage Analyzer
------
#####Final Project for COMS W3103: Programming Languages - Perl

####￼Problem Summary:
￼I want a quick and efficient way to view summary analytics about the source code of webpages. Say I want to know how image intensive a webpage is to determine how to approach loadtime issues. Counting images on the page or in the source code can get difficult/slow as the amount of content on the webpages increases. I want a program or module that can simply take in a webpage url and produce this kind of information.

Additionally, I want to simultaneously compare these kinds of source code element counts and etc. for multiple webpages. Say I want to compare my site’s homepage to a competitor’s homepage and compare the number of scripts, images, links, etc. that I’m using to the number of these that he or she is using on his or her homepage. I want to be able to simply interact with a program or interface and enter in my homepage’s url and the competitor’s url and access the comparison of these.

####Usage:
To read the documentation for the modules:

    perldoc Webpage 
    perldoc WebpageAnalyzer 
    perldoc WebpageAnalyzerMenu

To run the main program menu:

    perl runAnalyzer.pl

To run the customizable functionality test script:

    perl runAnalyzer.pl

####Implementation:

The package is comprised of a Webpage class, a WebpageAnalyzer class, and a WebpageAnalyzerMenu class. The Menu class interacts with a user and serves as the interface between the user and the Analyzer and Webpages. The Menu is designed in a manner that allows for the user to check what webpages are added, add and delete webpages, view the source code breakdown and summary for added webpages, and compare this information amongst different added websites.

![Webpage Analyzer Menu](http://s3.amazonaws.com/jamesrwen/app/public/uploads/webpageanalyzermenu_original.png?1390771582 "Webpage Analyzer Menu")

The Webpage class will represent a Webpage object whose attributes relate to properties of the source code for the url of the webpage. Within this module, all the parsing and analysis functionality will be present. Each property (i.e. links) of a Webpage object will be a hash where the key is the name of the element, script, link, class, id, or image and the values will be the number of times that it was used on the webpage. 

![Webpage Analyzer Info](http://s3.amazonaws.com/jamesrwen/app/public/uploads/webpageanalyzerinfo_original.png?1390771564 "Webpage Analyzer Info")

For example, the following would return the number of times that http://www.columbia.edu link was used on that webpage. 

    webpage->{links}{“http://www.columbia.edu”} 

￼￼<br/>
Parsing and processing/analysis entails attaining the webpage source code (HTML and etc.) through LWP and using regexes to comb through it line by line and element by element and fill the properties of a Webpage object with accurate counts and records of what elements are referenced. 

![Webpage Analyzer Compare](http://s3.amazonaws.com/jamesrwen/app/public/uploads/webpageanalyzercompare_original.png?1390771548 "Webpage Analyzer Compare")

Extensive care is taken in parsing the source code accurately and capturing all elements and odd formats like:
- No contents: \<div>
- Odd spacing: \< a href = ” soundcloud.com/stream ”>
- Punctuation: \<img src = “dkfjdkfj.png?=cool ”>

The WebpageAnalyzer class will encapsulate the calls for the operations involved in outputting and showing the analyzed properties of the webpages. This class takes the user option selections and interfaces with the webpages it holds and their functionalities to carry out the operations.