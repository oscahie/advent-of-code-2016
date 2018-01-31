//
//  main.swift
//
//  Created by Oscar Hierro on 05/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/4

 --- Day 4: Security Through Obscurity ---

 Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy data, but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.

 Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.

 A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. For example:

 aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
 a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
 not-a-real-room-404[oarel] is a real room.
 totally-real-room-200[decoy] is not.

 Of the real rooms from the list above, the sum of their sector IDs is 1514.

 What is the sum of the sector IDs of the real rooms?

 */


let input: String = try String.init(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!)

struct Room
{
    var name: String
    var sectorId: Int
    var checksum: String
}

func parseRoom(roomString: String) -> Room?
{
    let pattern = "([a-z-]+)-([0-9]+)\\[([a-z]+)\\]"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matches(in: roomString, options: [], range: NSRange(location: 0, length: roomString.count))

    if matches.count == 1 && matches[0].numberOfRanges == 4
    {
        let match = matches[0]

        let nameRange = roomString.index(roomString.startIndex, offsetBy: match.range(at: 1).location) ..< roomString.index(roomString.startIndex, offsetBy: match.range(at: 1).location+match.range(at: 1).length)
        let sectorIdRange = roomString.index(roomString.startIndex, offsetBy: match.range(at: 2).location) ..< roomString.index(roomString.startIndex, offsetBy: match.range(at: 2).location+match.range(at: 2).length)
        let checksumRange = roomString.index(roomString.startIndex, offsetBy: match.range(at: 3).location) ..< roomString.index(roomString.startIndex, offsetBy: match.range(at: 3).location+match.range(at: 3).length)

        return Room(name: roomString[nameRange].replacingOccurrences(of: "-", with: ""),
                sectorId: Int(roomString[sectorIdRange])!,
                checksum: String(roomString[checksumRange]))
    }

    print("bad input: \(roomString)")
    
    return nil
}

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

func calculateChecksum(name: String) -> String
{
    var frequencies: [Character : Int] = [:]

    for char in name
    {
        if frequencies[char] == nil
        {
            frequencies[char] = 1
        }
        else
        {
            frequencies[char] = frequencies[char]! + 1
        }
    }

    let sortedFrequencies: [(char: Character, freq: Int)] = frequencies.flatMap {
        return (char: $0.key, freq: $0.value)
    }.sorted {
        if ($0.freq == $1.freq)
        {
            return $0.char.asciiValue! < $1.char.asciiValue!
        }
        else
        {
            return $0.freq > $1.freq
        }
    }

    var checksum = ""

    for i in 0..<5
    {
        checksum.append(sortedFrequencies[i].char)
    }

    return checksum
}

var numTotalRooms = 0
var numRealRooms = 0
var sectorIdSum = 0

input.enumerateLines { (line, stop) in

    if let room = parseRoom(roomString: line)
    {
        let checksum = calculateChecksum(name: room.name)

        if checksum == room.checksum
        {
            numRealRooms += 1
            sectorIdSum += room.sectorId
        }

        numTotalRooms += 1
    }
}

print("Number of real rooms: \(numRealRooms) out of \(numTotalRooms), with a sum of sector IDs: \(sectorIdSum)")



