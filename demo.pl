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

my $rayObj = new Castor(500, 500, 0, 0, -300,  0, -250, 0, 0, 0, 0);
# Add a sphere...
$rayObj->addObject(new Sphere(0, 0, 200, 80, 0, 0, 255));
# Add a sphere...
$rayObj->addObject(new Sphere(150, 180, 250, 80, 255, 255, 255));
# Add a plane... (back wall)
$rayObj->addObject(new Plane(0, 0, 1000, 0, 0, -1, 29, 29, 24));
# Add another plane... (left Wall)
$rayObj->addObject(new Plane(500, 0, 0, 1, 0, .25, 141, 141, 141));
# Add another plane... (right wall)
$rayObj->addObject(new Plane(-500, 0, 0, -1, 0, .25, 141, 141, 141));
# Add another plane... (ceiling)
$rayObj->addObject(new Plane(0, 500, 0, 0, -1, .35, 215, 215, 215));
# Add another plane... (floor)
$rayObj->addObject(new Plane(0, -500, 0, 0, 1, .35, 215, 215, 215));
$rayObj->drawImage();
$rayObj->saveImage("/Users/twirp/Programming/Perl/RayTracing/test.ppm");