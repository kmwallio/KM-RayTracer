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
		_r	=>	shift,
		_g	=>	shift,
		_b	=>	shift,
		_a	=>	shift,
		_e	=>	shift,
		_reflection	=>	shift,
	};
	
	# Print output to consle
	print "Created new " . $class . ".\n";
	
	bless $self, $class;
	return $self;
}

sub intersects {
	
}
1;