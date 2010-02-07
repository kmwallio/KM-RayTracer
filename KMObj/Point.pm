#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Generic Shape Package... Just an interface type package...
package Point;

# Default Constructor
sub new {
	my $class = shift;
	my $self = {
		_x	=>	shift,
		_y	=>	shift,
		_z	=>	shift,
		_r	=>	shift,
		_g	=>	shift,
		_b	=>	shift
	};
	
	# Print output to consle
	print "Created new " . $class . ".\n";
	
	bless $self, $class;
	return $self;
}


# Determines if this object intersects another and returns t.
sub intersects {
	my ($self, $ray) = @_;
	my ($rayX, $rayY, $rayZ) = @{$ray->getStart()};
	my ($rayXT, $rayYT, $rayZT) = @{$ray->getT()};
	
	# Cases where there's no change in specific ones...
	if( $rayXT == 0 && $rayX != $self->{_x} ){
		return -1;
	} elsif( $rayYT == 0 && $rayY != $self->{_y} ){
		return -1
	} elsif( $rayZT == 0 && $rayZ != $self->{_z} ){
		return -1;
	}
	
	# Return variable
	$t = -1;
	
	if( $rayXT == 0 && $rayYT == 0 ){ # Only have to find T, ray heading towards point
		$t = ($self->{_z} - $rayZ) / $rayZT;
	}elsif( $rayXT == 0 ){ # Check Z and Y
		$ty = ($self->{_y} - $rayY) / $rayYT;
		$tz = ($self->{_z} - $rayZ) / $rayZT;
		if($ty == $tz){
			$t = $ty;
		}
	}elsif( $rayYT == 0 ){ # Check X and Z
		$tx = ($self->{_x} - $rayX) / $rayXT;
		$tz = ($self->{_z} - $rayZ) / $rayZT;
		if($tx == $tz){
			$t = $tx;
		}
	}else{ # Eye should always be being 0, so no need to check for z == 0
		$tx = ($self->{_x} - $rayX) / $rayXT;
		$ty = ($self->{_y} - $rayY) / $rayYT;
		$tz = ($self->{_z} - $rayZ) / $rayZT;
		if($tx == $tz && $tz == $ty){
			$t = $tz;
		}
	}
	
	return $t;
}

# Returns orgin point
sub getOrigin {
	my $self = shift;
	return [$self->{_x}, $self->{_y}, $self->{_z}];
}

# Returns the color [R, G, B] of this point.
sub getColor {
	my $self = shift;
	return [$self->{_r}, $self->{_g}, $self->{_b}];
}
1;