//
//  DLSudokuSolver.swift
//  Sudoku_Solver_Demo
//
//  Created by NowOrNever on 07/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

class DLSudokuSolver: NSObject {

    static let sharedSudokuSolver: DLSudokuSolver = DLSudokuSolver()
    
    fileprivate override init() {
        super.init()
    }
    
    var isUnavailableMap = false
    
    /// the max amount of the result, default is 1,  解得的个数，默认为1
    var maxResultCount = 1
    
    /// puzzle 谜题
    var originMap: [[Int]] = [[9,0,0, 5,0,0, 0,0,0],
                              [0,0,0, 0,0,0, 1,0,7],
                              [0,0,0, 2,0,0, 0,0,0],
                              
                              [2,9,0, 0,0,0, 3,0,0],
                              [4,0,0, 0,0,2, 0,6,0],
                              [0,0,5, 0,0,3, 0,7,9],
                              
                              [0,0,0, 7,0,0, 5,0,0],
                              [0,3,6, 9,0,0, 0,0,0],
                              [0,0,2, 3,0,1, 0,4,0]]
    
    
    //MARK: lazyLoad

    /// result Map
    lazy var resultMap: [[[Int]]] = [[[Int]]]()
    
    
    
    //MARK: solution related variable
    
    // Each int is a 9-bit array
    lazy var Col = [Int]()
    lazy var Row = [Int]()
    lazy var Block = [Int]()
    
    let BLANK = 0;
    let ONES = 0x3fe // Binary 1111111110
    
    lazy var Entry = [[Int]]() // Records entries 1-9 in the grid
    
    lazy var Sequence = [[Int]]()
    lazy var seqPtr = 0

    func checkANumber(row:Int, col:Int, number:Int) -> Bool {
        originMap[row][col] = 0
        for i in 0..<9 {
            if originMap[row][i] == number || originMap[i][col] == number || originMap[row / 3 * 3 + i / 3][col / 3 * 3 + i % 3] == number {
                originMap[row][col] = number
                return false
            }
        }
        originMap[row][col] = number
        return true
    }
    
    func isValidSudoku() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if originMap[row][col] != 0  && !checkANumber(row: row, col: col, number: originMap[row][col]){
                    return false
                }
            }
        }
        return true
    }
    
    
    //MARK: Solve puzzle (Main)
    func SwapSeqEntries(S1: Int, S2:Int){
        let temp = Sequence[S2];
        Sequence[S2] = Sequence[S1];
        Sequence[S1] = temp;
    }
    
    func setAEntry(row: Int, col: Int, number:Int) -> (){
        Entry[row][col] = number
        let valbit_reverse = ~(1 << number)
//        print(String(Block[row / 3 * 3 + col / 3], radix: 2) + " " + String(Row[row], radix: 2) + " " + String(Col[col], radix: 2))
        Row[row] &= valbit_reverse
        Col[col] &= valbit_reverse
        Block[row / 3 * 3 + col / 3] &= valbit_reverse
//        print(String(Block[row / 3 * 3 + col / 3], radix: 2) + " " + String(Row[row], radix: 2) + " " + String(Col[col], radix: 2))

        SwapSeqEntries(S1: seqPtr, S2: row * 9 + col);
        seqPtr += 1
    }
    
    func NextSeq(S:Int) -> Int {
        var MinBitCount = 100;
        var seqPtr2 = S
        for seq in S..<Sequence.count {
            let Square = Sequence[seq];
            var BitCount = 0;
            var Possibles = Block[Square[0] / 3 * 3 + Square[1] / 3] & Row[Square[0]] & Col[Square[1]]
            while Possibles != 0 {
                Possibles &= ~(Possibles & -Possibles)
                BitCount += 1
            }

            if (BitCount < MinBitCount) {
               MinBitCount = BitCount;
               seqPtr2 = seq;
            }
        }
        return seqPtr2
    }

    
    func slove(S: Int) -> () {
        if resultMap.count >= maxResultCount {
            return
        }

        if S >= 81{
            printTwoDimensionalArray(two_DimensionalArray: Entry)
            resultMap.append(Entry)
            printResultMap()
            return
        }
        

        let seqPtr2 = NextSeq(S: S);
        SwapSeqEntries(S1: S, S2: seqPtr2);



        let Square = Sequence[S];
        var Possibles = Block[Square[0] / 3 * 3 + Square[1] / 3] & Row[Square[0]] & Col[Square[1]]

        while Possibles != 0 && resultMap.count < maxResultCount{
            let number = flsl(Possibles) - 1 // Highest 1 bit in Possibles
            let valbit = 1 << number

            Possibles &= ~valbit;

            Entry[Square[0]][Square[1]] = Int(number);
            Row[Square[0]] &= ~valbit
            Col[Square[1]] &= ~valbit
            Block[Square[0] / 3 * 3 + Square[1] / 3] &= ~valbit
            
            slove(S: S + 1);

            Entry[Square[0]][Square[1]] = BLANK;
            Row[Square[0]] |= valbit
            Col[Square[1]] |= valbit
            Block[Square[0] / 3 * 3 + Square[1] / 3] |= valbit
        }
        SwapSeqEntries(S1: S, S2: seqPtr2);
    }

    /// solve sudoku, 解数独
    func solveSudoku() -> (){
        isUnavailableMap = false
        if !isValidSudoku() {
            isUnavailableMap = true
            return
        }


        let sudokuSize = 9
        
        // initialize
        resultMap = [[[Int]]]()
        Sequence = [[Int]]()
        Entry = [[Int]]()
        seqPtr = 0
        Col = [Int]()
        Row = [Int]()
        Block = [Int]()
        
        for row in 0..<sudokuSize {
            var array = [Int]()
            for col in 0..<sudokuSize{
                array.append(BLANK)
                Sequence.append([Int].init(arrayLiteral: row, col))
            }
            Entry.append(array)
            Col.append(ONES)
            Row.append(ONES)
            Block.append(ONES)
        }
        
        for row in 0..<sudokuSize {
            for col in 0..<sudokuSize{
                if originMap[row][col] != 0 {
                    setAEntry(row: row, col: col, number: originMap[row][col])
                }
            }
        }
        
        slove(S: seqPtr)
    }
}



// MARK: the function related print 打印相关函数
extension DLSudokuSolver{
    
    func printResultMap(){
        for (i,twoDimensionArray) in resultMap.enumerated() {
            print("Result \(i + 1):")
            printTwoDimensionalArray(two_DimensionalArray: twoDimensionArray)
            print(" ")
        }
    }
    
    func printOriginMap(){
        printTwoDimensionalArrayWithSudokuFormat(two_DimensionalArray: originMap)
    }
    
    /// printTwoDimensionalArray, the element of the array is int 打印二维数组，数组元素为int
    ///
    /// - Parameter two_DimensionalArray: 二维数组
    func printTwoDimensionalArray(two_DimensionalArray:[[Int]]){
        for one_DimensionArray in two_DimensionalArray {
            for j in one_DimensionArray {
                print("\(j)",terminator:" ")
            }
            print(" ")
        }
    }
    
    func printTwoDimensionalArrayWithSudokuFormat(two_DimensionalArray:[[Int]]){
        for i in 0..<9 {
            for j in 0..<9 {
                var terminator = " "
                if j != 0 && j % 3 == 2 {
                    terminator = "  "
                }
                print("\(two_DimensionalArray[i][j])",terminator:terminator)
            }
            print("")
            if i != 0 && i % 3 == 2 {
                print("")
            }
        }
    }
}
