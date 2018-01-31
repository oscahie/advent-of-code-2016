//
//  main.swift
//
//  Created by Oscar Hierro on 08/12/16.
//

import Foundation

/*
 http://adventofcode.com/2016/day/5

 --- Day 5: How About a Nice Game of Chess? ---

 You are faced with a security door designed by Easter Bunny engineers that seem to have acquired most of their security knowledge by watching hacking movies.

 The eight-character password for the door is generated one character at a time by finding the MD5 hash of some Door ID (your puzzle input) and an increasing integer index (starting with 0).

 A hash indicates the next character in the password if its hexadecimal representation starts with five zeroes. If it does, the sixth character in the hash is the next character of the password.

 For example, if the Door ID is abc:

 The first index which produces a hash that starts with five zeroes is 3231929, which we find by hashing abc3231929; the sixth character of the hash, and thus the first character of the password, is 1.
 5017308 produces the next interesting hash, which starts with 000008f82..., so the second character of the password is 8.
 The third time a hash starts with five zeroes is for abc5278568, discovering the character f.

 In this example, after continuing this search a total of eight times, the password is 18f47a30.

 Given the actual Door ID, what is the password?

 Your puzzle input is ffykfhsq.

 */

var doorID = "ffykfhsq"
var index = 0
var password = ""
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
        password.append(hash[indexOfFifthChar])

        if password.lengthOfBytes(using: String.Encoding.utf8) == 8
        {
            keepGoing = false;
        }

    }
    result.deallocate(capacity: digestLen)
    index += 1
}

print("Found password: \(password)")


