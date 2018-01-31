//
//  main.swift
//
//  Created by Oscar Hierro on 30/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/8

 --- Day 8: Two-Factor Authentication ---

 You come across a door implementing what you can only assume is an implementation of two-factor authentication after a long game of requirements telephone.

 To get past the door, you first swipe a keycard (no problem; there was one on a nearby desk). Then, it displays a code on a little screen, and you type that code on a keypad. Then, presumably, the door unlocks.

 Unfortunately, the screen has been smashed. After a few minutes, you've taken everything apart and figured out how it works. Now you just have to work out what the screen would have displayed.

 The magnetic strip on the card you swiped encodes a series of instructions for the screen; these instructions are your puzzle input. The screen is 50 pixels wide and 6 pixels tall, all of which start off, and is capable of three somewhat peculiar operations:

 rect AxB turns on all of the pixels in a rectangle at the top-left of the screen which is A wide and B tall.
 rotate row y=A by B shifts all of the pixels in row A (0 is the top row) right by B pixels. Pixels that would fall off the right end appear at the left end of the row.
 rotate column x=A by B shifts all of the pixels in column A (0 is the left column) down by B pixels. Pixels that would fall off the bottom appear at the top of the column.

 For example, here is a simple sequence on a smaller screen:

 rect 3x2 creates a small rectangle in the top-left corner:

 ###....
 ###....
 .......

 rotate column x=1 by 1 rotates the second column down by one pixel:

 #.#....
 ###....
 .#.....

 rotate row y=0 by 4 rotates the top row right by four pixels:

 ....#.#
 ###....
 .#.....

 rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel to wrap back to the top:

 .#..#.#
 #.#....
 .#.....

 As you can see, this display technology is extremely powerful, and will soon dominate the tiny-code-displaying-screen market. That's what the advertisement on the back of the display tries to convince you, anyway.

 There seems to be an intermediate check of the voltage used by the display: after you swipe your card, if the screen did work, how many pixels should be lit?

 */


let numPixelsWide = 50
let numPixelsTall = 6

var screen = Array<Array<Int>>()

func drawScreen()
{
    for y in 0 ..< numPixelsTall
    {
        for x in 0 ..< numPixelsWide
        {
            if screen[y][x] == 1
            {
                print("#", terminator: "")
            }
            else
            {
                print(".", terminator: "")
            }
        }

        print("") // \n
    }
}

// initialize the screen with all pixels off (0)

for _ in 0 ..< numPixelsTall
{
    var column = Array<Int>()

    for _ in 0 ..< numPixelsWide
    {
        column.append(0)
    }

    screen.append(column)
}

// process the instructions

let input: String = try String.init(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!)

enum Instruction
{
    case Rect(pixelsWide: Int, pixelsTall:Int)
    case RotateRow(row: Int, pixels: Int)
    case RotateColumn(column: Int, pixels: Int)
}

func parseInstruction(instructionStr: String) -> Instruction?
{
    // a very quick & dirty number parser... just ignore everything but numbers
    let numberScanner = Scanner(string: instructionStr)
    numberScanner.charactersToBeSkipped = CharacterSet.decimalDigits.inverted

    var A = 0, B = 0
    numberScanner.scanInt(&A)
    numberScanner.scanInt(&B)

    if instructionStr.hasPrefix("rect")
    {
        return .Rect(pixelsWide: A, pixelsTall: B)
    }

    if instructionStr.hasPrefix("rotate row")
    {
        return .RotateRow(row: A, pixels: B)
    }

    if instructionStr.hasPrefix("rotate column")
    {
        return .RotateColumn(column: A, pixels: B)
    }

    print("bad instruction: \(instructionStr)")
    
    return nil
}

func createRectangle(width: Int, height: Int)
{
    // check bounds
    if width >= numPixelsWide || height >= numPixelsTall
    {
        return
    }

    for y in 0 ..< height
    {
        for x in 0 ..< width
        {
            screen[y][x] = 1
        }
    }
}

func rotateRow(row: Int, pixels: Int)
{
    var updatedRow = Array(screen[row]) // make a deep copy

    for index in 0 ..< numPixelsWide
    {
        let newIndex = (index + pixels) % numPixelsWide
        updatedRow[newIndex] = screen[row][index]
    }

    screen[row] = updatedRow
}

func rotateColumn(column: Int, pixels: Int)
{
    // make a copy of the selected column into an array, to make things easier
    var updatedColumn = [Int]()

    for row in 0 ..< numPixelsTall
    {
        updatedColumn.append(screen[row][column])
    }

    // now rotate it
    for index in 0 ..< numPixelsTall
    {
        let newIndex = (index + pixels) % numPixelsTall
        updatedColumn[newIndex] = screen[index][column]
    }

    // update the column in the screen
    for row in 0 ..< numPixelsTall
    {
        screen[row][column] = updatedColumn[row]
    }
}

// process the input

input.enumerateLines { (line, stop) in

    if let instruction = parseInstruction(instructionStr: line)
    {
        print(instruction)

        switch instruction
        {
        case .Rect(let width, let height):
            createRectangle(width: width, height: height)
            break

        case .RotateRow(let row, let pixels):
            rotateRow(row: row, pixels: pixels)
            break

        case .RotateColumn(let column, let pixels):
            rotateColumn(column: column, pixels: pixels)
            break
        }

        drawScreen()
    }
}

// count the lit pixels

var numPixelsLit = 0

for y in 0 ..< numPixelsTall
{
    for x in 0 ..< numPixelsWide
    {
        numPixelsLit += screen[y][x]
    }
}

print("Total number of pixels lit: \(numPixelsLit)")

