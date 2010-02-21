#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Generic Shape Package... Just an interface type package...
package Point;
use KMObj::Ray;
use Math::Trig;

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
	my @shadow = @{$_[5]};
	
	my $nl = ($light[0] * $norm[0]) + ($light[1] * $norm[1]) + ($light[2] * $norm[2]);
	$nl = ($nl > 0) ? $nl : 0;
	
	return (($ambient[0] + ($lightI[0] * $nl * $shadow[0])), ($ambient[1] + ($lightI[1] * $nl * $shadow[1])), ($ambient[2] + ($lightI[2] * $nl * $shadow[2])));
}

# Calculate Phong Reflection
sub phong {
	my $self = $_[0];
	my @norm = @{$_[1]};
	my @eyeV = @{$_[2]};
	my @light = @{$_[3]};
	my @lightI = @{$_[4]};
	my @phongC = @{$_[5]};
	my @shadow = @{$_[6]};
	
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
	return (($lightI[0] * $phongC[0] * $er * $shadow[0]), ($lightI[1] * $phongC[1] * $er * $shadow[1]), ($lightI[2] * $phongC[2] * $er * $shadow[2]));
}

# If the point in covered from the light (percentage of light seen).
sub lightIn {
	my $self = $_[0];
	my @light = @{$_[1]};
	my @intPoint = @{$_[2]};
	my $castor = $_[3];
	my @lightPoint = @{$castor->{_light}};
	
	# Loop through and block stuff!
	my $newT = 0;
	my $closestT = -1;
	my $closestObj = undef;
	my $shadowRay = new Ray($intPoint[0], $intPoint[1], $intPoint[2], ($intPoint[0] + $light[0]), ($intPoint[1] + $light[1]), ($intPoint[2] + $light[2]));
	
	foreach $curObj (@{$castor->{_kmobjs}}){
		if(!($self->equals($curObj))){
			$newT = $curObj->intersects($shadowRay); # Get the current distance
			if( $closestT < 0 || ($closestT > $newT && !($newT < 0)) ){ # See if it's the first item or a closer one
				$closestT = $newT; # Get the current T
				$closestObj = $curObj; # Record the closest object.
			}
		}
	}
	
	if($closestT > 0){
		my @blockPoint = @{$shadowRay->getPoint($closestT)};
		#print $self->distance(\@blockPoint, \@intPoint);
		#print " > ";
		#print $self->distance(\@lightPoint, \@intPoint);
		#print "\n";
		if($self->distance(\@blockPoint, \@intPoint) > $self->distance(\@lightPoint, \@intPoint)){
			return [1, 1, 1];
		}
	}else{
		return [1, 1, 1];
	}
	return [0, 0, 0];
}

sub distance {
	my $self = $_[0];
	my @start = @{$_[1]};
	my @end = @{$_[2]};
	return sqrt( (($start[0] - $end[0]) ** 2) + (($start[1] - $end[1]) ** 2) + (($start[2] - $end[2]) ** 2) );
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
	my @tran = @eyeV;
	my $N = $worldRefrac / $materRefrac;
	if((1 - ($N ** 2) * (1 - ($dn ** 2))) > 0){
		my $tpd2 = $N * $dn - sqrt(1 - ($N ** 2) * (1 - ($dn ** 2)));
		my @tp2 = (($norm[0] * $tpd2), ($norm[1] * $tpd2), ($norm[2] * $tpd2));
		my @tp1 = (($eyeV[0] * $N), ($eyeV[1] * $N), ($eyeV[2] * $N));
		@tran = (($tp1[0] + $tp2[0]), ($tp1[1] + $tp2[1]), ($tp1[2] + $tp2[2]));
	}
	
	# Create the actual ray
	my $tranRay = new Ray($intPoint[0], $intPoint[1], $intPoint[2], ($intPoint[0] + $tran[0]), ($intPoint[1] + $tran[1]), ($intPoint[2] + $tran[2]));
	
	# Find object of interest
	my $newT = 0;
	my $closestT = -1;
	my $closestObj = undef;
	foreach $curObj (@{$castor->{_kmobjs}}){
		#if(!($self->equals($curObj))){
			$newT = $curObj->intersects($tranRay); # Get the current distance
			if( $closestT < 0 || ($closestT > $newT && !($newT <= 0)) ){ # See if it's the first item or a closer one
				$closestT = $newT; # Get the current T
				$closestObj = $curObj; # Record the closest object.
			}
		#}
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