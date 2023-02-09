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
import STSwiftIAP

class PurchaseViewController: UIViewController {
    
//    var purchaseOnceBtn = UIButton.init()
    var purchaseVipBtn = UIButton.init()
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

        purchaseVipBtn = DLFunctionButton(title: "Purchase VIP".localizedString(), target: self, action: #selector(purchaseVip))
        
        restoreBtn = DLFunctionButton(title: "Restore".localizedString(), target: self, action: #selector(restore))
        
        view.addSubview(purchaseVipBtn)
        view.addSubview(restoreBtn)
        
        let y_offset = 60.0
        purchaseVipBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-y_offset)
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.centerX.equalToSuperview()
        }
        
        restoreBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(y_offset)
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.centerX.equalToSuperview()
        }
    }
    
//    func createBtnWith(title: String ,target: Any?, action:Selector) -> UIButton {
//        let btn = UIButton.init(title: title, target: target, action: action)
//        btn.frame = CGRectMake(0, 0, 150, 50)
//        return btn
//    }
    
//    @objc func purchaseOnce() -> Void {
//
//    }
    
    @objc func purchaseVip() -> Void {
        if (AccountInfo.shared.isVip) {
            showErrorMessage(title: "Oppos~", message: "You are VIP, don't need to purchase again".localizedString())
        }
        Task.init {
            guard let product = STSwiftIAP.shared.product(from: product_id_vip) else {
                showErrorMessage(title: "Purchase".localizedString() + " VIP", message: "Purchase VIP Failed, Please check your netWork.".localizedString())
                return
            }
                
            do {
                let result = try await STSwiftIAP.shared.purchase(product)
                if result.purchaseState == .purchased {
                    AccountInfo.shared.isVip = true
                    AccountInfo.shared.saveProperties()
                }
                showErrorMessage(title: "Purchase".localizedString() + " VIP", message: "Purchase".localizedString() + " VIP " + result.purchaseState.shortDescription())
            } catch {
                showErrorMessage(title: "Purchase".localizedString() + " VIP", message: "Purchase".localizedString() + " VIP failed")
            }
        }
    }
    
    func showErrorMessage(title:String? , message:String?){
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Okay~", style: .cancel, handler: nil)
        alertVc.addAction(cancelAction)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    @objc func restore() -> Void {
        Task.init {
            try? await AppStore.sync()
            let result = await STSwiftIAP.shared.currentEntitlements()
            if (result.contains(product_id_vip)){
                AccountInfo.shared.isVip = true;
                AccountInfo.shared.saveProperties()
                showErrorMessage(title: "Restore Success".localizedString(), message: nil)
            }else{
                showErrorMessage(title: "Restore Failed".localizedString(), message: "No transaction Found".localizedString())
            }
        }
    }
    
    func showNoNetWorkErrorMessage() -> Void {
        showErrorMessage(title: "Purchase".localizedString() + " VIP", message: "Purchase VIP Failed, Please check your netWork.".localizedString())
    }
}
