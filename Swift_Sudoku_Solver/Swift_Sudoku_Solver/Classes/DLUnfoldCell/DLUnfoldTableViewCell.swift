//
//  DLUnfoldTableViewCell.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 24/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

class DLUnfoldTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        backgroundColor = UIColor.clear
        textLabel?.textColor = UIColor.white
        
        let line = UIView()
        line.backgroundColor = UIColor.white
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1.0)
            make.left.equalTo(contentView).offset(margin)
            make.right.equalTo(contentView).offset(-margin)
            make.top.equalTo(contentView)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
