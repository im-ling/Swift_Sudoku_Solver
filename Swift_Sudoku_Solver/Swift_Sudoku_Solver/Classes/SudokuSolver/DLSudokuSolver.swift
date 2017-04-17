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
    
    //MARK: lazyLoad
    
    var isUnavailableMap = false
    
    /// 解得的个数，默认为1
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
    
    
    /// 优化的结果
    fileprivate lazy var optimizedMap: [[DLElementNumber]] = {
        var tempTwoDimensionalArray = [[DLElementNumber]]()
        for i in 0..<9{
            var tempArray = [DLElementNumber]()
            for j in 0..<9{
                let tempNumber = DLElementNumber()
                tempNumber.x = i
                tempNumber.y = j
                tempArray.append(tempNumber)
            }
            tempTwoDimensionalArray.append(tempArray)
        }
        return tempTwoDimensionalArray
    }()
    
    
    /// 优化完仍旧不确定的数组
    fileprivate lazy var uncertainElementArray: [DLElementNumber] = [DLElementNumber]()
    
    
    /// 结果Map
    lazy var resultMap: [[[Int]]] = [[[Int]]]()

    
    //MARK: Solve puzzle (Main)
    /// 解数数独
    func solveSudoku() -> (){
        
        
        clean();        //重置

        
        
        setOriginMapToOptimizedMap();       //1.将originMap转化为optimizedMap
        
        if checkMap() == false{
            isUnavailableMap = true
            print("Impossible Map")
            return
        }
        
        
        optimizedMapOptimizing();   //optimizedMap优化
        
        
        
        optimizedMapToUncertainElementArray()   //将优化后仍旧不确定的放入一个Array
        
        
        if uncertainElementArray.count == 0 {
            optimizedMapToResultMap();
            isUnavailableMap = false
            return
        }

        
        for i in 0..<uncertainElementArray[0].availableNumber.count {
//                            print(" --- ")
//                            printElementArray(two_DimensionalArray: optimizedMap)
            solveProblem(currentIndex: 0, currentAvailableNumberIndex: i)
        }
        
        //遍历所有情况无解
        if resultMap.count == 0 {
            print("Impossible Map")
            isUnavailableMap = true
        }else{
            isUnavailableMap = false
        }
    }
}


extension DLSudokuSolver{
    
    // MARK: 0. 重置(Reset)
    fileprivate func clean(){
        
        //clean optimizedMap
        for oneLine in optimizedMap {
            for element in oneLine {
                element.fillNubmer = 0
                element.availableNumber.removeAll()
                for i in 1...9 {
                    element.availableNumber.append(i)
                }
            }
        }
        
        //clean uncertainElementArray
        uncertainElementArray.removeAll()
        
        //clean resultMap
        resultMap.removeAll()
    }
    
    // MARK: 1.将originMap转化为optimizedMap
    /// 将originMap变换为OptimizedMap
    fileprivate func setOriginMapToOptimizedMap(){
        for i in 0..<originMap.count {
            for j in 0..<originMap[i].count {
                if originMap[i][j] != 0 {
                    //                    optimizedMap[i][j].fillNubmer = optimizedMap[i][j]
                    fillANumber(elementNumber: optimizedMap[i][j], number: originMap[i][j])
                }
            }
        }
    }
    
    
    //MARK: 1.1填一个数字，填数字是，将该数子所在位置上，横竖宫内其他元素划除该数字的可能性
    
    /// 填一个数字
    /// 填一个数字，其他元素进行检查
    /// - Parameters:
    ///   - elementNumber: 要填的元素
    ///   - number: 要填的数字
    fileprivate func fillANumber(elementNumber:DLElementNumber,number:Int){
        
        if elementNumber.fillNubmer != 0 {
            elementNumber.availableNumber.removeAll()
            return
        }
        
        //        print("x:\(elementNumber.x + 1), y: \(elementNumber.y + 1),number:\(number)")
        
        elementNumber.fillNubmer = number
        //        optimizedMap[elementNumber.x][elementNumber.y].fillNubmer = number
        
        elementNumber.availableNumber.removeAll()
        
        var theCheckingNumber: DLElementNumber = elementNumber
        
        for i in 0..<9 {
            
            theCheckingNumber = optimizedMap[elementNumber.x][i]
            if let tempIndex = theCheckingNumber.availableNumber.index(of: number){
                //                if theCheckingNumber.x == 3 && theCheckingNumber.y == 3 {
                //                    print(" ")
                //                    print("element:(\(elementNumber.x),\(elementNumber.y)),number:\(number)")
                //                    print("TheCheckingNumber:(\(theCheckingNumber.x),\(theCheckingNumber.y)),number:\(number)")
                //                    print(" ")
                //
                //                }
                theCheckingNumber.availableNumber.remove(at:tempIndex)
            }
            
            theCheckingNumber = optimizedMap[i][elementNumber.y]
            if let tempIndex = theCheckingNumber.availableNumber.index(of: number) {
                //                if theCheckingNumber.x == 3 && theCheckingNumber.y == 3 {
                //                    print("elementX:(\(elementNumber.x),\(elementNumber.y)),number:\(number)")
                //                }
                theCheckingNumber.availableNumber.remove(at: tempIndex)
            }
        }
        
        let x = elementNumber.x / 3
        let y = elementNumber.y / 3
        for i in 0..<3 {
            for j in 0..<3 {
                theCheckingNumber = optimizedMap[x * 3 + i][y * 3 + j]
                if let tempIndex = theCheckingNumber.availableNumber.index(of: number) {
                    theCheckingNumber.availableNumber.remove(at: tempIndex)
                }
            }
        }
    }

    
    
    
    //MARK: 2.optimize 优化
    /// 优化optimizedMap
    fileprivate func optimizedMapOptimizing(){
        var flag = true
        while flag {
            while flag {
                flag = optimizeOnce()   //检查所有元素，利用空白处可填数字仅有一个时，填数字
            }
            
            //            print(" ")
            //            printElementArray(two_DimensionalArray: optimizedMap)
            //            print(" ")
            
            flag = optimizeOnceByAnotherSide()      //当一个宫（3*3）的格子内仅有一个元素可以填某个数字时，填数字
            //            print("flag = \(flag)")
        }
    }
    
    

    
    
    //MARK: 3.1 空白检查
    /// 检查所有元素，利用空白处可填数字仅有一个时，填数字
    ///
    /// - Returns: 填数字没有
    fileprivate func optimizeOnce() -> Bool{
        var flag = false
        for numberArray in optimizedMap {
            for elementNumber in numberArray {
                if elementNumber.fillNubmer == 0 &&  elementNumber.availableNumber.count == 1{
                    fillANumber(elementNumber: elementNumber, number: elementNumber.availableNumber.first!)
                    flag = true
                }
            }
        }
        return flag
    }

    //MARK: 3.2 宫(3*3小格)检查
    /// 当一个宫（3*3）的格子内仅有一个元素可以填某个数字时，填数字
    ///
    /// - Returns: 填数字没有
    fileprivate func optimizeOnceByAnotherSide() -> Bool{
        var flag = false
        for indexI in 0..<3 {
            for IndexJ in 0..<3 {
                for tempNumber in 1...9{
                    
                    var count = 0
                    var elementNumber:DLElementNumber?
                    var number = 0
                    
                    for i in 0..<3 {
                        for j in 0..<3 {
                            //                            if indexI == 0 && IndexJ == 1 && tempNumber == 7 {
                            //                                print("indexI:\(indexI)   indexj:\(IndexJ) count:\(count) i:\(i) j:\(j)")
                            //                            }
                            if optimizedMap[indexI * 3 + i][IndexJ * 3 + j].availableNumber.contains(tempNumber) {
                                //                                print("element:(\(optimizedMap[indexI * 3 + i][IndexJ * 3 + j].x),\(optimizedMap[indexI * 3 + i][IndexJ * 3 + j].y)) contain:\(tempNumber)")
                                count += 1
                                elementNumber = optimizedMap[indexI * 3 + i][IndexJ * 3 + j]
                                number = tempNumber
                            }
                        }
                    }
                    if count == 1 {
                        //                        print("elementNumber:(\(elementNumber?.x ?? -1),\(elementNumber?.y ?? -1)) number:\(number)")
                        fillANumber(elementNumber: elementNumber!, number: number)
                        flag = true
                    }
                    
                }
            }
        }
        return flag
    }

    
    
    //MARK: 3. optimizedMap中不确定的元素并到一个一维数组(uncertainElementArray)中
    /// 将优化后的optimizedMap中不确定的元素并到一个一维数组中
    fileprivate func optimizedMapToUncertainElementArray(){
        for array in optimizedMap {
            for element in array {
                if element.fillNubmer == 0 {
                    //                    print("(x:\(element.x),y:\(element.y))", terminator:" ")
                    uncertainElementArray.append(element)
                }
            }
            //            print(" ")
        }
    }
    
    
    //MARK: 4.遍历求解数独,将结果输出到resultMap
    
    /// 解问题
    ///
    /// - Parameters:
    ///   - currentIndex: 当前还没有填的数字
    ///   - currentAvailableNumberIndex: 当前没有填，准备填的数字
    fileprivate func solveProblem(currentIndex: Int , currentAvailableNumberIndex: Int){
        if resultMap.count >= maxResultCount {
            return
        }
        
        uncertainElementArray[currentIndex].fillNubmer = uncertainElementArray[currentIndex].availableNumber[currentAvailableNumberIndex];
        //        print("currentIndex:\(currentIndex),currentAvailalbeNumberIndex:\(currentAvailableNumberIndex)")
        //        print("element:(\(uncertainElementArray[currentIndex].x),\(uncertainElementArray[currentIndex].y)), number:\(uncertainElementArray[currentIndex].availableNumber[currentAvailableNumberIndex])")
        
        if !checkMap() {
            uncertainElementArray[currentIndex].fillNubmer = 0
            return
        }
        //        print(" ")
        
        
        //MARK: 找到答案，输出到resultMap
        if currentIndex == uncertainElementArray.count - 1{
//            print("I am here------------------")
//            printElementArray(two_DimensionalArray: optimizedMap)
            optimizedMapToResultMap()
            return
        }
        
        
        
        for i in 0..<uncertainElementArray[currentIndex + 1].availableNumber.count {
            solveProblem(currentIndex: currentIndex + 1, currentAvailableNumberIndex: i)
        }
        uncertainElementArray[currentIndex].fillNubmer = 0
        //        print("-------------------------- currentIndex:\(currentIndex),currentAvailableIndex:\(currentAvailableNumberIndex)")
        
    }
    
    fileprivate func optimizedMapToResultMap(){
        var tempTwoDimensionArray: [[Int]] = [[Int]]()
        for oneLine in optimizedMap {
            var tempArray: [Int] = [Int]()
            for element in oneLine{
                tempArray.append(element.fillNubmer)
            }
            tempTwoDimensionArray.append(tempArray)
        }
        resultMap.append(tempTwoDimensionArray)
    }
    
    
    //MARK: 4.1检查函数
    
    /// 检查当前填充的数字是否有问题
    ///
    /// - Returns: 可行，返回true，不可行，返回false
    fileprivate func checkMap() -> Bool{
        //        var flag = true
        
        for number in 1...9 {
            //行列检查
            for i in 0..<9{
                var countLine = 0
                var countRow = 0
                for j in 0..<9 {
                    if optimizedMap[i][j].fillNubmer == number {
                        countLine += 1
                    }
                    if optimizedMap[j][i].fillNubmer == number {
                        countRow += 1
                    }
                }
                if countRow > 1 || countLine > 1 {
                    return false
                }
            }
            
            //宫检查(3*3小格)
            for i in 0..<3{
                for j in 0..<3 {
                    var count = 0
                    for k in 0..<9 {
                        if optimizedMap[i * 3 + k / 3][j * 3 + k % 3].fillNubmer == number {
                            count += 1
                        }
                    }
                    if count > 1 {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    

    
    
    
    
    
    
    
}

// MARK: 打印相关函数
extension DLSudokuSolver{
    
    func printResultMap(){
        for (i,twoDimensionArray) in resultMap.enumerated() {
            print("Result \(i + 1):")
            printTwoDimensionalArray(two_DimensionalArray: twoDimensionArray)
            print(" ")
        }
    }
    
    func printOriginMap(){
        printTwoDimensionalArray(two_DimensionalArray: originMap)
    }
    
    /// 打印二维数组，数组元素为int
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
    
    /// 打印二维数组，数组元素为DLElementNumber
    ///
    /// - Parameter two_DimensionalArray: 二维数组
    fileprivate func printElementArray(two_DimensionalArray:[[DLElementNumber]]){
        for one_DimensionArray in two_DimensionalArray {
            for item in one_DimensionArray {
                print("\(item.fillNubmer)", terminator:" ")
            }
            print(" ")
        }
    }
}
