#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Generic Shape Package... Just an interface type package...
Package Object;

# Default Constructor
sub new {
	my $class = shift;
	my $self = {
		_x	=>	shift,
		_y	=>	shift,
		_z	=>	shift,
	};
	
	# Print output to consle
	print "Created new " . $class . ".\n";
	
	bless $self, $class;
	return $self;
}


# Determines if this object intersects another and returns t.
sub intersects {
	
}
1;