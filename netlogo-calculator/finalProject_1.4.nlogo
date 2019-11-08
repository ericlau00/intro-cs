;Sultan, Ahmed
;Lau, Eric
;MKS21 Period4
;2018-01-03
;NetLogo Final Project- Ripoff TI-84

globals [xList intersectList interceptList valueList minMaxString
         firstFunction secondFunction thirdFunction fourthFunction fifthFunction]

turtles-own [myFunction]

;1-04-2018 Ahmed created this setup procedure to make a grid
;1-05-2018 Eric added the starting xlist at -8.
;1-06-2018 Eric generalized the starting xlist to be beginningX
;1-06-2018 Eric changed the setup to no longer clear all.
;1-09-2018 Eric added a way to count the number of current functions.
;1-10-2018 Eric added functionNum/functionNumber to distinguish between the functions based on numbers
;1-12-2018 Ahmed added the setting of the five possible function inputs to N/A.
;1-12-2018 Ahmed incorporated the updating of functions into the setup so there only needs to be one button to update functions and setup.
;1-12-2018 Ahmed split the drawing of the grid into its own procedure.
;1-13-2018 Eric deleted the setting of the functionNumber and now distinguishes functions via a turtles-own variable set the string of the function itself.
;1-14-2018 Eric added the setting of minMaxString to blank.
to setup
  set xList []

  set firstFunction "N/A"
  set secondFunction "N/A"
  set thirdFunction "N/A"
  set fourthFunction "N/A"
  set fifthFunction "N/A"

  set xList lput beginningX xList
  set intersectList []
  set interceptList []
  set valueList []
  set minMaxString ""

  drawGrid
  updateFunctions

  reset-ticks
end

;1-06-2018 Eric made the beginning of the x list be determined by the world size.
to-report beginningX
  report min-pxcor
end

;1-12-2018 Ahmed created a modularized drawing procedure for better organization.
to drawGrid
  ask patches [
    set plabel-color white
    sprout 1 [
      ifelse xcor = 0
         [ set color red ]
         [ set color white ]
      set heading 0
      pd
      fd 1
      die ]
    sprout 1 [
      ifelse ycor = 0
         [ set color red ]
         [ set color white ]
      set heading 90
      pd
      fd 1
      die ]]
  ask patches with [ pxcor = 0 ]
  [ set plabel pycor ]
  ask patches with [ pycor = 0 ]
  [ set plabel pxcor ]
end

;1-12-2018 Eric added a procedure to look to see how many functions are typed in and sets each of those functions to a different string.
;1-14-2018 Eric added a precaution when one tries to use a calculator ability before graphing the functions first. This causes errors
;     with whether or not a turtle's myFunction variable is a member? of the function its supposed to be in.
to updateFunctions
  let i 1
  let function 0
  let sI singleInput

  if not member? "\n" singleInput
  [set firstFunction singleInput
   set singleInput " "
   show firstFunction]

  while [member? "\n" singleInput and i <= 5]
  [set function substring singleInput 0 (position "\n" singleInput)
   set singleInput replace-item (position "\n" singleInput) singleInput " "
   set singleInput remove function singleInput
   set singleInput remove-item 0 singleInput

  if i = 1
  [set firstFunction function
    show firstFunction]
  if i = 2
  [set secondFunction function
    show secondFunction]
  if i = 3
  [set thirdFunction function
    show thirdFunction]
  if i = 4
  [set fourthFunction function
    show fourthFunction]
  if i = 5
  [set fifthFunction function
    show fifthFunction]
   set i i + 1]

   set singleInput sI

  if (member? "Intercept" singleInput or member? "find" singleInput or member? "intersect" singleInput or member? "min/max" singleInput) and count turtles = 0
  [show "It is not recommended to immediately use a calculator ability before graphing the functions first"]
end

;1-06-2018 Eric created a clear button to reset the graphs and list but not delete the grid.
;1-10-2018 Eric made the clear button set the number of functions to 0, the intersect list to 0, and the ticks to 0.
;1-12-2018 Ahmed edited this procedure to reset the function strings aftering clearing.
;1-13-2018 Ahmed deleted the setting of the functionNumber. The line of the new single input is the distinguishing factor between graphs.
;1-14-2018 Ahmed set the value and intercept lists to empty.
;1-14-2018 Eric added the setting of minMaxString to blank.
to clear
  set xList []
  set xList lput beginningX xList
  set intersectList []
  set valueList []
  set interceptList []
  set minMaxString ""

  set firstFunction "N/A"
  set secondFunction "N/A"
  set thirdFunction "N/A"
  set fourthFunction "N/A"
  set fifthFunction "N/A"
  ct
  reset-ticks
end

;1-06-2018 Eric created a function to resize the world size and patch size.
to resizeGraph
  resize-world (-1 * resizeWorld) resizeWorld (-1 * resizeWorld) resizeWorld
  set-patch-size patchSize
  ca
  setup
end

;1-04-2018 Ahmed created the graph procedure to graph the chosen function type.
;1-05-2018 Eric added tick-advance to speed up graphing.
;1-12-2018 Ahmed reformatted this procedure to run the modularized graphing procedures based on whether or not it has been filled out.
;1-13-2018 Eric made the graphExtended take a parameter of the string of the function.
;1-15-2018 Ahmed edited tick-advance to go from every 0.001 ticks to 0.03 ticks for smoother graphing (visually).
to graph
  if firstFunction != "N/A" [
    graphExtended firstFunction ]
  if secondFunction != "N/A" [
    graphExtended secondFunction ]
  if thirdFunction != "N/A" [
    graphExtended thirdFunction ]
  if fourthFunction != "N/A" [
    graphExtended fourthFunction ]
  if fifthFunction != "N/A" [
    graphExtended fifthFunction ]
  tick-advance 0.03
end

;1-12-2018 Ahmed created this reporter to report whether the constant function is going to be for x or y.
to-report constant? [function]
  ifelse member? "x=" function
  [report "x="]
  [report "y="]
end

;1-12-2018 Eric created a procedure to see if a type of function inputted in the first line and reads from the string to get the parameters.
;1-13-2018 Ahmed incorporated a new color parameter so that there is now each graph can have its color chosen.
;1-13-2018 Ahmed generalized this graphing procedure by using a parameter instead of having 5 separate procedures doing the same thing for each line.
;1-13-2018 Eric added another parameter for the turtles created to be able to set their myFunction variable to the string of the function it is in.
;11-11-2018 Eric added the six basic trigonometric functions to this procedure.
to graphExtended [function#]
  if member? "polyConstant" function#
  [polynomialConstant constant? function#
                      read-from-string (substring function# (position "=" function# + 2) (position "color" function# - 1))
                      read-from-string (substring function# (position "color" function# + 6) (length function#))
                      function#]

  if member? "polyLinear" function#
  [polynomialLinear read-from-string (substring function# (position "m=" function# + 3) (position "b" function# - 1))
                    read-from-string (substring function# (position "b=" function# + 3) (position "color" function# - 1))
                    read-from-string (substring function# (position "color" function# + 6) (length function#))
                    function#]

  if member? "polyQuadratic" function#
  [polynomialQuadratic read-from-string (substring function# (position "a=" function# + 3) (position "b" function# - 1))
                       read-from-string (substring function# (position "b=" function# + 3) (position "c=" function# - 1))
                       read-from-string (substring function# (position "c=" function# + 3) (position "color" function# - 1))
                       read-from-string (substring function# (position "color" function# + 6) (length function#))
                       function#]

  if member? "polyCubic" function#
  [polynomialCubic read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
                   read-from-string (substring function# (position "b=" function# + 3) (position "c=" function# - 1))
                   read-from-string (substring function# (position "c=" function# + 3) (position "d=" function# - 1))
                   read-from-string (substring function# (position "d=" function# + 3) (position "color" function# - 1))
                   read-from-string (substring function# (position "color" function# + 6) (length function#))
                   function#]

  if member? "nthRoot" function#
  [nthRoot read-from-string (substring function# (position "n=" function# + 3) (position "a=" function# - 1))
           read-from-string (substring function# (position "a=" function# + 3) (position "h=" function# - 1))
           read-from-string (substring function# (position "h=" function# + 3) (position "k=" function# - 1))
           read-from-string (substring function# (position "k=" function# + 3) (position "color" function# - 1))
           read-from-string (substring function# (position "color" function# + 6) (length function#))
           function#]

  if member? "circle" function#
  [circle read-from-string (substring function# (position "xCenter=" function# + 8) (position "yCenter=" function# - 1))
          read-from-string (substring function# (position "yCenter=" function# + 8) (position "radius=" function# - 1))
          read-from-string (substring function# (position "radius=" function# + 7) (position "color" function# - 1))
          read-from-string (substring function# (position "color" function# + 6) (length function#))
          function#]

  if member? "sin" function#
  [sine read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
        read-from-string (substring function# (position "b=" function# + 3) (position "h=" function# - 1))
        read-from-string (substring function# (position "h=" function# + 3) (position "k=" function# - 1))
        read-from-string (substring function# (position "k=" function# + 3) (position "color" function# - 1))
        read-from-string (substring function# (position "color" function# + 6) (length function#))
        function#]

  if member? "cos" function#
  [cosine read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
          read-from-string (substring function# (position "b=" function# + 3) (position "h=" function# - 1))
          read-from-string (substring function# (position "h=" function# + 3) (position "k=" function# - 1))
          read-from-string (substring function# (position "k=" function# + 3) (position "color" function# - 1))
          read-from-string (substring function# (position "color" function# + 6) (length function#))
          function#]

  if member? "tan" function#
  [tangent read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
           read-from-string (substring function# (position "b=" function# + 3) (position "h=" function# - 1))
           read-from-string (substring function# (position "h=" function# + 3) (position "k=" function# - 1))
           read-from-string (substring function# (position "k=" function# + 3) (position "color" function# - 1))
           read-from-string (substring function# (position "color" function# + 6) (length function#))
           function#]

  if member? "csc" function#
  [cosecant read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
           read-from-string (substring function# (position "b=" function# + 3) (position "h=" function# - 1))
           read-from-string (substring function# (position "h=" function# + 3) (position "k=" function# - 1))
           read-from-string (substring function# (position "k=" function# + 3) (position "color" function# - 1))
           read-from-string (substring function# (position "color" function# + 6) (length function#))
           function#]

  if member? "sec" function#
  [secant read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
          read-from-string (substring function# (position "b=" function# + 3) (position "h=" function# - 1))
          read-from-string (substring function# (position "h=" function# + 3) (position "k=" function# - 1))
          read-from-string (substring function# (position "k=" function# + 3) (position "color" function# - 1))
          read-from-string (substring function# (position "color" function# + 6) (length function#))
          function#]

  if member? "cot" function#
  [cotangent read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
             read-from-string (substring function# (position "b=" function# + 3) (position "h=" function# - 1))
             read-from-string (substring function# (position "h=" function# + 3) (position "k=" function# - 1))
             read-from-string (substring function# (position "k=" function# + 3) (position "color" function# - 1))
             read-from-string (substring function# (position "color" function# + 6) (length function#))
             function#]

  if member? "expo" function#
  [exponential read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
               read-from-string (substring function# (position "b=" function# + 3) (position "h=" function# - 1))
               read-from-string (substring function# (position "h=" function# + 3) (position "c=" function# - 1))
               read-from-string (substring function# (position "c=" function# + 3) (position "color" function# - 1))
               read-from-string (substring function# (position "color" function# + 6) (length function#))
               function#]

  if member? "log" function#
  [logarithm read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1))
             read-from-string (substring function# (position "b=" function# + 3) (position "h=" function# - 1))
             read-from-string (substring function# (position "h=" function# + 3) (position "c=" function# - 1))
             read-from-string (substring function# (position "c=" function# + 3) (position "color" function# - 1))
             read-from-string (substring function# (position "color" function# + 6) (length function#))
             function#]
end

;1-05-2018 Eric created a procedure that makes a list of x values for mapping.
;1-06-2018 Eric modified this procedure to take smaller intervals between each x value so there are not gaps in the graphs.
to createXList
  if not empty? xList
  [if last xList < max-pxcor
    [set xList lput (precision (last xList + 0.005) 5) xList ]]
end

;1-06-2018 Eric created another procedure to make a list of x values but at a larger interval.
to createXListSpecial
  if not empty? xList
  [if last xList < max-pxcor
    [set xList lput (precision (last xList + 0.025) 5) xList]]
end

;1-04-2018 Ahmed created this procedure to graph constant "functions".
;1-05-2018 In consideration for reformatting to mimic the linear procedure.
;1-06-2018 Ahmed created a new polynomialConstant procedure to replace the archived one - graphs constants.
;1-10-2018 Eric added functionNum/functionNumber to distinguish between the functions based on numbers.
;1-12-2018 Ahmed edited this procedure to take two parameters of a constant and a number.
;1-13-2018 Ahmed edited this procedure to use the color given in the string input.
;1-13-2018 Ahmed deleted the setting of the functionNumber. The line of the new single input is the distinguishing factor between graphs.
;1-13-2018 Eric added a new parameter to allow the turtles created to set a variable to the string of the function it is.
to polynomialConstant [constant constantValue colorValue turtleFunction]
  createXListSpecial
  let i 0
  if constant = "x=" [
    ask patch 0 0 [
      if i < length xList
      and (precision constantValue 5) <= max-pxcor
      and (precision (first map [ y -> y ] xList) 5) <= max-pycor
      and (precision constantValue 5) >= min-pxcor
      and (precision (first map [ y -> y ] xList) 5) >= min-pycor [
        sprout 1 [
          set size 0.25
          set shape "circle"
          set color colorValue
          set myFunction turtleFunction
          set xcor (precision constantValue 5)
          set ycor (precision (first map [ y -> y ] xList) 5)]]]]

  if constant = "y=" [
    ask patch 0 0 [
      if i < length xList
      and (precision (first xList) 5) <= max-pxcor
      and (precision constantValue 5) <= max-pycor
      and (precision (first xList)  5) >= min-pxcor
      and (precision constantValue 5) >= min-pycor [
        sprout 1 [
          set size 0.25
          set shape "circle"
          set color colorValue
          set myFunction turtleFunction
          set xcor (precision (first xList) 5)
          set ycor (precision constantValue 5)]]]]

  if not empty? xList [
    set xList but-first xList ]
end

;1-05-2018 Eric created procedure to replace the archived one (done by Ahmed) - graphs linear functions
;1-10-2018 Eric added functionNum/functionNumber to distinguish between the functions based on numbers.
;1-12-2018 Ahmed edited this procedure to take a slope and y intercept parameters.
;1-13-2018 Ahmed edited this procedure to use the color given in the string input.
;1-13-2018 Ahmed deleted the setting of the functionNumber. The line of the new single input is the distinguishing factor between graphs.
;1-13-2018 Eric added a new parameter to allow the turtles created to set a variable to the string of the function it is.
to polynomialLinear [slope yIntercept colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first map [y -> (y * slope) + yIntercept] xList) 5) <= max-pycor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> (y * slope) + yIntercept] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> (y * slope) + yIntercept] xList) 5)]]]

  if not empty? xList
  [set xList but-first xList]
end

;1-06-2018 Eric created this procedure to graph quadratic functions
;1-10-2018 Eric added functionNum/functionNumber to distinguish between the functions based on numbers.
;1-12-2018 Ahmed edited this procedure to take three parameters of the general polynomial quadratic function.
;1-13-2018 Ahmed edited this procedure to use the color given in the string input.
;1-13-2018 Ahmed deleted the setting of the functionNumber. The line of the new single input is the distinguishing factor between graphs.
;1-13-2018 Eric added a new parameter to allow the turtles created to set a variable to the string of the function it is.
to polynomialQuadratic [a b c colorValue turtleFunction]
  createXList
  let i 0

  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> (a * (y ^ 2)) + (b * y) + c] xList) 5) <= max-pycor
  and (precision (first map [y -> (a * (y ^ 2)) + (b * y) + c] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> (a * (y ^ 2)) + (b * y) + c] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]

end

;1-07-2018 Eric created this procedure to create cubic polynomial functions.
;1-10-2018 Eric added functionNum/functionNumber to distinguish between the functions based on numbers.
;1-12-2018 Ahmed edited this procedure to take four parameters in the general form of a polynomial cubic function.
;1-13-2018 Ahmed edited this procedure to use the color given in the string input.
;1-13-2018 Ahmed deleted the setting of the functionNumber. The line of the new single input is the distinguishing factor between graphs.
;1-13-2018 Eric added a new parameter to allow the turtles created to set a variable to the string of the function it is.
to polynomialCubic [a b c d colorValue turtleFunction]
  createXList
  let i 0

  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> (a * (y ^ 3)) + (b * (y ^ 2)) + (c * y) + d] xList) 5) <= max-pycor
  and (precision (first map [y -> (a * (y ^ 3)) + (b * (y ^ 2)) + (c * y) + d] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> (a * (y ^ 3)) + (b * (y ^ 2)) + (c * y) + d] xList) 5) ]]]

  if not empty? xList
  [set xList but-first xList]
end

;1-08-2018 Eric created this procedure to create cube root functions.
;1-10-2018 Eric added functionNum/functionNumber to distinguish between the functions based on numbers.
;1-12-2018 Ahmed edited this procedure to take three parameters (a for the stretch, h for the x translation, k for te y translation)
;1-13-2018 Ahmed edited this procedure to use the color given in the string input.
;1-13-2018 Ahmed deleted the setting of the functionNumber. The line of the new single input is the distinguishing factor between graphs.
;1-13-2018 Eric added a new parameter to allow the turtles created to set a variable to the string of the function it is.
;1-24-2018 Eric generalized the cubicRoot procedure to instead let n be a parameter to make an nthRoot procedure.
;1-24-2018 Eric made this procedure an umbrella procedure that splits into two procedures depending on whether or not n is even or odd.
to nthRoot [n a h k colorValue turtleFunction]
  ifelse remainder n 2 = 0
  [nthRootEven n a h k colorValue turtleFunction]
  [nthRootOdd n a h k colorValue turtleFunction]

  if not empty? xList
  [set xList but-first xList]
end

;1-24-2018 Eric created this procedure to only work for positive values of x when graphing an nRoot.
to nthRootEven [n a h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0 [
    if (i < length xList
    and (precision (first xList) 5) <= max-pxcor
    and (precision (first xList) 5) >= min-pxcor
    and (first xList >= h
    and (precision (first map [y -> ((a * (y - h) ^ (1 / n)) + k)] xList) 5) <= max-pycor
    and (precision (first map [y -> ((a * (y - h) ^ (1 / n)) + k)] xList) 5) >= min-pycor))

  [sprout 1 [
    set size 0.25
    set shape "circle"
    set color colorValue
    set myFunction turtleFunction
    set xcor (precision (first xList) 5)
    set ycor (precision (first map [y -> ((a * (y - h) ^ (1 / n)) + k)] xList) 5) ]]]
end

;1-24-2018 Eric created this procedure to work for both negative and positive values of x when graphing an nRoot.
to nthRootOdd [n a h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and ((first xList >= h
        and (precision (first map [y -> ((a * (y - h) ^ (1 / n)) + k)] xList) 5) <= max-pycor
        and (precision (first map [y -> ((a * (y - h) ^ (1 / n)) + k)] xList) 5) >= min-pycor)
  or (first xList < h
      and (precision (first map [y -> ((a * (((-1 * (y - h)) ^ (1 / n)) * -1 )) + k) ] xList) 5) <= max-pycor
      and (precision (first map [y -> ((a * (((-1 * (y - h)) ^ (1 / n)) * -1 )) + k) ] xList) 5) >= min-pycor))

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               if first xList >= h
                [set ycor (precision (first map [y -> ((a * (y - h) ^ (1 / n)) + k)] xList) 5) ]
               if first xList < h
                [set ycor (precision (first map [y -> ((a * (((-1 * (y - h)) ^ (1 / n)) * -1 )) + k) ] xList) 5) ]]]]
end

;1-06-2018 Ahmed created this procedure to graph circles.
;1-09-2018 Eric modified this procedure to follow the center coordinate inputs.
;1-10-2018 Eric added functionNum/functionNumber to distinguish between the functions based on numbers.
;1-10-2018 Eric added a restriction of (ticks = 0) so that circle will only run after setup is run (circle doesn't required setup to run because it doesn't make use of the xList but
;     we want it to only run after setup is pushed so the functionNumber can change.
;1-12-2018 Ahmed edited this procedure to take three inputs of the center coordinates and the radius.
;1-13-2018 Ahmed edited this procedure to adhere to the system of mapping used in the other graphing procedures.
;1-13-2018 Ahmed edited this procedure to use the color given in the string input.
;1-13-2018 Ahmed deleted the setting of the functionNumber. The line of the new single input is the distinguishing factor between graphs.
;1-13-2018 Eric added a new parameter to allow the turtles created to set a variable to the string of the function it is.
;1-14-2018 Eric added a fix to the problem where there is never a turtle at the furthest right position of a turtle because of rounding errors.
to circle [xCenter yCenter radius colorValue turtleFunction]
  createXList
  let i 0

  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (first xList) >= (xCenter - radius) and (first xList) < (xCenter + radius)
  and (precision (first map [y -> ((-1 * ((y - xCenter) ^ 2)) + (radius ^ 2))] xList) 5) >= 0
  and (precision (first map [y -> ((sqrt ((-1 * ((y - xCenter) ^ 2)) + (radius ^ 2))) + yCenter)] xList) 5) <= max-pycor
  and (precision (first map [y -> ((sqrt ((-1 * ((y - xCenter) ^ 2)) + (radius ^ 2))) + yCenter)] xList) 5) >= min-pycor
    [sprout 1 [
      set size 0.25
      set shape "circle"
      set color colorValue
      set myFunction turtleFunction
      set xcor (precision (first xList) 5)
      set ycor (precision (first map [y -> ((sqrt ((-1 * ((y - xCenter) ^ 2)) + (radius ^ 2))) + yCenter)] xList) 5) ]]]

  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (first xList) >= (xCenter - radius) and (first xList) < (xCenter + radius)
  and (precision (first map [y -> ((-1 * ((y - xCenter) ^ 2)) + (radius ^ 2))] xList) 5) >= 0
  and (precision (first map [y -> ((sqrt ((-1 * ((y - xCenter) ^ 2)) + (radius ^ 2))) - yCenter)] xList) 5) <= max-pycor
  and (precision (first map [y -> ((sqrt ((-1 * ((y - xCenter) ^ 2)) + (radius ^ 2))) - yCenter)] xList) 5) >= min-pycor
    [sprout 1 [
      set size 0.25
      set shape "circle"
      set color colorValue
      set myFunction turtleFunction
      set xcor (precision (first xList) 5)
      set ycor (-1 * (precision (first map [y -> ((sqrt ((-1 * ((y - xCenter) ^ 2)) + (radius ^ 2))) - yCenter)] xList) 5) )]]]

  if count turtles with [xcor = xCenter + radius and ycor = yCenter] = 0 and count turtles with [myFunction = turtleFunction and xcor = xCenter - radius and ycor = yCenter] > 0
  [ask one-of turtles with [myFunction = turtleFunction and xcor = xCenter - radius and ycor = yCenter] [set xcor xcor + (2 * radius)]]
  if not empty? xList
  [set xList but-first xList]
end

;11-10-2018 Eric created this procedure to graph the sine wave.
to sine [a b h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> a * sin(b * ((y - h) * 180 / pi)) + k] xList) 5) <= max-pycor
  and (precision (first map [y -> a * sin(b * ((y - h) * 180 / pi)) + k] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> a * sin(b * ((y - h) * 180 / pi)) + k] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end

;11-10-2018 Eric created this procedure to graph the cosine wave.
to cosine [a b h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> a * cos(b * ((y - h) * 180 / pi)) + k] xList) 5) <= max-pycor
  and (precision (first map [y -> a * cos(b * ((y - h) * 180 / pi)) + k] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> a * cos(b * ((y - h) * 180 / pi)) + k] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end

;11-10-2018 Eric created this procedure to graph the tangent graph.
to tangent [a b h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> a * tan(b * ((y - h) * 180 / pi)) + k] xList) 5) <= max-pycor
  and (precision (first map [y -> a * tan(b * ((y - h) * 180 / pi)) + k] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> a * tan(b * ((y - h) * 180 / pi)) + k] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end

;11-11-2018 Eric created this procedure to graph the cosecant graph.
to cosecant [a b h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (a * sin(b * ((first xList - h) * 180 / pi))) 2) != 0
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> 1 / (a * sin(b * ((first xList - h) * 180 / pi))) + k] xList) 5) <= max-pycor
  and (precision (first map [y -> 1 / (a * sin(b * ((first xList - h) * 180 / pi))) + k] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> 1 / (a * sin(b * ((first xList - h) * 180 / pi))) + k] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end

;11-11-2018 Eric created this function to graph the secant function.
to secant [a b h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (a * cos(b * ((first xList - h) * 180 / pi))) 2) != 0
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> 1 / (a * cos(b * ((first xList - h) * 180 / pi))) + k] xList) 5) <= max-pycor
  and (precision (first map [y -> 1 / (a * cos(b * ((first xList - h) * 180 / pi))) + k] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> 1 / (a * cos(b * ((first xList - h) * 180 / pi))) + k] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end

;11-11-2018 Eric created this procedure to graph the cotangent graph.
to cotangent [a b h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (a * tan(b * ((first xList - h) * 180 / pi))) 2) != 0
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> 1 / (a * tan(b * ((first xList - h) * 180 / pi))) + k] xList) 5) <= max-pycor
  and (precision (first map [y -> 1 / (a * tan(b * ((first xList - h) * 180 / pi))) + k] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> 1 / (a * tan(b * ((first xList - h) * 180 / pi))) + k] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end

;11-11-2018 Eric created this procedure to graph exponential graphs.
to exponential [a b h c colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> a * (b ^ (y - h)) + c] xList) 5) <= max-pycor
  and (precision (first map [y -> a * (b ^ (y - h)) + c] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> a * (b ^ (y - h)) + c] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end

;11-11-2018 Eric created this procedure to graph logarithmic graphs.
to logarithm [a b h c colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (first xList) 5) > h
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> a * (log (y - h) b) + c] xList) 5) <= max-pycor
  and (precision (first map [y -> a * (log (y - h) b) + c] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> a * (log (y - h) b) + c] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end
to experiment [a b h k colorValue turtleFunction]
  createXList
  let i 0
  ask patch 0 0
  [if i < length xList
  and (precision (a * sin(b * ((first xList - h) * 180 / pi))) 2) != 0
  and (precision (first xList) 5) <= max-pxcor
  and (precision (first xList) 5) >= min-pxcor
  and (precision (first map [y -> 1 / (a * sin(b * ((first xList - h) * 180 / pi))) + k] xList) 5) <= max-pycor
  and (precision (first map [y -> 1 / (a * sin(b * ((first xList - h) * 180 / pi))) + k] xList) 5) >= min-pycor

    [sprout 1 [set size 0.25
               set shape "circle"
               set color colorValue
               set myFunction turtleFunction
               set xcor (precision (first xList) 5)
               set ycor (precision (first map [y -> 1 / (a * sin(b * ((first xList - h) * 180 / pi))) + k] xList) 5)
              ]]]

  if not empty? xList
  [set xList but-first xList]
end

;1-08-2018 Ahmed created this procedure to report the interceptions between the x and y axes.
;1-11-2018 Eric altered this procedure to take the turtles in the general vicinity of the axes and report the mean of their coordinate as the output
;     because there are cases where the turtles are not exactly on the axes.
;1-11-2018 Ahmed expaned this procedure to cover all of the function types.
;1-13-2018 Eric changed this procedure to use the new single input system.
to-report intercept
  if member? "AxisIntercept" firstFunction
  [findIntercept firstFunction]
  if member? "AxisIntercept" secondFunction
  [findIntercept secondFunction]
  if member? "AxisIntercept" thirdFunction
  [findIntercept thirdFunction]
  if member? "AxisIntercept" fourthFunction
  [findIntercept fourthFunction]
  if member? "AxisIntercept" fifthFunction
  [findIntercept fifthFunction]
  report interceptList
end

;1-13-2018 Eric created this procedure to use use the new single input system when finding the x or y intercepts and distinguishs functions by turtle color.
;1-13-2018 Ahmed created a differentiation of the function types such that if it is constant, linear, or root, it takes the mean of the list because
;     those functions should only have 1 x or y intercept.
;1-14-2018 Eric changed the function to no longer distinguish by color but instead by the function written into their myFunction variable.
;1-14-2018 Eric made it such that if we are finding the intercept of a circle and the length of the interceptList is greater than 2 because of rounding
;     issues, then you take the mean of half of the values and the mean of the other half to get the two interception points.
;1-14-2018 Ahmed made it such that when finding the yAxisIntercept for anything other than a circle, the mean is reported because there are no other
;     functions of multiple y axis interceptions.
;1-14-2018 Eric added in new specifications for polyQuadratic for better rounding.
to findIntercept [function#]
  set interceptList []
  let subIntercept1 []
  let subIntercept2 []

  if member? "xAxisIntercept" function#
  [
   ask turtles with [member? myFunction function# and round ycor = 0]
    [if not member? precision xcor 1 interceptList
      [set interceptList lput precision xcor 1 interceptList
       set interceptList sort-by < interceptList]]

   if member? "polyQuadratic" function# and length interceptList > 2
   [set subIntercept1 sublist interceptList 0 (0.5 * length interceptList)
    set subIntercept2 sublist interceptList (0.5 * length interceptList) (length interceptList)
    set subIntercept1 mean subIntercept1
    set subIntercept2 mean subIntercept2
    set interceptList []
    set interceptList lput precision subIntercept1 1 interceptList
    set interceptList lput precision subIntercept2 1 interceptList
    set interceptList sort-by < interceptList]

   if member? "polyQuadratic" function# and ([ycor] of min-one-of turtles with [member? myFunction function#][ycor] = 0 or
                                             [ycor] of max-one-of turtles with [member? myFunction function#][ycor] = 0)
    [set interceptList 0]
  ]

  if member? "yAxisIntercept" function#
  [
   ask turtles with [member? myFunction function# and precision xcor 1 = 0]
    [if not member? precision ycor 1 interceptList
      [set interceptList lput precision ycor 1 interceptList
       set interceptList sort-by < interceptList]]

    if not member? "circle" function# [
      set interceptList precision mean interceptList 1 ]

  ]

  if member? "Root" function# [
    set interceptList mean interceptList]

  if member? "circle" function# and length interceptList > 2
  [set subIntercept1 sublist interceptList 0 (0.5 * length interceptList)
   set subIntercept2 sublist interceptList (0.5 * length interceptList) (length interceptList)
   set subIntercept1 mean subIntercept1
   set subIntercept2 mean subIntercept2
   set interceptList []
   set interceptList lput precision subIntercept1 1 interceptList
   set interceptList lput precision subIntercept2 1 interceptList
   set interceptList sort-by < interceptList]

  if member? "polyLinear" function# and member? "yAxisIntercept" function# [
    set interceptList read-from-string (substring function# (position "b=" function# + 3) (position "color" function# - 1))]
end

;1-08-2018 Ahmed created this reporter procedure to take an x input and report the y values at the x.
;1-11-2018 Eric altered this procedure to take the turtles in the general vicinity of the value inputted and report the mean of their coordinate as the output
;     because there are cases where the turtles are not exactly at the coordinates for the input specified.
;1-11-2018 Ahmed expanded this procedure to cover all function types.
;1-13-2018 Ahmed changed this reporter to use the new single input system.
to-report value
  if member? "find" firstFunction [
    findValue firstFunction]
  if member? "find" secondFunction [
    findValue secondFunction]
  if member? "find" thirdFunction [
    findValue thirdFunction]
  if member? "find" fourthFunction [
    findValue fourthFunction]
  if member? "find" fifthFunction [
    findValue fifthFunction]
  report valueList
end

;1-13-2018 Ahmed created this procedure to use use the new single input system when finding the x or y intercepts and distinguishs functions by turtle color.
;1-14-2018 Eric added a specification similar to the intercept finding for quadratics finding the x when y is something.
to findValue [function#]
  set valueList []
  let subValue1 []
  let subValue2 []

  if member? "YwhenXis" function# [
   if member? "poly" function# [
      ask turtles with [member? myFunction function# and
                       precision xcor 1 = read-from-string (substring function# (position "YwhenXis" function# + 9) (position "poly" function# - 1))] [
        if not member? precision ycor 1 valueList [
          set valueList lput precision ycor 1 valueList
          set valueList sort-by < valueList ]]]

   if member? "square" function#[
      ask turtles with [member? myFunction function# and
                        precision xcor 1 = read-from-string (substring function# (position "YwhenXis" function# + 9) (position "square" function# - 1))] [
        if not member? precision ycor 1 valueList [
          set valueList lput precision ycor 1 valueList
          set valueList sort-by < valueList ]]]

   if member? "cubic" function# or member? "circle" function# [
      ask turtles with [member? myFunction function# and
                        precision xcor 1 = read-from-string (substring function# (position "YwhenXis" function# + 9) (position "c" function# - 1))] [
        if not member? precision ycor 1 valueList [
          set valueList lput precision ycor 1 valueList
          set valueList sort-by < valueList ]]]

    if not member? "circle" function# [
      set valueList mean valueList ]
  ]

  if member? "XwhenYis" function# [
   if member? "poly" function# [
      ask turtles with [member? myFunction function# and
                        precision ycor 1 = read-from-string (substring function# (position "XwhenYis" function# + 9) (position "poly" function# - 1))] [
        if not member? precision xcor 1 valueList [
          set valueList lput precision xcor 1 valueList
          set valueList sort-by < valueList ]]]

   if member? "square" function# [
      ask turtles with [member? myFunction function# and
                        precision ycor 1 = read-from-string (substring function# (position "XwhenYis" function# + 9) (position "square" function# - 1))] [
        if not member? precision xcor 1 valueList [
          set valueList lput precision xcor 1 valueList
          set valueList sort-by < valueList ]]]

   if member? "cubic" function# or member? "circle" function# [
      ask turtles with [member? myFunction function# and
                        precision ycor 1 = read-from-string (substring function# (position "XwhenYis" function# + 9) (position "c" function# - 1))] [
        if not member? precision xcor 1 valueList [
          set valueList lput precision xcor 1 valueList
          set valueList sort-by < valueList ]]]

   if member? "polyQuadratic" function# and length valueList > 2
   [set subValue1 sublist valueList 0 (0.5 * length valueList)
    set subValue2 sublist valueList (0.5 * length valueList) (length valueList)
    set subValue1 mean subValue1
    set subValue2 mean subValue2
    set valueList []
    set valueList lput precision subValue1 1 valueList
    set valueList lput precision subValue2 1 valueList
    set valueList sort-by < valueList]
  ]

  if member? "circle" function# and length valueList > 2
  [set subValue1 sublist valueList 0 (0.5 * length valueList)
   set subValue2 sublist valueList (0.5 * length valueList) (length valueList)
   set subValue1 mean subValue1
   set subValue2 mean subValue2
   set valueList []
   set valueList lput precision subValue1 1 valueList
   set valueList lput precision subValue2 1 valueList
   set valueList sort-by < valueList]

  if member? "Root" function# [
    set interceptList mean interceptList]
end

;1-09-2018 Eric created the intersect function to show intersection points between graphs of functions. somewhat functional
;1-10-2018 Eric made this procedure reset the intersectList after every time it is pressed.
;1-10-2018 Eric made this procedure report the intersection points to the nearest tenth.
;1-14-2018 Eric made the intersect procedure use the new single input system and setup the parameters for two way intersection points.
to-report intersect
  if member? "intersect" firstFunction and member? "intersect" secondFunction [
    findIntersect firstFunction secondFunction ]
  if member? "intersect" firstFunction and member? "intersect" thirdFunction [
    findIntersect firstFunction thirdFunction ]
  if member? "intersect" firstFunction and member? "intersect" fourthFunction [
    findIntersect firstFunction fourthFunction ]
  if member? "intersect" firstFunction and member? "intersect" fifthFunction [
    findIntersect firstFunction fifthFunction ]

  if member? "intersect" secondFunction and member? "intersect" thirdFunction
  [findIntersect secondFunction thirdFunction]
  if member? "intersect" secondFunction and member? "intersect" fourthFunction
  [findIntersect secondFunction fourthFunction]
  if member? "intersect" secondFunction and member? "intersect" fifthFunction
  [findIntersect secondFunction fifthFunction]

  if member? "intersect" thirdFunction and member? "intersect" fourthFunction
  [findIntersect thirdFunction fourthFunction]
  if member? "intersect" thirdFunction and member? "intersect" fifthFunction
  [findIntersect thirdFunction fifthFunction]

  if member? "intersect" fourthFunction and member? "intersect" fifthFunction
  [findIntersect fourthFunction fifthFunction]

  report intersectList
end

;1-14-2018 Eric created a new procedure to the parameters from the intersect reporter and find two way intersection points.
to findIntersect [function1 function2]
  set intersectList []
  let i 0
  let xIntersect []
  let yIntersect []

    ask turtles with [member? myFunction function1]
  [if any? turtles with [member? myFunction function2 and (precision xcor 1) = precision [xcor] of myself 1
                                                      and (precision ycor 1) = precision [ycor] of myself 1]
    [if not member? precision xcor 1 xIntersect [set xIntersect lput precision xcor 1 xIntersect]
     if not member? precision ycor 1 yIntersect [set yIntersect lput precision ycor 1 yIntersect]]]

  if not member? (word (first xIntersect) "," (first yIntersect)) intersectList
  [set intersectList lput (word (first xIntersect) "," (first yIntersect)) intersectList]

  ask turtles with [member? myFunction function1]
  [if any? turtles with [member? myFunction function2 and (precision xcor 1) = precision [xcor] of myself 1
                                                      and (precision ycor 1) = precision [ycor] of myself 1]
    [if (member? "polyLinear" function1 or member? "polyConstant" function1) and (member? "polyLinear" function2 or member? "polyConstant" function2)
     [if not member? precision xcor 1 xIntersect [set xIntersect lput precision xcor 1 xIntersect]
      if not member? precision ycor 1 yIntersect [set yIntersect lput precision ycor 1 yIntersect]]]]

    if (member? "polyLinear" function1 or member? "polyConstant" function1) and (member? "polyLinear" function2 or member? "polyConstant" function2)
        [set xIntersect mean xIntersect
         set yIntersect mean yIntersect
         set intersectList (word (xIntersect) "," (yIntersect))]
end

;1-14-2018 Eric created the reporter to set up the parameters for the finding procedure and made a error message be reported if a wrong type of function is used.
to-report min/max
  if member? "min/max" firstFunction and (member? "polyQuadratic" firstFunction or member? "polyCubic" firstFunction or member? "circle" firstFunction)
  [findMin/Max firstFunction]
  if member? "min/max" secondFunction and (member? "polyQuadratic" secondFunction or member? "polyCubic" secondFunction or member? "circle" secondFunction)
  [findMin/Max secondFunction]
  if member? "min/max" thirdFunction and (member? "polyQuadratic" thirdFunction or member? "polyCubic" thirdFunction or member? "circle" thirdFunction)
  [findMin/Max thirdFunction]
  if member? "min/max" fourthFunction and (member? "polyQuadratic" fourthFunction or member? "polyCubic" fourthFunction or member? "circle" fourthFunction)
  [findMin/Max fourthFunction]
  if member? "min/max" fifthFunction and (member? "polyQuadratic" fifthFunction or member? "polyCubic" fifthFunction or member? "circle" fifthFunction)
  [findMin/Max fifthFunction]
  if member? "min/max" firstFunction and not (member? "polyQuadratic" firstFunction or member? "polyCubic" firstFunction or member? "circle" firstFunction)
  [report "This does not make sense"]
  if member? "min/max" secondFunction and not (member? "polyQuadratic" secondFunction or member? "polyCubic" secondFunction or member? "circle" secondFunction)
  [report "This does not make sense"]
  if member? "min/max" thirdFunction and not (member? "polyQuadratic" thirdFunction or member? "polyCubic" thirdFunction or member? "circle" thirdFunction)
  [report "This does not make sense"]
  if member? "min/max" fourthFunction and not (member? "polyQuadratic" fourthFunction or member? "polyCubic" fourthFunction or member? "circle" fourthFunction)
  [report "This does not make sense"]
  if member? "min/max" fifthFunction and not (member? "polyQuadratic" fifthFunction or member? "polyCubic" fifthFunction or member? "circle" fifthFunction)
  [report "This does not make sense"]

  report minMaxString
end

;1-14-2018 Ahmed created the procedure to find the minimum or maximum of a quadratic or circle graph.
;1-14-2018 Eric created the part of the procedure that finds the minimum or maximum of a cubic polynomial.
to findMin/Max [function#]
  set minMaxString ""
  if member? "polyQuadratic" function# [
    ask one-of turtles with [member? myFunction function#] [
      if read-from-string (substring myFunction (position "a=" myFunction + 3) (position "b" myFunction - 1)) > 0 [
        ask min-one-of turtles with [member? myFunction function#] [ycor] [set minMaxString (word "minimum " precision xcor 2 "," precision ycor 2)]]
      if read-from-string (substring myFunction (position "a=" myFunction + 3) (position "b" myFunction - 1)) < 0 [
        ask max-one-of turtles with [member? myFunction function#] [ycor] [set minMaxString (word "maximum " precision xcor 2 "," precision ycor 2)]]]]

  if member? "circle" function# [
    ask one-of turtles with [member? myFunction function#] [
      set minMaxString (word "maximum " precision [xcor] of max-one-of turtles with [member? myFunction function#] [ycor] 2 ","
        precision [ycor] of max-one-of turtles with [member? myFunction function#] [ycor] 2
        " minimum " precision [xcor] of min-one-of turtles with [member? myFunction function#] [ycor] 2 ","
        precision [ycor] of min-one-of turtles with [member? myFunction function#] [ycor] 2)]]

  let pointOfSymmetry ((-1 *(read-from-string (substring function# (position "b=" function# + 3) (position "c=" function# - 1)))) /
         (3 * (read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1)))))

  if member? "polyCubic" function# [
    ask one-of turtles with [
      member? myFunction function# and
      precision xcor 2 = precision pointOfSymmetry 2]
    [if [ycor] of one-of turtles with [member? myFunction function# and precision xcor 2 = precision (pointOfSymmetry + 1) 2] > [ycor] of one-of turtles with [member? myFunction function# and precision xcor 2 = precision pointOfSymmetry 2] [
      set minMaxString
      (word "maximum " precision [xcor] of max-one-of turtles with [member? myFunction function# and xcor > pointOfSymmetry] [ycor] 2 ","
                       precision [ycor] of max-one-of turtles with [member? myFunction function# and xcor > pointOfSymmetry] [ycor] 2
           " minimum " precision [xcor] of min-one-of turtles with [member? myFunction function# and xcor < pointOfSymmetry] [ycor] 2 ","
                       precision [ycor] of min-one-of turtles with [member? myFunction function# and xcor < pointOfSymmetry] [ycor] 2 )]
    if [ycor] of one-of turtles with [member? myFunction function# and precision xcor 2 = precision (pointOfSymmetry + 1) 2] < [ycor] of one-of turtles with [member? myFunction function# and precision xcor 2 = precision pointOfSymmetry 2] [
      set minMaxString
      (word "maximum " precision [xcor] of max-one-of turtles with [member? myFunction function# and xcor < pointOfSymmetry] [ycor] 2 ","
                       precision [ycor] of max-one-of turtles with [member? myFunction function# and xcor < pointOfSymmetry] [ycor] 2
           " minimum " precision [xcor] of min-one-of turtles with [member? myFunction function# and xcor > pointOfSymmetry] [ycor] 2 ","
                       precision [ycor] of min-one-of turtles with [member? myFunction function# and xcor > pointOfSymmetry] [ycor] 2 )]]

    if (read-from-string (substring function# (position "b=" function# + 3) (position "c=" function# - 1)) = 0 and
        read-from-string (substring function# (position "c=" function# + 3) (position "d=" function# - 1)) = 0)

    or (read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1)) > 0 and
       (read-from-string (substring function# (position "b=" function# + 3) (position "c=" function# - 1)) = 0 and
       (read-from-string (substring function# (position "c=" function# + 3) (position "d=" function# - 1)) > 0)))

    or (read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1)) =
       (read-from-string (substring function# (position "b=" function# + 3) (position "c=" function# - 1))) and
       (read-from-string (substring function# (position "a=" function# + 3) (position "b=" function# - 1)) =
       (read-from-string (substring function# (position "c=" function# + 3) (position "d=" function# - 1)))))
      [set minMaxString "This does not make sense"]]
end
@#$#@#$#@
GRAPHICS-WINDOW
374
10
926
563
-1
-1
32.0
1
10
1
1
1
0
0
0
1
-8
8
-8
8
1
1
1
ticks
30.0

BUTTON
2
43
161
76
NIL
graph
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
230
10
372
43
resizeWorld
resizeWorld
8
32
8.0
1
1
NIL
HORIZONTAL

BUTTON
230
78
372
111
NIL
resizeGraph
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
230
44
372
77
patchSize
patchSize
12
32
32.0
1
1
NIL
HORIZONTAL

BUTTON
2
75
161
108
NIL
clear
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1
362
227
407
xAxisIntercept/yAxisIntercept
intercept
17
1
11

MONITOR
2
408
228
453
findYwhenXis/findXwhenXis
value
17
1
11

INPUTBOX
0
111
373
235
singleInput
log a= 1 b= 2 h= 1 c= 0 color= red
1
1
String

TEXTBOX
3
236
255
362
polyConstant x= or y= color=\npolyLinear m= b= color=\npolyQuadratic a= b= c= color= \npolyCubic a= b= c= d= color= \nnthRoot n= a= h= k= color=\ncircle xCenter= yCenter= radius= color= \nsin/cos/tan/csc/sec/cot a= b= h= k= color=\nexpo/log a= b= h= c= color=
11
0.0
1

BUTTON
2
10
161
43
setup/updateInput
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
260
236
337
326
xAxisIntercept\nyAxisIntercept\nfindYwhenXis\nfindXwhenYis\nintersect\nmin/max
11
0.0
1

MONITOR
2
454
228
499
NIL
intersect
17
1
11

MONITOR
1
500
228
545
NIL
min/max
17
1
11

@#$#@#$#@
# RIPOFF TI-84

## WHAT IS IT?

This model recreates a graphing calculator in its abilities to graph functions and its abilities to report certain properties of the graph of a function. 

## INTRODUCTION

![alt text](https://education.ti.com/-/media/images/ti-education/us/product-details/84-plus-se/product-key-84-plus-se.png?rev=1b0c1605-0e32-468b-9f38-2acfcaf009d1&h=531&w=250&la=en&hash=FB520B0F597E8437309EFD1B9761B0916A878DC3)

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
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
