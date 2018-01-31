//
//  main.swift
//
//  Created by Oscar Hierro on 29/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/6

 --- Part Two ---

 Of course, that would be the message - if you hadn't agreed to use a modified repetition code instead.

 In this modified code, the sender instead transmits what looks like random data, but for each character, the character they actually want to send is slightly less likely than the others. Even after signal-jamming noise, you can look at the letter distributions in each column and choose the least common letter to reconstruct the original message.

 In the above example, the least common character in the first column is a; in the second, d, and so on. Repeating this process for the remaining characters produces the original message, advent.

 Given the recording in your puzzle input and this new decoding methodology, what is the original message that Santa is trying to send?

 */

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

let input: String = try String.init(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!)
var message: String = ""

// 8 columns
for column in 0...7
{
    var frequencyTable = [Character : Int]()

    input.enumerateLines { (line, stop) in

        let char = line[line.index(line.startIndex, offsetBy: column)]

        if frequencyTable[char] == nil
        {
            frequencyTable[char] = 1
        }
        else
        {
            frequencyTable[char] = frequencyTable[char]! + 1
        }
    }

    // sort the frequencies from lower to higher
    let sortedFrequencies: [(char: Character, freq: Int)] = frequencyTable.flatMap {
        return (char: $0.key, freq: $0.value)
        }.sorted {
            if ($0.freq == $1.freq)
            {
                return $0.char.asciiValue! < $1.char.asciiValue!
            }
            else
            {
                return $0.freq < $1.freq
            }
    }

    // take the least frequent char in the column
    message.append(sortedFrequencies[0].char)
}

print("Error-corrected message: \(message)")

