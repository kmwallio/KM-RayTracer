# KM-RayTracer

An example ray tracing program written in Perl for CSE 4280 (Graphical Algorithms).  This program demonstrates how ray tracing can be used to generate a "3-D Image" by tracing a ray and calculating intersections of mathematical objects in space.

## Requirements

* Perl
* Gtk2-Perl *\* If using the GUI*

## Installation

1. Install Perl and Gtk2-Perl if you haven't done so already.
2. Download KM-RayTracer.
3. Un-Zip or Un-Tar the archive.
4. In command line run.

	> perl raytracer.pl
	
	> perl cli.pl

5. Or.

	> chmod +x raytracer.pl

	> ./raytracer.pl
	
	> chmod +x cli.pl
	
	> ./cli.pl

## RayTracer.pl, CLI.pl, Huh?

RayTracer is the Graphical User Interface.  If you have Gtk2-Perl installed, you can run it and have a fabulous experience.  Otherwise, the ./cli.pl version will run on any system with Perl.  It'll also ask you for different input and output the image to the specified file.

## Other Notes

This program was tested on Debian 5 (Lenny).  Perl and Gtk2-Perl should be installed by default on Debian and/or Ubuntu.

### Installing GTK2-Perl (General)

You can find instructions for most systems on [GNOME Live!](http://live.gnome.org/GTK2-Perl/FrequentlyAskedQuestions#Downloading.2C_Building.2C_Installing_Gtk2-Perl "Installation Instructions").  Some notes are included below.

### Running on Linux

Search your distribution's package repositories for gtk2-perl to see if you can install it that way.  If not, you can try compiling it, or just use the CLI version.

### Running on Mac OS X

Not really sure about this one...  I know you can install Gtk2-Perl via Fink and run it using X11.  Rumor previously had it that you could install [Gtk+ version 2 for Mac](http://gtk-osx.sourceforge.net/ "Gtk-OSX") and run it as a native app.

### Running on Windows

The easiest way to run KM-RayTracer on Windows is to download [Camelbox](http://code.google.com/p/camelbox/ "Camelbox - Perl for Windows").  There is also a guide on [GNOME Live!](http://live.gnome.org/GTK2-Perl/FrequentlyAskedQuestions#Downloading.2C_Building.2C_Installing_Gtk2-Perl) for how to install if using ActiveState (the instructions should work for StrawBerry Perl as well).

### For everything else...

There's always [VirtalBox](http://virtualbox.org "VirtualBox") for virtualizing Ubuntu or Debian or some other operating system with Gtk2-Perl and running it under that.
