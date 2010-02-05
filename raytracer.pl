#!/usr/bin/perl
# Author: Miles Wallio, walliom@my.fit.edu
# Course: CSE 4280, Section E1, Spring 2010
# Project: Ray Tracing

# GUI For RayTracer

# Packages to Use
use strict;
use warnings;
use Gtk2 '-init';

# Create our main Window
$window = Gtk2::Window->new('toplevel');
$window->set_title("[k.m.] Ray Tracer");


# Load the Window
$window->show_all;
Gtk2->main;
0;
