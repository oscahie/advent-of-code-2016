//
//  main.swift
//
//  Created by Oscar Hierro on 08/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/5

 --- Part Two ---

 As the door slides open, you are presented with a second door that uses a slightly more inspired security mechanism. Clearly unimpressed by the last version (in what movie is the password decrypted in order?!), the Easter Bunny engineers have worked out a better solution.

 Instead of simply filling in the password from left to right, the hash now also indicates the position within the password to fill. You still look for hashes that begin with five zeroes; however, now, the sixth character represents the position (0-7), and the seventh character is the character to put in that position.

 A hash result of 000001f means that f is the second character in the password. Use only the first result for each position, and ignore invalid positions.

 For example, if the Door ID is abc:

 The first interesting hash is from abc3231929, which produces 0000015...; so, 5 goes in position 1: _5______.
 In the previous method, 5017308 produced an interesting hash; however, it is ignored, because it specifies an invalid position (8).
 The second interesting hash is at index 5357525, which produces 000004e...; so, e goes in position 4: _5__e___.

 You almost choke on your popcorn as the final character falls into place, producing the password 05ace8e3.

 Given the actual Door ID and this new method, what is the password? Be extra proud of your solution if it uses a cinematic "decrypting" animation.

 Your puzzle input is still ffykfhsq.

 */

var doorID = "ffykfhsq"
var index = 0
var password = ["", "", "", "", "", "", "", ""]
var passwordCharsFound = 0
var keepGoing = true

while keepGoing
{
    let input = doorID.appending(String(index))

    let str = input.cString(using: String.Encoding.utf8)
    let strLen = CC_LONG(input.lengthOfBytes(using: String.Encoding.utf8))
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

    CC_MD5(str, strLen, result)

    if (result[0] == 0 && result[1] == 0 && result[2] < 16)
    {
        var hash = String()

        for i in 0..<digestLen {
            hash = hash.appendingFormat("%02x", result[i])
        }

        print("found hash \(hash)")

        let indexOfFifthChar = hash.index(hash.startIndex, offsetBy: 5)
        let indexOfSixthChar = hash.index(hash.startIndex, offsetBy: 6)

        if let position = Int(String(hash[indexOfFifthChar]))
        {
            if position < 8 && password[position] == ""
            {
                password[position] = String(hash[indexOfSixthChar])
                passwordCharsFound += 1
            }

            if passwordCharsFound == 8
            {
                keepGoing = false
            }
        }
    }

    result.deallocate(capacity: digestLen)
    index += 1
}

print("Found password: \(password)")


