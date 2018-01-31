//
//  main.swift
//
//  Created by Oscar Hierro on 05/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/1

 --- Part Two ---

 Then, you notice the instructions continue on the back of the Recruiting Document. Easter Bunny HQ is actually at the first location you visit twice.

 For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due East.

 How many blocks away is the first location you visit twice?

 */

let input = ["L5", "R1", "R3", "L4", "R3", "R1", "L3", "L2", "R3", "L5", "L1", "L2", "R5", "L1", "R5", "R1", "L4", "R1", "R3", "L4", "L1", "R2", "R5", "R3", "R1", "R1", "L1", "R1", "L1", "L2", "L1", "R2", "L5", "L188", "L4", "R1", "R4", "L3", "R47", "R1", "L1", "R77", "R5", "L2", "R1", "L2", "R4", "L5", "L1", "R3", "R187", "L4", "L3", "L3", "R2", "L3", "L5", "L4", "L4", "R1", "R5", "L4", "L3", "L3", "L3", "L2", "L5", "R1", "L2", "R5", "L3", "L4", "R4", "L5", "R3", "R4", "L2", "L1", "L4", "R1", "L3", "R1", "R3", "L2", "R1", "R4", "R5", "L3", "R5", "R3", "L3", "R4", "L2", "L5", "L1", "L1", "R3", "R1", "L4", "R3", "R3", "L2", "R5", "R4", "R1", "R3", "L4", "R3", "R3", "L2", "L4", "L5", "R1", "L4", "L5", "R4", "L2", "L1", "L3", "L3", "L5", "R3", "L4", "L3", "R5", "R4", "R2", "L4", "R2", "R3", "L3", "R4", "L1", "L3", "R2", "R1", "R5", "L4", "L5", "L5", "R4", "L5", "L2", "L4", "R4", "R4", "R1", "L3", "L2", "L4", "R3"];

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

extension Position : Equatable {}

func ==(lhs: Position, rhs: Position) -> Bool {
    let areEqual = lhs.x == rhs.x && lhs.y == rhs.y
    return areEqual
}

var visitedLocations: Array<Position> = Array()
var inputIndex = 0;

func readNextInstruction() -> Instruction?
{
    if (inputIndex == input.count)
    {
        print("Reached the end of the instruction pool!")
        return nil
    }

    let nextInputEntry = input[inputIndex] as String
    inputIndex += 1

    let numericValue = String(nextInputEntry[nextInputEntry.index(nextInputEntry.startIndex, offsetBy: 1)...])

    if let numBlocks = NumberFormatter().number(from: numericValue)
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

func moveOnX(fromPosition position: inout Position, by blocks: Int, step: Int)
{
    for index in 1...blocks
    {
        let newPosition = Position(x: position.x + step * index, y: position.y, facing: position.facing)

        if (visitedLocations.contains(where: { (prevPosition) -> Bool in
            return newPosition == prevPosition
        }))
        {
            print("We've been at \(newPosition) before, which is \(abs(newPosition.x) + abs(newPosition.y)) blocks away")
            exit(0)
        }

        visitedLocations.append(newPosition)
    }

    position.x += blocks * step
}

func moveOnY(fromPosition position: inout Position, by blocks: Int, step: Int)
{
    for index in 1...blocks
    {
        let newPosition = Position(x: position.x, y: position.y + step * index, facing: position.facing)

        if (visitedLocations.contains(where: { (prevPosition) -> Bool in
            return newPosition == prevPosition
        }))
        {
            print("We've been at \(newPosition) before, which is \(abs(newPosition.x) + abs(newPosition.y)) blocks away")
            exit(0)
        }

        visitedLocations.append(newPosition)
    }

    position.y += blocks * step
}

func executeInstruction(instruction: Instruction, currentPosition: inout Position)
{
    print("\(instruction)")

    if instruction.turn == .Left
    {
        switch currentPosition.facing
        {
        case .North:
            currentPosition.facing = .West
            moveOnX(fromPosition: &currentPosition, by: instruction.numBlocks, step: -1)

        case .South:
            currentPosition.facing = .East
            moveOnX(fromPosition: &currentPosition, by: instruction.numBlocks, step: 1)

        case .West:
            currentPosition.facing = .South
            moveOnY(fromPosition: &currentPosition, by: instruction.numBlocks, step: -1)

        case .East:
            currentPosition.facing = .North
            moveOnY(fromPosition: &currentPosition, by: instruction.numBlocks, step: 1)
        }
    }
    else // .Right
    {
        switch currentPosition.facing
        {
        case .North:
            currentPosition.facing = .East
            moveOnX(fromPosition: &currentPosition, by: instruction.numBlocks, step: 1)

        case .South:
            currentPosition.facing = .West
            moveOnX(fromPosition: &currentPosition, by: instruction.numBlocks, step: -1)

        case .West:
            currentPosition.facing = .North
            moveOnY(fromPosition: &currentPosition, by: instruction.numBlocks, step: 1)

        case .East:
            currentPosition.facing = .South
            moveOnY(fromPosition: &currentPosition, by: instruction.numBlocks, step: -1)
        }
    }

    //print("new position \(position)")
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

