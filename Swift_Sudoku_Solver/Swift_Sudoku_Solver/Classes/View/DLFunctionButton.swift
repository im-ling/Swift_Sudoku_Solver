//
//  DLFunctionButton.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 14/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

class DLFunctionButton: UIButton {
    init(title:String,target:Any?,action:Selector) {
        self.init()
        setBackgroundImage(UIImage(named:"iphonetall-background-wood-x10"), for: .normal)
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        setTitle(title, for: .normal)
        addTarget(target, action:action, for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    convenience init(title:String,target:Any?,action:Selector){
//        self.init()
//        setBackgroundImage(UIImage(named:"iphonetall-background-wood-x10"), for: .normal)
//        layer.cornerRadius = 8.0
//        layer.masksToBounds = true
//        setTitle(title, for: .normal)
//        addTarget(target, action:action, for: .touchUpInside)
//    }


}
