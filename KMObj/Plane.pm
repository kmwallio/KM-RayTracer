#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Sphere for ray tracer.
package Plane;
use KMObj::Point;
use Math::Trig;
our @ISA = qw(Point);

sub new {
	# A Plane is made up of a point (x0, y0, z0) and a normal vector.
	my ($class, $x0, $y0, $z0, $nA, $nB, $nC, $r, $g, $b, $phong, $reflect) = @_;
	
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
		_phong	=>	$phong,
		_reflect	=>	$reflect,
		_type	=>	"plane"
	};
	
	# Print output to consle
	print "Created new " . $class . ".\n";
	
	bless $self, $class;
	return $self;
}

# Determines if two planes are equal
sub equals {
	my ($self, $other) = @_;
	return (($self->{_dX} == $other->{_dX}) && ($self->{_dY} == $other->{_dY}) && ($self->{_dZ} == $other->{_dZ}) && ($self->{_nA} == $other->{_nA}) && ($self->{_nC} == $other->{_nC}) && ($self->{_nB} == $other->{_nB}));
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
	
	my $dn = -1 * (($eyeV[0] * $norm[0]) + ($eyeV[1] * $norm[1]) + ($eyeV[2] * $norm[2]));
	if(rad2deg(acos($dn)) > 90){
		@norm = ((-1 * $norm[0]), (-1 * $norm[1]), (-1 * $norm[2]));
	}
	
	my $red = $self->{_r};
	my $green = $self->{_g};
	my $blue = $self->{_b};
	
	if($self->{_reflect} != 0){
		my ($rred, $rgreen, $rblue) = @{$self->reflect(\@norm, \@eyeV, \@intPoint, $castor, $b)};
		$red = ((1 - $self->{_reflect}) * $red) + ($rred * ($self->{_reflect}));
		$green = ((1 - $self->{_reflect}) * $green) + ($rgreen * ($self->{_reflect}));
		$blue = ((1 - $self->{_reflect}) * $blue) + ($rblue * ($self->{_reflect}));
	}
	
	my @inShadow = @{$self->lightIn(\@light, \@intPoint, $castor)};
	my ($lR, $lG, $lB) = $self->lambert(\@norm, \@light, \@lightI, \@ambient, \@inShadow);
	my ($pR, $pG, $pB) = $self->phong(\@norm, \@eyeV, \@light, \@lightI, \@phongC, \@inShadow);
	
	$red = $red * $lR + $pR;
	$green = $green * $lG + $pG;
	$blue = $blue * $lB + $pB;
	
	return [$red, $green, $blue];
}
1;