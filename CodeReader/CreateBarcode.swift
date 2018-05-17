//
//  File2.swift
//  CodeReader
//
//  Created by stone on 2018/05/14.
//  Copyright © 2018年 stone. All rights reserved.
//

import Foundation
var CodeStart = ""
var CodeLeft = ""
var CodeRight = ""
var Code:String = ""
var QorB: Bool = true
var output: [Int] = []
class MakingBarcode{
    let component: [[[Int]]] = [
        [[0,0,0,1,1,0,1],[0,1,0,0,1,1,1],[1,1,1,0,0,1,0]],
        [[0,0,1,1,0,0,1],[0,1,1,0,0,1,1],[1,1,0,0,1,1,0]],
        [[0,0,1,0,0,1,1],[0,0,1,1,0,1,1],[1,1,0,1,1,0,0]],
        [[0,1,1,1,1,0,1],[0,1,0,0,0,0,1],[1,0,0,0,0,1,0]],
        [[0,1,0,0,0,1,1],[0,0,1,1,1,0,1],[1,0,1,1,1,0,0]],
        [[0,1,1,0,0,0,1],[0,1,1,1,0,0,1],[1,0,0,1,1,1,0]],
        [[0,1,0,1,1,1,1],[0,0,0,0,1,0,1],[1,0,1,0,0,0,0]],
        [[0,1,1,1,0,1,1],[0,0,1,0,0,0,1],[1,0,0,0,1,0,0]],
        [[0,1,1,0,1,1,1],[0,0,0,1,0,0,1],[1,0,0,1,0,0,0]],
        [[0,0,0,1,0,1,1],[0,0,1,0,1,1,1],[1,1,1,0,1,0,0]]]
    let guardBar: [[Int]] = [[1,0,1],[0,1,0,1,0]]
    let readingDigit: [[Int]] = [[0,0,0,0,0,0],
                                 [0,0,1,0,1,1],
                                 [0,0,1,1,0,1],
                                 [0,0,1,1,1,0],
                                 [0,1,0,0,1,1],
                                 [0,1,1,0,0,1],
                                 [0,1,1,1,0,0],
                                 [0,1,0,1,0,1],
                                 [0,1,0,1,1,0],
                                 [0,1,1,0,1,0]]
    func makeBarcod() {
        let start = Code.startIndex
        CodeStart = String(Code[start])
        CodeLeft = String(Code[Code.index(start, offsetBy: 1)...Code.index(start, offsetBy: 6)])
        CodeRight = String(Code[Code.index(start, offsetBy: 7)...])
        var outputLeft: [Int] = []
        var outputRight: [Int] = []
        do {
            var i: Int = 0
            for char in CodeLeft {
                let RD: [Int] = readingDigit[Int(String(CodeStart))!]
                outputLeft += component[Int(String(describing: char))!][RD[i]]
                i += 1
            }
            for char in CodeRight {
                outputRight +=  component[Int(String(describing: char))!][2]
            }
        }
        output = guardBar[0] + outputLeft + guardBar[1] + outputRight + guardBar[0]
    }
    func ChangeBarcode(){
        var CheckDigit: Int = 0
        let ConstantCode = String(Code[...Code.index(Code.startIndex, offsetBy: 7)])
        let NewCode = ConstantCode+"1000"
        var i:Int = 0
        for char in (NewCode){
            if i%2 == 0 {
                CheckDigit += Int(String(describing: char))!
            } else {
                CheckDigit += Int(String(describing: char))!*3
            }
            i += 1
        }
        let LastNumber: String
        if CheckDigit%10 == 0 {
            LastNumber = "0"
        } else {
            LastNumber = String(CheckDigit%10)
        }
        Code = NewCode + LastNumber
    }
}

let makingBarcode = MakingBarcode()
