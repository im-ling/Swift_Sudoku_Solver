//
//  DLUnfoldTableViewHeaderFooterView.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 24/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit


class DLUnfoldTableViewHeaderFooterView: UITableViewHeaderFooterView {

    private let margin = 12.0
    
    var model:DLUnfoldGroupModel?{
        didSet{
            modelTextLabel.text = model?.name
            if (model?.isSelected)! {
                indicator.image = UIImage(named:"arrowUp")
            }else{
                indicator.image = UIImage(named: "arrowDown")
            }
        }
    }
    
    fileprivate lazy var modelTextLabel:UILabel = {
        let label = UILabel()
        label.text = "label"
        label.textColor = UIColor.white
        return label
    }()
    
    fileprivate lazy var indicator:UIImageView = {
        let imageView = UIImageView(image: UIImage(named:"arrowDown"))
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    fileprivate func setupUI(){
//        backgroundColor = UIColor.clear
        backgroundView = UIView()
        contentView.backgroundColor = UIColor.clear

        contentView.addSubview(indicator)
        contentView.addSubview(modelTextLabel)
//        textLabel?.textColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-margin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 15, height: 10))
        }
        modelTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(margin)
            make.centerY.equalTo(contentView)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var block:(()->())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        model?.isSelected = !(model?.isSelected)!
        UIView.animate(withDuration: 0.5) {
            self.indicator.transform = self.indicator.transform.rotated(by: CGFloat(Double.pi))
        }
        block?()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
