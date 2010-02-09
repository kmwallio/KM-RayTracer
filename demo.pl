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

print "Oh Yeah!\n";
# Width, Height, eyeX, eyeY, eyeZ, lightX, lightY, lightZ, lightIntensity R, G, B, Ambient Light R, G, B, Phong Light R, G, B, Background color R, G, B, # of Bounces
# 0 <= Light Intentsity + Ambient Light <= 1
my $rayObj = new Castor(500, 500, 0, 0, -300,  150, 150, 150, 70, 70, 70, 30, 30, 30, 255, 255, 255, 0, 0, 0, 5);
# Add a sphere...
$rayObj->addObject(new Sphere(0, 0, 200, 80, 0, 0, 255, 1, 0));
# Add a sphere...
$rayObj->addObject(new Sphere(150, 180, 250, 80, 255, 255, 255, 4, 1));
# Add a sphere...
$rayObj->addObject(new Sphere(150, -180, 140, 120, 255, 255, 255, 4, 1));
# Add a sphere...
$rayObj->addObject(new Sphere(-150, -180, 500, 80, 255, 255, 255, 256, 0));
# Add a plane... (back wall)
$rayObj->addObject(new Plane(0, 0, 1000, 0, 0, -1, 255, 0, 0, 16));
# Add another plane... (left Wall)
$rayObj->addObject(new Plane(500, 0, 0, 1, 0, .25, 0, 255, 0, 10));
# Add another plane... (right wall)
$rayObj->addObject(new Plane(-500, 0, 0, -1, 0, .25, 0, 255, 255, 12));
# Add another plane... (ceiling)
$rayObj->addObject(new Plane(0, 500, 0, 0, -1, .35, 215, 215, 215, 10));
# Add another plane... (floor)
$rayObj->addObject(new Plane(0, -500, 0, 0, 1, .35, 215, 215, 215, 5));
# Add a plane... (back wall behind eye)
$rayObj->addObject(new Plane(0, 0, -1000, 0, 0, -1, 255, 29, 24, 16));
print "...\n";
print "Drawing image\n";
$rayObj->drawImage();
print "...\n";
print "Writing image to file\n";
$rayObj->saveImage("./test.ppm");