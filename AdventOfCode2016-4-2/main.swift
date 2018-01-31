//
//  main.swift
//
//  Created by Oscar Hierro on 05/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/4

 --- Part Two ---

 With all the decoy data out of the way, it's time to decrypt this list and get moving.

 The room names are encrypted by a state-of-the-art shift cipher, which is nearly unbreakable without the right software. However, the information kiosk designers at Easter Bunny HQ were not expecting to deal with a master cryptographer like yourself.

 To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID. A becomes B, B becomes C, Z becomes A, and so on. Dashes become spaces.

 For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.

 What is the sector ID of the room where North Pole objects are stored?

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

        return Room(name: roomString.substring(with: nameRange),
                    sectorId: Int(roomString.substring(with: sectorIdRange))!,
                    checksum: roomString.substring(with: checksumRange))
    }

    return nil
}

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }

    var nextASCIICharacter: Character {
        if (self == "z")
        {
            return "a"
        }

        return Character(UnicodeScalar(self.asciiValue! + 1)!)
    }
}

func calculateChecksum(name: String) -> String
{
    var frequencies: [Character : Int] = [:]

    for char in name
    {
        if char == "-"
        {
            continue
        }

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

func decrypt(room: inout Room) -> Room
{
    var decryptedRoomName = ""

    for char in room.name
    {
        if char == "-"
        {
            decryptedRoomName.append(" ")
            continue
        }

        var decryptedChar = char

        for _ in 0..<room.sectorId % 26
        {
            decryptedChar = decryptedChar.nextASCIICharacter
        }

        decryptedRoomName.append(decryptedChar)
    }

    room.name = decryptedRoomName

    return room
}

input.enumerateLines { (line, stop) in

    var room = parseRoom(roomString: line)
    let checksum = calculateChecksum(name: (room?.name)!)

    if checksum == room?.checksum
    {
        room = decrypt(room: &room!)

        if (room?.name.hasPrefix("northpole"))!
        {
            print("Found it: \(String(describing: room))")
        }
    }
}
