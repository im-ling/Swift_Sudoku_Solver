//
//  PurchaseView.swift
//  Swift_Sudoku_Solver
//
//  Created by ling on 2023/2/9.
//  Copyright © 2023 Focus. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class PurchaseViewController: UIViewController {
    
    var purchaseOnceBtn = UIButton.init()
    var becomeVipBtn = UIButton.init()
    var restoreBtn = UIButton.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() -> Void {
        
        let label = UILabel.titleLabel()
        navigationItem.titleView = label

        label.text = "titlePurchased".localizedString()
        label.sizeToFit()
        var backgroundImage = UIImage(named: "iphonetall-background-x13")!
        backgroundImage = backgroundImage.imageResize(sizeChange: CGSize.init(width: view.size.width, height: view.size.height))
        view.backgroundColor = UIColor(patternImage: backgroundImage)
    }
    
    func createBtnWith(title: String ,target: Any?, action:Selector) -> UIButton {
        let btn = UIButton.init(title: title, target: target, action: action)
        return btn
    }
    
    @objc func purchaseOnce() -> Void {
        
    }
    
    @objc func purchaseVip() -> Void {
        
    }
    
    @objc func restore() -> Void {
        Task.init {
            try? await AppStore.sync()
        }
    }
}
