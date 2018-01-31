//
//  main.swift
//
//  Created by Oscar Hierro on 30/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/7

 --- Day 7: Internet Protocol Version 7 ---

 While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to figure out which IPs support TLS (transport-layer snooping).

 An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character sequence which consists of a pair of two different characters followed by the reverse of that pair, such as xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, which are contained by square brackets.

 For example:

 abba[mnop]qrst supports TLS (abba outside square brackets).
 abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
 aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
 ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).

 How many IPs in your puzzle input support TLS?

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

let input: String = try String.init(contentsOfFile: Bundle.main.path(forResource: "input", ofType: "txt")!)

var totalIPCount = 0
var supportsTLSCount = 0


input.enumerateLines { (ip, stop) in

    totalIPCount += 1
    var withinSquareBrackets = false
    var abbaFoundOutsideSquareBrackets = false
    var abbaFoundWithinSquareBrackets = false

    for (index, char) in ip.enumerated()
    {
        if char == "[" || char == "]"
        {
            withinSquareBrackets = !withinSquareBrackets
            continue
        }

        // minor performance optimization - we have already found an ABBA so no need to find another one
        if abbaFoundOutsideSquareBrackets && !withinSquareBrackets
        {
            continue
        }

        if index + 3 < ip.length
        {
            let char1 = ip[index], char2 = ip[index + 1], char3 = ip[index + 2], char4 = ip[index + 3]

            if char1 != char2 && char2 == char3 && char1 == char4
            {
                // ABBA found

                if withinSquareBrackets
                {
                    abbaFoundWithinSquareBrackets = true;

                    // this IP won't support TLS so abort the parsing now
                    break;
                }
                else
                {
                    abbaFoundOutsideSquareBrackets = true
                }
            }
        }
        else
        {
            break;
        }
    }

    if abbaFoundOutsideSquareBrackets && !abbaFoundWithinSquareBrackets
    {
        supportsTLSCount += 1
        print("Supports TLS: \(ip)")
    }
}

print("Number of IPs that support TLS: \(supportsTLSCount) out of \(totalIPCount)")



