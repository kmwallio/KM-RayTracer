#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Generic Shape Package... Just an interface type package...
package Point;
use KMObj::Ray;

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
		_type	=>	"point"
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

# Set's a new origin point.
sub setOrigin {
	my ($self, $nX, $nY, $nZ) = @_;
	$self->{_x} = $nX;
	$self->{_y} = $nY;
	$self->{_z} = $nZ;
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

# For preview window...
sub getBasic {
	my $self = shift;
	return [$self->{_r}, $self->{_g}, $self->{_b}];
}

# Calculate standard lambertian lighting
sub lambert {
	my $self = $_[0];
	my @norm = @{$_[1]};
	my @light = @{$_[2]};
	my @lightI = @{$_[3]};
	my @ambient = @{$_[4]};
	
	my $nl = ($light[0] * $norm[0]) + ($light[1] * $norm[1]) + ($light[2] * $norm[2]);
	$nl = ($nl > 0) ? $nl : 0;
	
	return (($ambient[0] + ($lightI[0] * $nl)), ($ambient[1] + ($lightI[1] * $nl)), ($ambient[2] + ($lightI[2] * $nl)));
}

# Calculate Phong Reflection
sub phong {
	my $self = $_[0];
	my @norm = @{$_[1]};
	my @eyeV = @{$_[2]};
	my @light = @{$_[3]};
	my @lightI = @{$_[4]};
	my @phongC = @{$_[5]};
	
	if($self->{_phong} <= 0){
		return (0, 0, 0);
	}
	
	# Calculate needed vectors
	my $c = (($light[0] * $norm[0]) + ($light[1] * $norm[1]) + ($light[2] * $norm[2]));
	my @reflect = (((2 * $norm[0] * $c) - $light[0]), ((2 * $norm[1] * $c) - $light[1]), ((2 * $norm[2] * $c) - $light[2]));
	$divBy = sqrt(($reflect[0] ** 2) + ($reflect[1] ** 2) + ($reflect[2] ** 2));
	@reflect = (($reflect[0] / $divBy), ($reflect[1] / $divBy), ($reflect[2] / $divBy));
	my $er = (-$eyeV[0] * $reflect[0]) + (-$eyeV[1] * $reflect[1]) + (-$eyeV[2] * $reflect[2]);
	$er = ($er > 0) ? $er : 0;
	$er = $er ** $self->{_phong};
	
	# Return new color
	return (($lightI[0] * $phongC[0] * $er), ($lightI[1] * $phongC[1] * $er), ($lightI[2] * $phongC[2] * $er));
}

# Returns the color from a reflection...
sub reflect {
	my $self = $_[0];
	my @norm = @{$_[1]};
	my @eyeV = @{$_[2]};
	my @intPoint = @{$_[3]};
	my $castor = $_[4];
	my $bounces = $_[5] - 1;
	
	if($bounces < 0){
		return $castor->{_background};
	}
	
	# Calculate a reflective vector...
	my $c = (($eyeV[0] * $norm[0]) + ($eyeV[1] * $norm[1]) + ($eyeV[2] * $norm[2]));
	my @reflect = (((-2 * $norm[0] * $c) + $eyeV[0]), ((-2 * $norm[1] * $c) + $eyeV[1]), ((-2 * $norm[2] * $c) + $eyeV[2]));
	#print "Eye: @eyeV , Reflect: @reflect \n";
	
	# Create a new ray of that vector
	my $reflectRay = new Ray($intPoint[0], $intPoint[1], $intPoint[2], ($intPoint[0] + $reflect[0]), ($intPoint[1] + $reflect[1]), ($intPoint[2] + $reflect[2]));
	
	# Loop through and reflect stuff!
	my $newT = 0;
	my $closestT = -1;
	my $closestObj = undef;
	
	foreach $curObj (@{$castor->{_kmobjs}}){
		if(!($self->equals($curObj))){
			$newT = $curObj->intersects($reflectRay); # Get the current distance
			if( $closestT < 0 || ($closestT > $newT && !($newT < 0)) ){ # See if it's the first item or a closer one
				$closestT = $newT; # Get the current T
				$closestObj = $curObj; # Record the closest object.
			}
		}
	}
	if( $closestT >= 0 ){
		# If we have an intersection behind the image plane, draw it.
		return $closestObj->getColor($closestT, $bounces, $reflectRay, $castor);
	}else{
		# If there's no intersection, use the default background color.
		return $castor->{_background};
	}
}

# Returns type of item
sub getType {
	my $self = shift;
	return $self->{_type};
}

# Checks for equality
sub equals {
	my ($self, $other) = @_;
	my @coords = @{$other->getOrigin()};
	return ($coords[0] == $self->{_x} && $coords[1] == $self->{_y} && $coords[2] == $self->{_z});
}

# Returns the norm
sub getNorm {
	return (0, 0, 0);
}
1;