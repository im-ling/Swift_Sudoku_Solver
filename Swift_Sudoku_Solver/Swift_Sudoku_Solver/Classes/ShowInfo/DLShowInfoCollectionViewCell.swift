//
//  DLShowInfoCollectionViewCell.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 22/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit
import SnapKit

let margin = 10

class DLShowInfoCollectionViewCell: UICollectionViewCell {
    var imageWidthConstraint:Constraint?
    var textContextLeftConstraint:Constraint?
    
    var cellModel:DLShowInfoModel?{
        didSet{
            modelImageView.image = UIImage(named: (cellModel?.imageName)!)
            modelTextContext.text = cellModel?.textContext
        }
    }
    fileprivate lazy var modelImageView:UIImageView = UIImageView()
    fileprivate lazy var modelTextContext:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        contentView.addSubview(modelTextContext)
        modelTextContext.snp.makeConstraints { (make) in
            textContextLeftConstraint = make.left.equalTo(contentView).constraint
            make.top.equalTo(contentView).offset(margin)
        }

        contentView.addSubview(modelImageView)
        modelImageView.snp.makeConstraints { (make) in
            make.top.equalTo(modelTextContext.snp.bottom).offset(margin)
            imageWidthConstraint = make.width.equalTo(contentView).constraint
            make.bottom.equalTo(contentView).offset(-margin * 2)
            make.centerX.equalTo(contentView)
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        imageWidthConstraint?.deactivate()
        let image = UIImage(named: (cellModel?.imageName ?? ""))
        modelImageView.snp.makeConstraints { (make) in
           imageWidthConstraint = make.width.equalTo((contentView.height - modelTextContext.height - 5) / (image?.size.height)! * (image?.size.width)!).constraint
        }
        
        textContextLeftConstraint?.deactivate()
        modelTextContext.snp.makeConstraints { (make) in
            make.left.equalTo(modelImageView)
        }
    }

}
