//
//  main.swift
//
//  Created by Oscar Hierro on 05/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/1
 
 Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator is regulated by stars. Unfortunately, the stars have been stolen... by the Easter Bunny. To save Christmas, Santa needs you to retrieve all fifty stars by December 25th.

 Collect stars by solving puzzles. Two puzzles will be made available on each day in the advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

 You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.

 The Document indicates that you should start at the given coordinates (where you just landed) and face North. Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at a new intersection.

 There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?

 For example:

 Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
 R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
 R5, L5, R5, R3 leaves you 12 blocks away.

 How many blocks away is Easter Bunny HQ?

 */

let input = ["L5", "R1", "R3", "L4", "R3", "R1", "L3", "L2", "R3", "L5", "L1", "L2", "R5", "L1", "R5", "R1", "L4", "R1", "R3", "L4", "L1", "R2", "R5", "R3", "R1", "R1", "L1", "R1", "L1", "L2", "L1", "R2", "L5", "L188", "L4", "R1", "R4", "L3", "R47", "R1", "L1", "R77", "R5", "L2", "R1", "L2", "R4", "L5", "L1", "R3", "R187", "L4", "L3", "L3", "R2", "L3", "L5", "L4", "L4", "R1", "R5", "L4", "L3", "L3", "L3", "L2", "L5", "R1", "L2", "R5", "L3", "L4", "R4", "L5", "R3", "R4", "L2", "L1", "L4", "R1", "L3", "R1", "R3", "L2", "R1", "R4", "R5", "L3", "R5", "R3", "L3", "R4", "L2", "L5", "L1", "L1", "R3", "R1", "L4", "R3", "R3", "L2", "R5", "R4", "R1", "R3", "L4", "R3", "R3", "L2", "L4", "L5", "R1", "L4", "L5", "R4", "L2", "L1", "L3", "L3", "L5", "R3", "L4", "L3", "R5", "R4", "R2", "L4", "R2", "R3", "L3", "R4", "L1", "L3", "R2", "R1", "R5", "L4", "L5", "L5", "R4", "L5", "L2", "L4", "R4", "R4", "R1", "L3", "L2", "L4", "R3"];

var inputIndex = 0;

enum Direction
{
    case Left
    case Right
}

enum Orientation
{
    case North
    case South
    case West
    case East
}

struct Instruction
{
    let turn : Direction
    let numBlocks : Int
}

struct Position
{
    var x: Int
    var y: Int
    var facing: Orientation
}

func readNextInstruction() -> Instruction?
{
    if (inputIndex == input.count)
    {
        print("Reached the end of the instruction pool!")
        return nil
    }

    let nextInputEntry = input[inputIndex] as String
    inputIndex += 1

    // eg. 'L5' -> 5
    let numericValue = nextInputEntry[nextInputEntry.index(nextInputEntry.startIndex, offsetBy: 1)...]

    if let numBlocks = NumberFormatter().number(from: String(numericValue))
    {
        if nextInputEntry.hasPrefix("L")
        {
            return Instruction(turn: .Left, numBlocks: numBlocks.intValue);
        }
        else
        {
            return Instruction(turn: .Right, numBlocks: numBlocks.intValue);
        }
    }
    else
    {
        print("Error interpreting the instruction '\(nextInputEntry)'")
        return nil
    }
}

func executeInstruction(instruction: Instruction, currentPosition: inout Position)
{
    print("\(instruction)")

    if instruction.turn == .Left
    {
        switch currentPosition.facing
        {
        case .North:
            currentPosition.x = currentPosition.x - instruction.numBlocks
            currentPosition.facing = .West

        case .South:
            currentPosition.x = currentPosition.x + instruction.numBlocks
            currentPosition.facing = .East

        case .West:
            currentPosition.y = currentPosition.y - instruction.numBlocks
            currentPosition.facing = .South

        case .East:
            currentPosition.y = currentPosition.y + instruction.numBlocks
            currentPosition.facing = .North
        }
    }
    else // .Right
    {
        switch currentPosition.facing
        {
        case .North:
            currentPosition.x = currentPosition.x + instruction.numBlocks
            currentPosition.facing = .East

        case .South:
            currentPosition.x = currentPosition.x - instruction.numBlocks
            currentPosition.facing = .West

        case .West:
            currentPosition.y = currentPosition.y + instruction.numBlocks
            currentPosition.facing = .North

        case .East:
            currentPosition.y = currentPosition.y - instruction.numBlocks
            currentPosition.facing = .South
        }
    }

    print("new position \(currentPosition)")
}

// the initial position
var position = Position(x: 0, y: 0, facing: .North)

while (true)
{
    if let instruction = readNextInstruction()
    {
        executeInstruction(instruction: instruction, currentPosition: &position)
    }
    else
    {
        break
    }
}

print("Arrived at position \(position), \(abs(position.x) + abs(position.y)) blocks away")
