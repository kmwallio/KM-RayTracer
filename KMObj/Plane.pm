#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Sphere for ray tracer.
package Plane;
use KMObj::Point;
our @ISA = qw(Point);

sub new {
	# A Plane is made up of a point (x0, y0, z0) and a normal vector.
	my ($class, $x0, $y0, $z0, $nA, $nB, $nC, $r, $g, $b, $phong) = @_;
	
	# Normalize A, B, and C (because users and I might be too lazy to)
	my $divBy = sqrt( ($nA ** 2) + ($nB ** 2) + ($nC ** 2) );
	$nA = $nA / $divBy;
	$nB = $nB / $divBy;
	$nC = $nC / $divBy;
	
	my $self = {
		_dX	=>	$x0,
		_dY	=>	$y0,
		_dZ	=>	$z0,
		_nA	=>	$nA,
		_nB	=>	$nB,
		_nC	=>	$nC,
		_r	=>	$r,
		_g	=>	$g,
		_b	=>	$b,
		_phong	=>	$phong
	};
	
	# Print output to consle
	print "Created new " . $class . ".\n";
	
	bless $self, $class;
	return $self;
}

# If the ray intersects this plane.
sub intersects {
	my $self = shift;
	my $ray = shift;
	# Just to make writing the calculations easier
	my $a = $self->{_nA};
	my $b = $self->{_nB};
	my $c = $self->{_nC};
	my $dX = $self->{_dX};
	my $dY = $self->{_dY};
	my $dZ = $self->{_dZ};
	my $d = sqrt( ($dX ** 2) + ($dY ** 2) + ($dZ ** 2));
	my ($x0,$y0,$z0) = @{$ray->getStart()};
	my ($xT,$yT,$zT) = @{$ray->getT()};
	# Do the calculation
	my $t = -1;
	eval {
		$t = -(($a * $x0) + ($b * $y0) + ($z0 * $c) + $d) / (($xT * $a) + ($yT * $b) + ($zT * $c)); # Find t
	};
	# return our answer
	return $t;
}

# Return the plane's color.
sub getColor {
	my $self = shift;
	return [$self->{_r}, $self->{_g}, $self->{_b}];
}
1;