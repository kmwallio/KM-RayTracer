#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Sphere for ray tracer.
package Sphere;
use KMObj::Point;
use Math::Trig;
our @ISA = qw(Point);

# Constructor for sphere
sub new {
	my ($class, $x, $y, $z, $radius, $r, $g, $b, $phong, $reflect, $refracC, $refrac) = @_;
	my $self = {
		_x	=>	$x,
		_y	=>	$y,
		_z	=>	$z,
		_radius	=>	$radius,
		_r	=>	$r,
		_g	=>	$g,
		_b	=>	$b,
		_phong	=>	$phong,
		_reflect	=>	$reflect,
		_refrac => $refrac,
		_refracC => $refracC,
		_type	=>	"sphere"
	};
	bless $self, $class;
	print "Created new " . $class . ".\n";
	return $self;
}

# Checks for equality
sub equals {
	my ($self, $other) = @_;
	my @coords = @{$other->getOrigin()};
	return (($coords[0] == $self->{_x}) && ($coords[1] == $self->{_y}) && ($coords[2] == $self->{_z}) && ($self->{_radius} == $other->{_radius}));
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
	} elsif ($t1 <= 0){
		$t = $t2;
	} else {
		$t = $t1;
	}
	return $t;
}

sub intersectsT {
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
	return ($t1 > $t2) ? $t1 : $t2;
}

# Return the sphere's color.
sub getColor {
	my ($self, $t, $b, $ray, $castor) = @_;
	
	# Items used in almost all calculations.
	my @intPoint = @{$ray->getPoint($t)};
	my @lightI = @{$castor->{_lightIntensity}};
	my @ambient = @{$castor->{_ambientLight}};
	my @eyeV = @{$ray->getT()};
	my @phongC = @{$castor->{_phongLight}};
	
	# Calculate normal vector
	my @norm = (($intPoint[0] - $self->{_x}), ($intPoint[1] - $self->{_y}), ($intPoint[2] - $self->{_z}));
	my $divBy = sqrt(($norm[0] ** 2) + ($norm[1] ** 2) + ($norm[2] ** 2)); #probably equals the radius...
	@norm = (($norm[0] / $divBy), ($norm[1] / $divBy), ($norm[2] / $divBy)); #normalized normal vector.
	
	#calculate light unit vector
	my @light = @{$castor->{_light}};
	@light = (($light[0] - $intPoint[0]), ($light[1] - $intPoint[1]), ($light[2] - $intPoint[2]));
	$divBy = sqrt(($light[0] ** 2) + ($light[1] ** 2) + ($light[2] ** 2));
	@light = (($light[0] / $divBy), ($light[1] / $divBy), ($light[2] / $divBy)); #normalized
	
	# Lambertian equation for diffuse reflection with ambient lighting.
	my $red = $self->{_r};
	my $green = $self->{_g};
	my $blue = $self->{_b};
	
	# If this is a transparent object...
	if($self->{_refrac} != 0){
		my ($tred, $tgreeb, $tblue) = @{$self->refract(\@eyeV, \@norm, \@intPoint, $castor->{_refraction}, $self->{_refracC}, $castor, $b)};
		#$red = ((1 - $self->{_refrac}) * $red) + ($tred * ($self->{_refrac}));
		#$green = ((1 - $self->{_refrac}) * $green) + ($tgreen * ($self->{_refrac}));
		#$blue = ((1 - $self->{_refrac}) * $blue) + ($tblue * ($self->{_refrac}));
		$red = ($tred * ($self->{_refrac}));
		$green = ($tgreen * ($self->{_refrac}));
		$blue = ($tblue * ($self->{_refrac}));
	}
	
	# If this is a reflective object
	if($self->{_reflect} != 0){
		my ($rred, $rgreen, $rblue) = @{$self->reflect(\@norm, \@eyeV, \@intPoint, $castor, $b)};
		$red = ((1 - $self->{_reflect}) * $red) + ($rred * ($self->{_reflect}));
		$green = ((1 - $self->{_reflect}) * $green) + ($rgreen * ($self->{_reflect}));
		$blue = ((1 - $self->{_reflect}) * $blue) + ($rblue * ($self->{_reflect}));
	}
	
	# If we're in the shadows
	my @inShadow = @{$self->lightIn(\@light, \@intPoint, $castor)};
	my ($lR, $lG, $lB) = $self->lambert(\@norm, \@light, \@lightI, \@ambient, \@inShadow);
	my ($pR, $pG, $pB) = $self->phong(\@norm, \@eyeV, \@light, \@lightI, \@phongC, \@inShadow);

	$red = $red * $lR + $pR;
	$green = $green * $lG + $pG;
	$blue = $blue * $lB + $pB;
	
	return [$red, $green, $blue];
}
sub refract {
	my $self = $_[0];
	my @eyeV = @{$_[1]};
	my @norm = @{$_[2]};
	my @intPoint = @{$_[3]};
	my $worldRefrac = $_[4];
	my $materRefrac = $_[5];
	my $castor = $_[6];
	my $bounces = $_[7] - 1;
	
	if($bounces == 0){
		return $castor->{_background};
	}
	# Calculate the translated ray
	my $dn = -1 * (($eyeV[0] * $norm[0]) + ($eyeV[1] * $norm[1]) + ($eyeV[2] * $norm[2]));
	my $nn = $worldRefrac / $materRefrac;
	my @tran = @eyeV;
	if( (1 - (($nn ** 2) * ($dn ** 2))) >= 0){
		my $p1 = ($nn * $dn) - sqrt((1 - (($nn ** 2) * ($dn ** 2))));
		@tran = ((($p1 * $norm[0]) - ($nn * $eyeV[0])), (($p1 * $norm[1]) - ($nn * $eyeV[1])), (($p1 * $norm[2]) - ($nn * $eyeV[2])));
	}
	
	my $tranRay = new Ray($intPoint[0], $intPoint[1], $intPoint[2], ($intPoint[0] + $tran[0]), ($intPoint[1] + $tran[1]), ($intPoint[2] + $tran[2]));
	
	my $selfT = $self->intersectsT($tranRay);
	
	if($selfT > 0){
		@intPoint = @{$tranRay->getPoint($selfT)};
		$dn = (($eyeV[0] * $norm[0]) + ($eyeV[1] * $norm[1]) + ($eyeV[2] * $norm[2]));
		$nn = $materRefrac / $worldRefrac;
		if( (1 - (($nn ** 2) * ($dn ** 2))) >= 0){
			my $p1 = ($nn * $dn) - sqrt((1 - (($nn ** 2) * ($dn ** 2))));
			@tran = ((($p1 * $norm[0]) - ($nn * $eyeV[0])), (($p1 * $norm[1]) - ($nn * $eyeV[1])), (($p1 * $norm[2]) - ($nn * $eyeV[2])));
			$tranRay = new Ray($intPoint[0], $intPoint[1], $intPoint[2], ($intPoint[0] + $tran[0]), ($intPoint[1] + $tran[1]), ($intPoint[2] + $tran[2]));
		}
	}
	# Find object of interest
	my $newT = 0;
	my $closestT = -1;
	my $closestObj = undef;
	foreach $curObj (@{$castor->{_kmobjs}}){
		if(!($self->equals($curObj))){
			$newT = $curObj->intersects($tranRay); # Get the current distance
			if( $closestT < 0 || ($closestT > $newT && !($newT <= 0)) ){ # See if it's the first item or a closer one
				$closestT = $newT; # Get the current T
				$closestObj = $curObj; # Record the closest object.
			}
		}
	}
	# Grab the color!
	if( $closestT > 0 ){
		# If we have an intersection behind the image plane, draw it.
		return $closestObj->getColor($closestT, $bounces, $tranRay, $castor);
	}else{
		# If there's no intersection, use the default background color.
		return $castor->{_background};
	}
	
}

sub refractOld {
	my $self = $_[0];
	my @eyeV = @{$_[1]};
	my @norm = @{$_[2]};
	my @intPoint = @{$_[3]};
	my $worldRefrac = $_[4];
	my $materRefrac = $_[5];
	my $castor = $_[6];
	my $bounces = $_[7] - 1;
	
	if($bounces == 0){
		return $castor->{_background};
	}

	# Calculate the translated ray
	my $dn = -1 * (($eyeV[0] * $norm[0]) + ($eyeV[1] * $norm[1]) + ($eyeV[2] * $norm[2]));
	my @tran = @eyeV;
	my $N = $worldRefrac / $materRefrac;
	if((1 - ($N ** 2) * (1 - ($dn ** 2))) > 0){
		my $tpd2 = $N * $dn - sqrt(1 - ($N ** 2) * (1 - ($dn ** 2)));
		my @tp2 = (($norm[0] * $tpd2), ($norm[1] * $tpd2), ($norm[2] * $tpd2));
		my @tp1 = (($eyeV[0] * $N), ($eyeV[1] * $N), ($eyeV[2] * $N));
		@tran = (($tp1[0] + $tp2[0]), ($tp1[1] + $tp2[1]), ($tp1[2] + $tp2[2]));
		if($tran[0] == 0 && $tran[1] == 0 && $tran [2] == 0){
			@tran = @eyeV;
		}
	}
	
	# Create the actual ray
	my $tranRay = new Ray($intPoint[0], $intPoint[1], $intPoint[2], ($intPoint[0] + $tran[0]), ($intPoint[1] + $tran[1]), ($intPoint[2] + $tran[2]));

	# Get if we intersect ourselves.
	my $selfT = $self->intersectsT($tranRay);
	
	# Calculate the ray we launch.
	if($selfT > 0){
		@intPoint = @{$tranRay->getPoint($selfT)};
		$dn = (($eyeV[0] * $norm[0]) + ($eyeV[1] * $norm[1]) + ($eyeV[2] * $norm[2]));
		$N = $materRefrac / $worldRefrac;
		if((1 - ($N ** 2) * (1 - ($dn ** 2))) > 0){
			$tpd2 = $N * $dn - sqrt(1 - ($N ** 2) * (1 - ($dn ** 2)));
			@tp2 = (($norm[0] * $tpd2), ($norm[1] * $tpd2), ($norm[2] * $tpd2));
			@tp1 = (($eyeV[0] * $N), ($eyeV[1] * $N), ($eyeV[2] * $N));
			@tran = (($tp1[0] + $tp2[0]), ($tp1[1] + $tp2[1]), ($tp1[2] + $tp2[2]));
			if($tran[0] == 0 && $tran[1] == 0 && $tran [2] == 0){
				@tran = @eyeV;
			}
		}
	}else{
		@tran = @eyeV;
	}
	
	$tranRay = new Ray($intPoint[0], $intPoint[1], $intPoint[2], ($intPoint[0] + $tran[0]), ($intPoint[1] + $tran[1]), ($intPoint[2] + $tran[2]));
	# Find object of interest
	my $newT = 0;
	my $closestT = -1;
	my $closestObj = undef;
	foreach $curObj (@{$castor->{_kmobjs}}){
		if(!($self->equals($curObj))){
			$newT = $curObj->intersects($tranRay); # Get the current distance
			if( $closestT < 0 || ($closestT > $newT && !($newT <= 0)) ){ # See if it's the first item or a closer one
				$closestT = $newT; # Get the current T
				$closestObj = $curObj; # Record the closest object.
			}
		}
	}
	# Grab the color!
	if( $closestT > 0 ){
		# If we have an intersection behind the image plane, draw it.
		return $closestObj->getColor($closestT, $bounces, $tranRay, $castor);
	}else{
		# If there's no intersection, use the default background color.
		return $castor->{_background};
	}
	
}
1;