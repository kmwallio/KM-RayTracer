#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# Object for handling objects and data.
# Also used for generating the image.
package Castor;
use KMObj::Point;

# The constructor
sub new {
	my ($class, $width, $height, $eyeX, $eyeY, $eyeZ, $lightX, $lightY, $lightX, $bgR, $bgG, $bgB) = @_; # Extract args
	my $self = {
		_width => $width,
		_height => $height,
		_eye => [$eyeX, $eyeY, $eyeZ],
		_light => [$lightX, $lightY, $lightZ],
		_background => [$bgR, $bgG, $bgB],
		_kmobjs => [],
		_image => []
	};
	bless $self, $class;
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
	
	# Now to actually work on the image!
	my $i = 0; # LCV's
	my $j = 0;
	
	for( $i = $startY ; $i <= $endY ; $i-- ){ # Outer loop is Y to make writing to PPM Format Easier.
		for( $j = $startX ; $j <= $endX ; $j++){
			
		}
	}
}
1;