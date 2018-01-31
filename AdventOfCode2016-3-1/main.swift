//
//  main.swift
//
//  Created by Oscar Hierro on 05/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/3

 --- Day 3: Squares With Three Sides ---

 Now that you can think clearly, you move deeper into the labyrinth of hallways and office furniture that makes up this part of Easter Bunny HQ. This must be a graphic design department; the walls are covered in specifications for triangles.

 Or are they?

 The design document gives the side lengths of each triangle it describes, but... 5 10 25? Some of these aren't triangles. You can't help but mark the impossible ones.

 In a valid triangle, the sum of any two sides must be larger than the remaining side. For example, the "triangle" given above is impossible, because 5 + 10 is not larger than 25.

 In your puzzle input, how many of the listed triangles are possible?

 */


let input: String = try String.init(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!)

var numTotalTriangles = 0
var numPossibleTriangles = 0

input.enumerateLines { (line, stop: inout Bool) in

    let numberScanner = Scanner(string: line)
    var side1:Int = 0, side2: Int = 0, side3:Int = 0

    if !numberScanner.scanInt(&side1) || !numberScanner.scanInt(&side2) || !numberScanner.scanInt(&side3)
    {
        print("Bad input!")
        return
    }

    numTotalTriangles += 1

    if side1 + side2 > side3 && side1 + side3 > side2 && side2 + side3 > side1
    {
        print("\(side1), \(side2), \(side3) is possible")
        numPossibleTriangles += 1
    }
    else
    {
        print("\(side1), \(side2), \(side3) is INVALID")
    }
}

print("Number of possible triangles: \(numPossibleTriangles) out of \(numTotalTriangles)")
