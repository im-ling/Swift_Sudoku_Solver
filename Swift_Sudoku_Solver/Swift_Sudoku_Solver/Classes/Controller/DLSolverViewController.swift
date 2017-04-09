//
//  DLSolverViewController.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 09/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit
import SnapKit

class DLSolverViewController: UIViewController {
    //MARK: LAZY LOAD
    
    fileprivate var tipAlertViewController:UIAlertController?
    
    fileprivate var isSolving:Bool = false
    
    fileprivate var currentNumber = 0
    var puzzleMap: [[Int]] = [[9,0,0, 5,0,0, 0,0,0],
                              [0,0,0, 0,0,0, 1,0,7],
                              [0,0,0, 2,0,0, 0,0,0],
                              
                              [2,9,0, 0,0,0, 3,0,0],
                              [4,0,0, 0,0,2, 0,6,0],
                              [0,0,5, 0,0,3, 0,7,9],
                              
                              [0,0,0, 7,0,0, 5,0,0],
                              [0,3,6, 9,0,0, 0,0,0],
                              [0,0,2, 3,0,1, 0,4,0]]
    
    var toughMap: [[Int]] = [[2,0,0, 6,0,0, 0,0,0],
                             [0,0,0, 0,5,0, 9,3,0],
                             [0,0,0, 0,0,0, 2,7,8],
                             
                             [0,0,0, 0,0,0, 0,0,0],
                             [0,1,0, 0,0,0, 5,9,0],
                             [9,0,8, 0,0,0, 6,1,7],
                             
                             [0,0,0, 1,0,0, 0,0,5],
                             [0,0,3, 0,0,2, 0,6,0],
                             [0,0,9, 8,0,6, 1,0,0]]
    
    fileprivate lazy var cageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "normal-cage-x20"))
        imageView.isUserInteractionEnabled = true
        //        imageView.layer.borderWidth = 2
        //        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate lazy var buttonMap: [[DLNumberButton]] = {
        var tempMap = [[DLNumberButton]]()
        for i in 0..<9{
            var tempArray: [DLNumberButton] = [DLNumberButton]()
            for j in 0..<9{
                let button = DLNumberButton()
                tempArray.append(button)
                button.addTarget(self, action: #selector(numberButtonClick(numberBtn:)), for: .touchUpInside)
            }
            tempMap.append(tempArray)
        }
        return tempMap
    }()
    
    @objc fileprivate func numberButtonClick(numberBtn: DLNumberButton){
        numberBtn.number = currentNumber
    }
    
    fileprivate lazy var bottomButtonArray:[DLNumberButton] = {
        var tempArray = [DLNumberButton]()
        for i in 1...9{
            let button = DLNumberButton()
            button.number = i
            button.addTarget(self, action: #selector(bottomButtonClick(bottomBtn:)), for: .touchUpInside)
            tempArray.append(button)
        }
        return tempArray
    }()
    
    @objc fileprivate func bottomButtonClick(bottomBtn:DLNumberButton){
        if lastBottomBtn == bottomBtn {
            return
        }
        lastBottomBtn?.layer.borderWidth = 0
        currentNumber = bottomBtn.number
        bottomBtn.layer.borderWidth = 2
        bottomBtn.layer.borderColor = UIColor.white.cgColor
        lastBottomBtn = bottomBtn
    }
    
    fileprivate var lastBottomBtn: DLNumberButton?
    
    fileprivate lazy var solveButton:UIButton = {
        let buttton = UIButton()
        buttton.layer.cornerRadius = 8.0
        buttton.layer.masksToBounds = true
        buttton.setBackgroundImage(UIImage(named:"iphonetall-background-wood-x10"), for: .normal)
        buttton.setTitle("Solve", for: .normal)
        buttton.addTarget(self, action: #selector(solvePuzzle), for: .touchUpInside)
        return buttton
    }()
    
    fileprivate lazy var eraserButton:UIButton = {
        let buttton = DLNumberButton()
        buttton.layer.cornerRadius = 8.0
        buttton.layer.masksToBounds = true
        buttton.setBackgroundImage(UIImage(named:"iphonetall-background-wood-x10"), for: .normal)
        buttton.setTitle("Earser", for: .normal)
        buttton.addTarget(self, action: #selector(bottomButtonClick(bottomBtn:)), for: .touchUpInside)
        return buttton
        
    }()
    
    fileprivate lazy var cleanButton:UIButton = {
        let buttton = UIButton()
        buttton.layer.cornerRadius = 8.0
        buttton.layer.masksToBounds = true
        buttton.setBackgroundImage(UIImage(named:"iphonetall-background-wood-x10"), for: .normal)
        buttton.setTitle("Clear", for: .normal)
        buttton.addTarget(self, action: #selector(cleanButtonClick), for: .touchUpInside)
        return buttton
    }()
    
    @objc fileprivate func cleanButtonClick(){
        for oneline in buttonMap {
            for element in oneline {
                element.number = 0
            }
        }
    }
    
    fileprivate lazy var checkButton:UIButton = {
        let buttton = UIButton()
        buttton.layer.cornerRadius = 8.0
        buttton.layer.masksToBounds = true
        buttton.setBackgroundImage(UIImage(named:"iphonetall-background-wood-x10"), for: .normal)
        buttton.setTitle("Check", for: .normal)
        buttton.addTarget(self, action: #selector(checkPuzzle), for: .touchUpInside)
        return buttton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: UI搭建
    fileprivate func setupUI(){
        setupNav()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "iphonetall-background-x13")!)
        
        view.addSubview(cageView)
        cageView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.size.equalTo(CGSize(width: ScreenWidth , height: ScreenWidth ))
        }
        
        view.layoutIfNeeded()
        
        addButtonMap(smallMargin:cageView.width / 200 , largeMargin:cageView.width * 0.02, targetView:cageView)
        
        
        
        let bottomButtonArrayView = UIView()
        view.addSubview(bottomButtonArrayView)
        
        let bottomMargin: CGFloat = 3.0
        let itemWidth = (ScreenWidth - bottomMargin * 10.0) / 9.0
        
        bottomButtonArrayView.snp.makeConstraints { (make) in
            make.top.equalTo(cageView.snp.bottom).offset(50)
            make.left.right.equalTo(view)
            make.height.equalTo(itemWidth)
        }
        view.layoutIfNeeded()
        
        for (i,btn) in bottomButtonArray.enumerated() {
            bottomButtonArrayView.addSubview(btn)
            btn.size = CGSize(width: itemWidth, height: itemWidth)
            btn.x = (bottomMargin + itemWidth) * CGFloat(i) + bottomMargin
            btn.y = 0
        }
        
        
        let funcButtonSize = CGSize(width: cageView.width * 0.2, height: cageView.width * 0.1)
        let margin = 10.0
        
        view.addSubview(solveButton)
        solveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomButtonArrayView.snp.top).offset(-margin)
            make.right.equalTo(view).offset(-margin)
            make.size.equalTo(funcButtonSize)
        }
        
        view.addSubview(checkButton)
        checkButton.snp.makeConstraints { (make) in
            make.size.equalTo(funcButtonSize)
            make.right.equalTo(solveButton.snp.left).offset(-margin)
            make.centerY.equalTo(solveButton)
        }
        
        
        view.addSubview(eraserButton)
        eraserButton.snp.makeConstraints { (make) in
            make.size.equalTo(funcButtonSize)
            make.right.equalTo(checkButton.snp.left).offset(-margin)
            make.centerY.equalTo(solveButton)
        }
        
        view.addSubview(cleanButton)
        cleanButton.snp.makeConstraints { (make) in
            make.size.equalTo(funcButtonSize)
            make.bottom.equalTo(cageView.snp.top).offset(-margin * 1.5)
            make.right.equalTo(cageView).offset(-margin)
        }
        
        
        numberMapToButtonMap(numberMap: puzzleMap,buttonMap: buttonMap)
        
    }
    
    
    
    
    fileprivate func addButtonMap(smallMargin:CGFloat , largeMargin: CGFloat, targetView:UIView){
        let offsetX: CGFloat = targetView.width * 0.05
        let offsetY: CGFloat = offsetX
        
        let itemWidth = (targetView.width - offsetX * 2.0 - 8.0 * smallMargin - 2 * largeMargin) / 9.0
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        for (i,oneLine) in buttonMap.enumerated() {
            for (j,button) in oneLine.enumerated() {
                targetView.addSubview(button)
                button.size = itemSize
                button.x = offsetX + (itemWidth + smallMargin) * CGFloat(j) + CGFloat(j / 3) * largeMargin
                button.y = offsetY + (itemWidth + smallMargin) * CGFloat(i) + CGFloat(i / 3) * largeMargin
            }
        }
    }
    
    
    fileprivate func setupNav(){
        //        self.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        title = "Sudoku Solver"
    }
    
    
}


extension DLSolverViewController{
    
}


//数据相关
extension DLSolverViewController{
    
    fileprivate func numberMapToButtonMap(numberMap:[[Int]],buttonMap:[[DLNumberButton]]){
        for i in 0..<9 {
            for j in 0..<9 {
                buttonMap[i][j].number = numberMap[i][j]
            }
        }
    }
    
    fileprivate func buttonMapToNumberMap(buttonMap:[[DLNumberButton]]) -> ([[Int]]){
        var numberMap:[[Int]] = [[Int]]()
        for i in 0..<9{
            var tempNumberArray = [Int]()
            for j in 0..<9 {
                tempNumberArray.append(buttonMap[i][j].number)
            }
            numberMap.append(tempNumberArray)
        }
        return numberMap
    }
    
    @objc fileprivate func solvePuzzle(){
        if isSolving {
            tipAlertViewController = UIAlertController(title: "Solving~", message: "The puzzle is solving,please wait a moment~", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay~", style: .cancel, handler: nil)
            tipAlertViewController?.addAction(cancelAction)
            self.present(tipAlertViewController!, animated: true, completion: nil)
            return
        }
        
        isSolving = true
        DispatchQueue.global().async {
            DLSudokuSolver.sharedSudokuSolver.originMap = self.buttonMapToNumberMap(buttonMap: self.buttonMap)
            DLSudokuSolver.sharedSudokuSolver.maxResultCount = 1
            DLSudokuSolver.sharedSudokuSolver.printOriginMap()
            print(" ")
            DLSudokuSolver.sharedSudokuSolver.solveSudoku()
            DispatchQueue.main.async {
                self.isSolving = false
                if DLSudokuSolver.sharedSudokuSolver.isUnavailableMap{
                    if let alertVc = self.tipAlertViewController{
                        alertVc.dismiss(animated: true, completion: nil)
                    }
                    
                    self.tipAlertViewController = UIAlertController(title: "Opps~", message: "The map can't be solve,please try another one~", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Okay~", style: .cancel, handler: nil)
                    self.tipAlertViewController?.addAction(cancelAction)
                    self.present(self.tipAlertViewController!, animated: true, completion: nil)
                }else{
                    self.numberMapToButtonMap(numberMap: DLSudokuSolver.sharedSudokuSolver.resultMap.first!, buttonMap: self.buttonMap)
                }
            }
        }
    }
    @objc fileprivate func checkPuzzle(){
        if isSolving {
            tipAlertViewController = UIAlertController(title: "Solving~", message: "The puzzle is solving,please wait a moment~", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay~", style: .cancel, handler: nil)
            tipAlertViewController?.addAction(cancelAction)
            self.present(tipAlertViewController!, animated: true, completion: nil)
            return
        }
        isSolving = true
        DispatchQueue.global().async {
            DLSudokuSolver.sharedSudokuSolver.originMap = self.buttonMapToNumberMap(buttonMap: self.buttonMap)
            DLSudokuSolver.sharedSudokuSolver.maxResultCount = 2
            print(" ")
            DLSudokuSolver.sharedSudokuSolver.printOriginMap()
            DLSudokuSolver.sharedSudokuSolver.solveSudoku()
            DispatchQueue.main.async {
                if self.tipAlertViewController != nil{
                    self.tipAlertViewController?.dismiss(animated: true, completion: nil)
                }
                
                self.tipAlertViewController = UIAlertController(title: "Opps~", message: "The map can't be solve,please try another one~", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Okay~", style: .cancel, handler: nil)
                self.tipAlertViewController?.addAction(cancelAction)
                if DLSudokuSolver.sharedSudokuSolver.isUnavailableMap{
                }else{
                    if DLSudokuSolver.sharedSudokuSolver.resultMap.count == 1{
                        self.tipAlertViewController?.title = "Tips:"
                        self.tipAlertViewController?.message = "This is normal puzzle."
                    }else{
                        self.tipAlertViewController?.title = "Tips:"
                        self.tipAlertViewController?.message = "There are multi-results for the puzzle."
                    }
                }
                self.isSolving = false
                self.present(self.tipAlertViewController!, animated: true, completion: nil)
            }
        }
        
    }
}
