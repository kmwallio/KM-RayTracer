#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Cylinder for ray tracer.
package Cylinder;
use KMObj::Point;
use Math::Trig;
our @ISA = qw(Point);

# Constructor for cylinder
sub new {
	my ($class, $x, $y, $z, $radius, $height, $nA, $nB, $nC, $r, $g, $b, $phong, $reflect, $refracC, $refrac) = @_;
	my $divBy = sqrt(($nA ** 2) + ($nB ** 2) + ($nC ** 2));
	$nA = $nA / $divBy;
	$nB = $nB / $divBy;
	$nC = $nC / $divBy;
	my $self = {
		_x	=>	$x,
		_y	=>	$y,
		_z	=>	$z,
		_dX	=>	$nA,
		_dY	=>	$nB,
		_dZ	=>	$nC,
		_radius	=>	$radius,
		_height	=>	$height,
		_r	=>	$r,
		_g	=>	$g,
		_b	=>	$b,
		_phong	=>	$phong,
		_reflect	=>	$reflect,
		_refrac => $refrac,
		_refracC => $refracC,
		_type	=>	"cylinder"
	};
	bless $self, $class;
	print "Created new " . $class . ".\n";
	return $self;
}

# Calculate the intersection
sub intersects{
		my ($self, $ray) = @_;
		my ($xT, $yT, $zT) = @{$ray->getT()}; # Get the parametric coefficients
		my ($x0, $y0, $z0) = @{$ray->getStart()}; # Start of ray
		my ($xC, $yC, $zC) = @{$self->getOrigin()}; # Center of Sphere
		my ($dX, $dY, $dZ) = ($self->{_dX}, $self->{_dY}, $self->{_dZ});
		my $H = $self->{_height};
		my $R = $self->{_radius};
		
		my $ap = ($dX * $x0) + ($dY * $y0) + ($dZ + $z0);
		my $ad = ($dX * $xT) + ($dY * $yT) + ($dZ + $zT);
		my $ac = ($dX * $xC) + ($dY * $yC) + ($dZ + $zC);
		
		my @P = (($x0 - ($ap * $dX)), ($y0 - ($ap * $dY)), ($z0 - ($ap * $dZ)));
		my @D = (($xT - ($ad * $dX)), ($yT - ($ad * $dY)), ($zT - ($ad * $dZ)));
		my @C = (($xC - ($ac * $dX)), ($yC - ($ac * $dY)), ($zC - ($ac * $dZ)));
		
		my $A = ($D[0] * $D[0] + $D[1] * $D[1] + $D[2] * $D[2]);
		#my $B = (($P[0] * $D[0] + $P[1] * $D[1] + $P[2] * $D[2]) - ($C[0] * $D[0] + $C[1] * $D[1] + $C[2] * $D[2]));
		my $B = (2 * ($P[0] * $D[0] + $P[1] * $D[1] + $P[2] * $D[2]) - ($C[0] * $D[0] + $C[1] * $D[1] + $C[2] * $D[2]));
		my $C = ($P[0] * $P[0] + $P[1] * $P[1] + $P[2] * $P[2]) - (2 * ($P[0] * $C[0] + $P[1] * $C[1] + $P[2] * $C[2])) + ($C[0] * $C[0] + $C[1] * $C[1] + $C[2] * $C[2]) - ($R * $R);
		
		my $t1 = -1;
		my $t2 = -1;
		my $t = -1;
		eval {
			$t1 = (-($B) - sqrt(($B ** 2) - (4 * $A * $C))) / (2 * $A);
		};
		eval {
			$t2 = (-($B) + sqrt(($B ** 2) - (4 * $A * $C))) / (2 * $A);
		};
		if ($t1 >= 0 && $t2 >= 0){
			$t = ($t1 < $t2) ? $t1 : $t2;
		} elsif ($t1 <= 0){
			$t = $t2;
		} else {
			$t = $t1;
		}
		return $t;
}
1;