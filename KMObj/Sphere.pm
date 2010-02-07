#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Sphere for ray tracer.
package Sphere;
use KMObj::Point;
our @ISA = qw(Point);

# Constructor for sphere
sub new {
	my ($class, $x, $y, $z, $radius, $r, $g, $b) = @_;
	my $self = {
		_x	=>	$x,
		_y	=>	$y,
		_z	=>	$z,
		_radius	=>	$radius,
		_r	=>	$r,
		_g	=>	$g,
		_b	=>	$b
	};
	bless $self, $class;
	print "Created new " . $class . ".\n";
	return $self;
}

# Determine if the sphere is hit by the ray.
sub intersects {
	my ($self, $ray) = @_;
	my ($tX, $tY, $tZ) = @{$ray->getT()}; # Get the parametric coefficients
	my ($x0, $y0, $z0) = @{$ray->getStart()}; # Start of ray
	my ($cX, $cY, $cZ) = @{$self->getOrigin}; # Center of Sphere
	my $radius = $self->{_radius}; # Radius
	
	# Cheap stuff to make calculations easier to type out
	my $t = -1;
	my $t1 = -1;
	my $t2 = -1;
	my $A = ($tX ** 2) + ($tY ** 2) + ($tZ ** 2);
	my $B = (2 * ($x0 - $cX) * $tX) + (2 * ($y0 - $cY) * $tY) + (2 * ($z0 - $cZ) * $tZ);
	my $C = ((($x0 - $cX) ** 2) + (($y0 - $cY) ** 2) + (($z0 - $cZ) ** 2)) - ($radius ** 2);
	eval {
		$t1 = ((-1 * $B) + sqrt( ($B ** 2) - (4 * $A * $C))) / (2 * $A);
	};
	eval {
		$t2 = ((-1 * $B) - sqrt( ($B ** 2) - (4 * $A * $C))) / (2 * $A);
	};
	if ($t1 >= 0 && $t2 >= 0){
		$t = ($t1 < $t2) ? $t1 : $t2;
	} elsif ($t1 < 0){
		$t = $t2;
	} else {
		$t = $t1;
	}
	#if($t > 0){
	#	print "A: $A, B: $B, C: $C  ";
	#	print "Intersection! $t1 -- $t2\n";
	#}else{
	#	print "No!\n";
	#}
	return $t;
}

# Return the sphere's color.
sub color {
	my $self = shift;
	return [$self->{_r}, $self->{_g}, $self->{_b}];
}
1;