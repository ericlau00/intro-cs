# NetLogo_Calculator
IntroCS 2017-2018 Fall Semester Final Project

## WHAT IS IT?

This model recreates a graphing calculator in its abilities to graph functions and its abilities to report certain properties of the graph of a function. 

## INTRODUCTION

THIS IS A TI-84 GRAPHING CALCULATOR

## HOW IT WORKS

This model uses a graphing language we created that allows for functions to be graphed through a series of commands.

## HOW TO USE IT

To graph a function - write graph, followed by one of the below...

* polyConstant x= or y= color=
* polyLinear m= b= color=
* polyQuadratic a= b= c= color= 
* polyCubic a= b= c= d= color= 
* squareRoot a= h= k= color=
* cubicRoot a= h= k= color=
* circle xCenter= yCenter= radius= color= 

(with the variables supplemented with actual values)

EXAMPLE - graph polyConstant x= 5 color= cyan
EXAMPLE - graph polyLinear m= 1 b= 0 color= blue
EXAMPLE - graph polyQuadratic a= 1 b= 2 c= 4 color= orange

**[NOTE - WHEN GRAPHING MORE THAN ONE FUNCTION, MAKE SURE TO HAVE A LINE OF EMPTY SPACE UNDER IT]**

**[NOTE - EVERY TIME _singleInput_ IS CHANGED, CLICK _setup/updateInput_ BUTTON BEFORE YOU CLICK _graph_ AGAIN]**

To find a characteristic of a graph - write one of the following, followed by your function:

* xAxisIntercept
* yAxisIntercept
* findYwhenXis ...
* findXwhenYis ...
* intersect
* min/max

EXAMPLE - xAxisIntercept polyConstant y= 5 color= cyan
EXAMPLE - yAxisIntercept polyConstant x= 3 color= red
EXAMPLE - findYwhenXis 3 polyLinear m= 1 b= 0 color= blue
EXAMPLE - intersect PolyConstant y= 5 color= cyan, _and on a seperate line_ intersect polyConstant x= 5 color= orange


## EXTENDING/FIXING THE MODEL

There are some cases in which the intersect finding function results in a rounding error. Finding a new way to find the intersect values may be a solution.

Adding in more graphing functions, like...

* sin(x)
* cos(x)
* tan(x)
* log(x) 

## NETLOGO FEATURES

**INTERESTING/UNUSUAL COMMANDS**

read-from-string - processes the given string as a command, and reports the output

* show length read-from-string "[3 6 9]" >>> 3

tick-advance - advances the tick counter by the number given amount of ticks

* tick-advance 2 >>> tick counter increased by 2

substring - outputs a section of the given string, ranging from the first and last positions given

* show substring "example" 1 6 >>> "xampl"

sort-by - sorts items in a given-list based on the reporter, also indicated

* show sort-by > [3 1 2 4] >>> [4 3 2 1]

precision -  rounds a given number to a given decimal point

* show precision 1.525600 3 >>> 1.526

map - takes a list, runs a given reporter for every item on the list, and outputs a new list

* show map round [1.4 1.8 2.6] >>> [1 2 3]
* show map [ a -> a + a ] [1 2 3] >>> [2 4 6]

## RELATED MODELS

Conic Sections 1 (NetLogo Model Library) - related to the circle graphing function
Conic Sections 2 (NetLogo Model Library) - related to the quadratic graphing function

## CREDITS AND REFERENCES

This is a final project created by **ERIC LAU** and **AHMED SULTAN**, for Mr. Konstantinovich's Intro to Comp Sci 1 class.

## DOCUMENTATION LOG 

**1-04-2018**
	Created the setup procedure to make the grid.
	Created the polynomialConstant graphing procedures.
	Started working on polynomialLinear graphing procedures.
	Set up a basic interface for the functions we have so far. 

**1-05-2018**
	Restarted polynomialLinear graphing procedures.

**1-06-2018**
	Modified how the polynomialConstant graphing procedure works.
	Created new procedures to graph polynomialQuadratic, squareRoot, and circle. 
	Now allows for the resizing of the world. 
	Redesigned the interface.

**1-07-2018**
	Created a new procedure to graph polynomialCubic.

**1-08-2018** 
	Created a new procedure to graph cubicRoot. 
      	Created a partially functioning procedure that finds the zero of a function.
        Created a partially functioning procedure that finds the value of a function at a
	given y-coordinate.

**1-09-2018**
	Altered zero finding function to find the point when it crosses either axis.
	Altered value function to work on a given y coordinate or a given x coordinate.
	Altered the circle graphing function to listen to the center inputs. 

**1-10-2018**
	Continued working on the axisIntersect, value, and intersect functions.
	Made the program count the number of functions graphed as to distinguish which 
	turtles belong to which function.
	
**1-11-2018**
	Made the minimum possible patch size to 12 instead of 8. 
	Fixed the square root graphing procedure.
	Expanded the value and axis intersect procedures to cover all graph types.

**1-12-2018**
	Overrode the old form chooser with a cleaner single input widget. 
	Made new procedures to analyze the strings formed by the inputs.         
	Created the reporter and procedure to calculate the minimum or maximum of 	
	selective functions.

**1-15-2018**
	Altered the graph function.

**1-24-2018**
	Generalized graphing of roots so there is now an n parameter.
	Does not work for decimal n inputs. 

**11-10-2018**
	Added sine, cosine, and tangent functions.

**11-11-2018**
	Added secant, cosecant, and cotangent functions.
	Added exponential and logarithmic functions.

**More Features**
	Fix the action abilities for the trigonometric functions and the exponential/ logarithmic functions.