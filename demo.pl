#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

use warnings;
use strict;
use Castor;
use KMObj::Point;
use KMObj::Plane;
use KMObj::Sphere;
use KMObj::Cylinder;

print "Oh Yeah!\n";
#my $rayObj = new Castor(255, 255, 255, 0, 0, 0, 5);
#Create a new castor object...
my $rayObj = new Castor();

# Set the width and height of the image
$rayObj->setWidthHeight(500, 500);
# Set the location of the camera/eye
$rayObj->setEye(0, 0, -300); # The eye should be on the opposite side of the objects.
# Set the light location
$rayObj->setLight(450, 450, 130);
#$rayObj->setLight(250, 250, 250);
# Set the light intensity
$rayObj->setLightIntensity(60, 60, 60);
# Set the ambient light intensity (Note, the light intensity + ambient light intensity should be less than or equal to 100)
$rayObj->setAmbientLight(40, 40, 40);
# Color of phong lighting or glare
$rayObj->setPhong(255, 255, 255);
# Set the background color
$rayObj->setBackground(0, 0, 0);
# Set the number of bounces (limit recursion depth)
$rayObj->setBounces(13);


# Add a cylinder (we hope?)
#$rayObj->addObject(new Cylinder(-100, -20, -600, 1, 1, 0.1, 1, 0.1, 253, 237, 178, 1, 0, 0, 0));

# Add a sphere...
$rayObj->addObject(new Sphere(200, 100, 100, 50, 0, 0, 255, 64, 0.5, 0, 0));
# Add a sphere...
$rayObj->addObject(new Sphere(150, 180, 250, 80, 255, 255, 255, 4, 1, 0, 0));
# Add a sphere...
#$rayObj->addObject(new Sphere(-150, -100, 80, 60, 210, 82, 37, 256, 0, 1.33, 0));
$rayObj->addObject(new Sphere(150, -100, 280, 160, 0, 0, 0, 256, 0, 1.33, 1));
# Add a sphere...
$rayObj->addObject(new Sphere(-350, 350, 600, 200, 255, 255, 255, 256, .25, 0, 0));
# Add a plane... (back wall)
$rayObj->addObject(new Plane(0, 0, 1000, 0, 0, -1, 112, 186, 162, 16, 0));
# Add another plane... (left Wall)
$rayObj->addObject(new Plane(500, 0, 0, 1, 0, .25, 0, 255, 0, 10, 0));
# Add another plane... (right wall)
$rayObj->addObject(new Plane(-500, 0, 0, -1, 0, .25, 0, 255, 255, 12, 0));
# Add another plane... (ceiling)
$rayObj->addObject(new Plane(0, 500, 0, 0, -1, .35, 215, 215, 215, 10, 0));
# Add another plane... (floor)
$rayObj->addObject(new Plane(0, -500, 0, 0, 1, .35, 215, 215, 215, 5, 0));
# Add a plane... (back wall behind eye)
$rayObj->addObject(new Plane(0, 0, -1000, 0, 0, 1, 59, 92, 73, 16, 0));
print "...\n";
print "Drawing image\n";
$rayObj->drawImage();
print "...\n";
print "Writing image to file\n";
$rayObj->saveImage("./test.ppm");