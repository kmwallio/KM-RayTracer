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
	my ($self, $t, $b, $ray, $castor) = @_;
	
	# Items used in almost all calculations.
	my @intPoint = @{$ray->getPoint($t)};
	my @lightI = @{$castor->{_lightIntensity}};
	my @ambient = @{$castor->{_ambientLight}};
	my @eyeV = @{$ray->getT()};
	
	# Calculate normal vector
	my @norm = ($self->{_nA}, $self->{_nB}, $self->{_nC});
	
	#calculate light unit vector
	my @light = @{$castor->{_light}};
	@light = (($light[0] - $intPoint[0]), ($light[1] - $intPoint[1]), ($light[2] - $intPoint[2]));
	$divBy = sqrt(($light[0] ** 2) + ($light[1] ** 2) + ($light[2] ** 2));
	@light = (($light[0] / $divBy), ($light[1] / $divBy), ($light[2] / $divBy)); #normalized
	
	# Dotted normal dot light
	my $nl = ($light[0] * $norm[0]) + ($light[1] * $norm[1]) + ($light[2] * $norm[2]);
	$nl = ($nl > 0) ? $nl : 0;
	
	# Find the reflective light unit vector.
	my @reflect = (2 * $norm[0] * ($norm[0] * $light[0]) - $light[0], 2 * $norm[1] * ($norm[1] * $light[1]) - $light[1], 2 * $norm[2] * ($norm[2] * $light[2]) - $light[2]);
	
	# Dotted eye and reflect vectors.
	my $er = ($eyeV[0] * $reflect[0]) + ($eyeV[1] * $reflect[1]) + ($eyeV[2] * $reflect[2]);
	$er = ($er > 0) ? $er : 0;
	$er = $er ** $self->{_phong};
	
	# Lambertian equation for diffuse reflection with ambient lighting.
	my $red = $self->{_r} * ($ambient[0] + ($lightI[0] * $nl));
	my $green = $self->{_g} * ($ambient[1] + ($lightI[1] * $nl));
	my $blue = $self->{_b} * ($ambient[2] + ($lightI[2] * $nl));
	
	# Phong illumination
	#my $red = $red + ($light[0] * );
	#my $green = $green + ($light[1] * );
	#my $blue = $blue + ($light[2] * );
	
	return [$red, $green, $blue];
}
1;