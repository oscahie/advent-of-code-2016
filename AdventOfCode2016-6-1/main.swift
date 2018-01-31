//
//  main.swift
//
//  Created by Oscar Hierro on 29/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/6

 --- Day 6: Signals and Noise ---

 Something is jamming your communications with Santa. Fortunately, your signal is only partially jammed, and protocol in situations like this is to switch to a simple repetition code to get the message through.

 In this model, the same message is sent repeatedly. You've recorded the repeating message signal (your puzzle input), but the data seems quite corrupted - almost too badly to recover. Almost.

 All you need to do is figure out which character is most frequent for each position. For example, suppose you had recorded the following messages:

 eedadn
 drvtee
 eandsr
 raavrd
 atevrs
 tsrnev
 sdttsa
 rasrtv
 nssdts
 ntnada
 svetve
 tesnvt
 vntsnd
 vrdear
 dvrsen
 enarar

 The most common character in the first column is e; in the second, a; in the third, s, and so on. Combining these characters returns the error-corrected message, easter.

 Given the recording in your puzzle input, what is the error-corrected version of the message being sent?

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

    // sort the frequencies from higher to lower
    let sortedFrequencies: [(char: Character, freq: Int)] = frequencyTable.flatMap {
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

    // take the most frequent char in the column
    message.append(sortedFrequencies[0].char)
}

print("Error-corrected message: \(message)")

