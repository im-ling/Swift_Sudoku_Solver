//
//  AccountInfo.swift
//  Swift_Sudoku_Solver
//
//  Created by ling on 2023/2/9.
//  Copyright © 2023 Focus. All rights reserved.
//

import Foundation

let is_vip_key:String = "Swift_Sudoku_Solver_is_vip_key"
let count_left_key = "Swift_Sudoku_Solver_count_left_key"
let is_not_first_key = "Swift_Sudoku_Solver_is_not_first_key"

class AccountInfo {
    public static let shared = AccountInfo()
    public var isVip = false
    public var solveCountLeft = 0;
    public var isNotFirst = false
    private init() {}
    
    public func start() {
        readProperties()
        if (!isNotFirst) {
            // 第一次
            self.solveCountLeft = 10
            isNotFirst = true
        }
        saveProperties()
        description()
    }
    
    public func readProperties (){
        self.isVip = UserDefaults.standard.bool(forKey: is_vip_key)
        self.solveCountLeft = UserDefaults.standard.integer(forKey: count_left_key)
        self.isNotFirst = UserDefaults.standard.bool(forKey: is_not_first_key)
    }
    
    public func saveProperties (){
        UserDefaults.standard.set(true, forKey: is_not_first_key)
        UserDefaults.standard.set(self.solveCountLeft, forKey: count_left_key)
        UserDefaults.standard.set(self.isVip, forKey: is_vip_key)
    }
    
    public func description(){
        print("isVip:\(self.isVip)")
        print("countLeft:\(self.solveCountLeft)")
        print("isFirst:\(!self.isNotFirst)")
    }
}
