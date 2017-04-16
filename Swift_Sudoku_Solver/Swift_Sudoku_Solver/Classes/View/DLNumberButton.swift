//
//  DLNumberButton.swift
//  Swift_Sudoku_Slover
//
//  Created by NowOrNever on 06/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

class DLNumberButton: UIButton {
    
    var number:Int = 0 {
        didSet{
            if number >= 1 && number <= 9{
                UIView.animate(withDuration: 0.25, animations: {
                    self.setBackgroundImage(UIImage(named:"normal-tilette-\(self.number)-x20"), for: .normal)
                })
            }else if number == 0 {
                UIView.animate(withDuration: 0.25, animations: { 
                    self.setBackgroundImage(UIImage(named:"normal-shadow-x20"), for: .normal)
                })
            }else{
                number = oldValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    fileprivate func setupUI(){
        setBackgroundImage(UIImage(named:"normal-shadow-x20"), for: .normal)
//        backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
