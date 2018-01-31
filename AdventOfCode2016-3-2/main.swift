//
//  main.swift
//
//  Created by Oscar Hierro on 05/12/16.
//

import Foundation

import Foundation

/*
 http://adventofcode.com/2016/day/3

 --- Part Two ---

 Now that you've helpfully marked up their design documents, it occurs to you that triangles are specified in groups of three vertically. Each set of three numbers in a column specifies a triangle. Rows are unrelated.

 For example, given the following specification, numbers with the same hundreds digit would be part of the same triangle:

 101 301 501
 102 302 502
 103 303 503
 201 401 601
 202 402 602
 203 403 603

 In your puzzle input, and instead reading by columns, how many of the listed triangles are possible?

 */


let input: String = try String.init(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!)

var numTotalTriangles = 0
var numPossibleTriangles = 0
var sides: [Int] = []

// go through the input but reading numbers on only one column at a time, thus 3 loops
for columnIndex in 1...3
{
    input.enumerateLines { (line, stop: inout Bool) in

        let numberScanner = Scanner(string: line)
        var side: Int = 0

        // read but throw away the previously read column(s), keep only the value for the current one
        for _ in 1...columnIndex
        {
            if !numberScanner.scanInt(&side)
            {
                print("Bad input!")
                return
            }
        }

        sides.append(side)

        if (sides.count == 3)
        {
            if (sides[0] + sides[1] > sides[2]) && (sides[0] + sides[2] > sides[1]) && (sides[1] + sides[2] > sides[0])
            {
                print("\(sides[0]), \(sides[1]), \(sides[2]) is possible")
                numPossibleTriangles += 1
            }
            else
            {
                print("\(sides[0]), \(sides[1]), \(sides[2]) is INVALID")
            }

            numTotalTriangles += 1
            sides = []
        }
    }
}

print("Number of possible triangles: \(numPossibleTriangles) out of \(numTotalTriangles)")





