//
//  main.swift
//
//  Created by Oscar Hierro on 30/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/7

 --- Part Two ---

 You would also like to know which IPs support SSL (super-secret listening).

 An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any square bracketed sections), and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences. An ABA is any three-character sequence which consists of the same character twice with a different character between them, such as xyx or aba. A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.

 For example:

 aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
 xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
 aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
 zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).

 How many IPs in your puzzle input support SSL?

 */

extension String {

    var length: Int {
        return self.count
    }

    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }

    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }

    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
}

func containsBABSequenceWithinSquareBrackets(input: String, sequence: String) -> Bool
{
    let pattern = "\\w*\\[(\\w+)\\]\\w*" // captures one sequence within brackets (hypernet) in the input string
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.count))

    // each match should have exactly one capture group (i.e. a hypernet)
    for match in matches
    {
        let hypernetRange = input.index(input.startIndex, offsetBy: match.range(at: 1).location) ..< input.index(input.startIndex, offsetBy: match.range(at: 1).location + match.range(at: 1).length)
        let hypernet = input.substring(with: Range(hypernetRange))

        if hypernet.contains(sequence)
        {
            return true
        }
    }

    return false
}


let input: String = try String.init(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!)

var totalIPCount = 0
var supportsSSLCount = 0


input.enumerateLines { (ip, stop) in

    totalIPCount += 1
    var withinSquareBrackets = false

    for (index, char) in ip.enumerated()
    {
        if char == "[" || char == "]"
        {
            withinSquareBrackets = !withinSquareBrackets
            continue
        }

        if withinSquareBrackets
        {
            // we don't need to search for ABAs within square brackets
            continue
        }

        if index + 2 < ip.length
        {
            let char1 = ip[index], char2 = ip[index + 1], char3 = ip[index + 2]

            if char1 == char3 && char1 != char2
            {
                // ABA found outside square brackets, see if the corresponding BAB can be found within the hypernet(s)
                if containsBABSequenceWithinSquareBrackets(input: ip, sequence: char2 + char1 + char2)
                {
                    supportsSSLCount += 1
                    print("Supports SSL: \(ip)")

                    break;
                }
            }
        }
        else
        {
            break;
        }
    }
}

print("Number of IPs that support SSL: \(supportsSSLCount) out of \(totalIPCount)")



