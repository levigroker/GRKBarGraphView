GRKBarGraphView
===========
[![Build Status](https://travis-ci.org/levigroker/GRKBarGraphView.svg)](https://travis-ci.org/levigroker/GRKBarGraphView)
[![Version](http://img.shields.io/cocoapods/v/GRKBarGraphView.svg)](http://cocoapods.org/?q=GRKBarGraphView)
[![Platform](http://img.shields.io/cocoapods/p/GRKBarGraphView.svg)]()
[![License](http://img.shields.io/cocoapods/l/GRKBarGraphView.svg)](https://github.com/levigroker/GRKBarGraphView/blob/master/LICENSE.txt)

A UIView subclass which renders a one-item bar graph with an animatable percentage
property and configurable orientation, colors, etc. CALayers are used for drawing
efficiency and implicit animation.

![Demo](ReadmeAssets/Demo.gif)  

### Installing

If you're using [CocoPods](http://cocopods.org) it's as simple as adding this to your `Podfile`:

	pod 'GRKBarGraphView'

otherwise, simply add the contents of the `GRKBarGraphView` subdirectory to your project.

### Documentation

`GRKBarGraphView` is to be used as you would any other UIView and will draw the bar graph
to fill its entire bounds. It looks best if relatively thin, as it has a one point border
by default.

The main API is documented in `GRKBarGraphView.h` but at its most basic:

	GRKBarGraphView *graphView = ...
	graphView.percent = 0.42f;

You can instantiate it as you would any other view, though it will use Autolayout
internally.

The color of the graph is determined by the `tintColor` of the view, but can be explicitly
configured, and it is capable of different colors for the bar and border.

Additional documentation is available in `GRKBarGraphView.h` and example usage
can be found in the GRKBarGraphViewTestApp source.

#### Disclaimer and Licence

* This work is licensed under the [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/).
  Please see the included LICENSE.txt for complete details.

#### About
A professional iOS engineer by day, my name is Levi Brown. Authoring a technical blog
[grokin.gs](http://grokin.gs), I am reachable via:

Twitter [@levigroker](https://twitter.com/levigroker)  
Email [levigroker@gmail.com](mailto:levigroker@gmail.com)  

Your constructive comments and feedback are always welcome.
