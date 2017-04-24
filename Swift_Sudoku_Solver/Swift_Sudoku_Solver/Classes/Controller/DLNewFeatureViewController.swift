//
//  DLNewFeatureViewController.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 23/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

class DLNewFeatureViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        var imageName:String = "featureEN"
        if Locale.current.languageCode == "zh"{
            imageName = "featureCN"
        }
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.isUserInteractionEnabled = true
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupUI(){
        
        title = "title".localizedString()
        
        view.backgroundColor = infoBackGroundColor
        let collectionView = DLShowInfoCollectionView()
        collectionView.modelArray = models
        collectionView.backgroundColor = infoBackGroundColor
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(view.height * 0.85)
            make.width.equalTo(view.width * 0.85)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(view.height * 0.0)
        }
        
        let barButton = UIBarButtonItem(title: "skip".localizedString(), style: .plain, target: self, action: #selector(dismissClick))
        navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.colorWithHex(hex: 0xff5830)

//            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()

        let label = UILabel.titleLabel()
        label.textColor = UIColor.colorWithHex(hex: 0xff5830)
        navigationItem.titleView = label
//        let dismissButton = UIButton(title: "skip".localizedString(), target: self, action: #selector(dismissClick))
//        view.addSubview(dismissButton)
//        dismissButton.snp.makeConstraints { (make) in
//            make.right.equalTo(collectionView)
//            make.top.equalTo(collectionView.snp.bottom).offset( -10)
//            make.size.equalTo(CGSize(width: 60, height: 30))
//        }
        
        
    }
    
    func dismissClick(){
        self.dismiss(animated: true, completion: nil)
    }
//    
//    fileprivate func getPlistData() -> [DLCompose]{
//        let path = Bundle.main.path(forResource: "compose.plist", ofType: nil)!
//        let dicArray = NSArray(contentsOfFile: path) as! [[String : Any]]
//        let modelArray = NSArray.yy_modelArray(with: DLCompose.self, json: dicArray) as! [DLCompose]
//        return modelArray
//    }

    
    fileprivate lazy var models:[DLShowInfoModel] = {
        var models = [DLShowInfoModel]()
 
        var fileName:String = "DLNewFeatureEN.plist"
        if Locale.current.languageCode == "zh"{
            fileName = "DLNewFeatureCN.plist"
        }
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            return models;
        }
        
        let dictArray = NSArray(contentsOfFile: path) as! [[String:Any]]
        for dict in dictArray{
            let model = DLShowInfoModel()
            model.setValuesForKeys(dict)
            models.append(model)
        }
        return models
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
