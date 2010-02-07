#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Object for handling objects and data.
# Also used for generating the image.
package Castor;
use KMObj::Point;
use KMObj::Ray;
use KMObj::Plane;

# The constructor
sub new {
	my ($class, $width, $height, $eyeX, $eyeY, $eyeZ, $lightX, $lightY, $lightZ, $lightR, $lightG, $lightB, $aR, $aG, $aB, $pR, $pG, $pB, $bgR, $bgG, $bgB, $bounces) = @_; # Extract args
	$lightR = $lightR / 100; # We take in a percentage.
	$lightG = $lightG / 100;
	$lightB = $lightB / 100;
	$aR = $aR / 100;
	$aG = $aG / 100;
	$aB = $aB / 100;
	my $self = {
		_width => $width,
		_height => $height,
		_bounces => $bounces,
		_eye => [$eyeX, $eyeY, $eyeZ],
		_light => [$lightX, $lightY, $lightZ],
		_lightIntensity => [$lightR, $lightG, $lightB],
		_ambientLight	=>	[$aR, $aG, $aB],
		_phongLight	=>	[$pR, $pG, $pB],
		_background =>	[$bgR, $bgG, $bgB],
		_kmobjs => [],
		_image => []
	};
	bless $self, $class;
	return $self;
}

# Add an object
sub addObject {
	my ($self, $newObj) = @_;
	push(@{$self->{_kmobjs}}, $newObj);
	return $self;
}

# Change the width of the image
sub setWidth {
	my ($self, $newWidth) = @_; # Extract args
	$self->{_width} = $newWidth;
}

# Change the height of the image
sub setHeight {
	my ($self, $newHeight) = @_; # Extract args
	$self->{_height} = $newHeight;
}

# Change the location of the eye
sub setEye {
	my ($self, $eX, $eY, $eZ) = @_; # Extract args
	$self->{_eye} = [$eX, $eY, $eZ]; # Update the Eye
}

# Change the location of the light
sub setLight {
	my ($self, $lX, $lY, $lZ) = @_; # Extract args
	$self->{_light} = [$lX, $lY, $lZ]; # Update the Light
}

# Draw the image!
sub drawImage {
	my $self = shift;
	# Reset the image array if we have previously drawn the image.
	$self->{_image} = [];
	
	# Get a start and end cordinate.
	my $startX = int( ( ( -1 ) * ( $self->{_width} / 2 ) ) + 0.5 );
	my $endX = $startX * ( -1 );
	
	# Some correction for if the person had some strange width to throw us off.
	until( ( abs(  $startX ) + $endX ) eq $self->{_width} ){
		# If it's greater than the width
		if( ( abs( $startX ) + $endX ) > $self->{_width} ){
			# Try to keep the image centered around (0,0,0)
			if( abs( $startX ) > $endX ){
				$startX = $startX + 1; # Start should always be negative, so plus.
			} else {
				$endX = $endX - 1; # End heads in, so minus
			}
		} else { # It's less than the width of the image.
			# Try to keep the image centered around (0,0,0)
			if( abs( $startX ) < $endX ){
				$startX = $startX - 1; # Start should always be negative, so minus.
			} else {
				$endX = $endX + 1; # End heads in, so plus
			}
		}
	}
	
	# Get the start and end for the Y coordinates.
	my $startY = int( ( ( -1 ) * ( $self->{_height} / 2 ) ) + 0.5 );
	my $endY = $startY * ( -1 );
	
	# Some correction for if the person had some strange width to throw us off.
	until( ( abs(  $endY ) + $startY ) eq $self->{_height} ){
		# If it's greater than the width
		if( ( abs( $endY ) + $startY ) > $self->{_height} ){
			# Try to keep the image centered around (0,0,0)
			if( abs( $endY ) > $startY ){
				$endY = $endY + 1; # End should always be negative, so plus.
			} else {
				$startY = $startY - 1; # Start heads in, so minus
			}
		} else { # It's less than the width of the image.
			# Try to keep the image centered around (0,0,0)
			if( abs( $endY ) < $endX ){
				$endY = $endY - 1; # End should always be negative, so minus.
			} else {
				$startY = $startY + 1; # Start heads out, so plus
			}
		}
	}
	
	print "From: ($startX, $startY, 0) to ($endX, $endY, 0).\n";
	
	# Now to actually work on the image!
	my $i = 0; # LCV's
	my $j = 0;
	my $curRay = new Ray(0, 0, 0, 1, 1, 1);
	my $closestObj = new Point(0,0,0,0,0,0); # Place holder point for getting closest point.
	my $closestT = -1; # Closest point should be in positive area to show on image plane.
	my $newT = 0;
	
	for( $i = $startY ; $i > $endY ; $i-- ){ # Outer loop is Y to make writing to PPM Format Easier.
		for( $j = $startX ; $j < $endX ; $j++){
			$curRay = new Ray($self->{_eye}[0], $self->{_eye}[1], $self->{_eye}[2], $j, $i, 0);
			foreach $curObj (@{$self->{_kmobjs}}){
				$newT = $curObj->intersects($curRay); # Get the current distance
				if( $closestT < 0 || ($closestT > $newT && !($newT < 0)) ){ # See if it's the first item or a closer one.
					$closestT = $newT; # Get the current T
					$closestObj = $curObj; # Record the closest object.
				}
			}
			if( $closestT >= 0 ){
				# If we have an intersection behind the image plane, draw it.
				push(@{$self->{_image}}, $closestObj->getColor($closestT, $self->{_bounces}, $curRay, $self));
			}else{
				# If there's no intersection, use the default background color.
				push(@{$self->{_image}}, $self->{_background});
			}
			$closestT = -1;
		}
	}
}

sub saveImage {
	my ($self, $file) = @_;
	if(scalar(@{$self->{_image}}) == 0){
		print "***Error: Please run Castor->drawImage() before trying to save***\n";
		return;
	}
	
	eval {
		open (SAVEFILE, ">$file");
		print "Writing image to $file \n";
		# PPM Default Headers
		print SAVEFILE "P3\n";
		print SAVEFILE "# Generated by KM-RayTracer\n";
		print SAVEFILE $self->{_width} . " " . $self->{_height} . "\n";
		print SAVEFILE "255\n";
		my $count = 1;
		my $pixelCount = 0;
		my $pixelHeight = 1;
		# Loop through the pixels and write them out to the file.
		foreach my $pixel (@{$self->{_image}}) {
			$pixelCount++;
			foreach my $color (@{$pixel}){
				print SAVEFILE $color;
				if($count < ($self->{_width} * 3)){
					print SAVEFILE "\t";
					$count++;
				}else{
					$count = 1;
					$pixelHeight++;
					if($pixelHeight <= $self->{_height}){
						print SAVEFILE "\n";
					}
				}
			}
		}
		print $pixelCount . " pixels written to file.\n";
		close(SAVEFILE);
	};
	if($@) {
		print "***Error: Could not open $file for writing.***\n";
	}
}

sub getImage {
	my $self = shift;
	return @{$self->{_image}};
}
1;