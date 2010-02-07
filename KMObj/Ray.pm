#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Ray Object
package Ray;

sub new {
	my ($class, $xO, $yO, $zO, $xU, $yU, $zU) = @_; #extract args
	
	# Get the vector from origin to other point
	$xT = $xU - $xO;
	$yT = $yU - $yO;
	$zT = $zU - $zO;
	
	# Normalize the vector...
	my $divBy = sqrt( ( $xT ** 2 ) + ( $yT ** 2 ) + ( $zT ** 2 ) );
	
	$xT = $xT / $divBy;
	$yT = $yT / $divBy;
	$zT = $zT / $divBy;
	
	# Create object data
	my $self = {
		_x0 => $xO,
		_y0 => $yO,
		_z0 => $zO,
		_xT => $xT,
		_yT => $yT,
		_zT => $zT
	};
	
	bless $self, $class;
	return $self;
}

sub getStart {
	my $self = shift;
	return [ $self->{_x0} , $self->{_y0} , $self->{_z0} ];
}

sub getT {
	my $self = shift;
	return [ $self->{_xT} , $self->{_yT} , $self->{_zT} ];
}
1;