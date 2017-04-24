//
//  DLShowInfoCollectionView.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 22/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit
private let reuseIdentifier = "Cell"
class DLShowInfoCollectionView: UICollectionView {
    
    var modelArray: [DLShowInfoModel] = [] {
        didSet{
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = DLShowInfoFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }
    
    fileprivate func setupUI(){
        register(DLShowInfoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        delegate = self;
        dataSource = self;

        isPagingEnabled = true;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension DLShowInfoCollectionView: UICollectionViewDelegate{
    
}

extension DLShowInfoCollectionView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    override var numberOfSections: Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DLShowInfoCollectionViewCell
        cell.cellModel = modelArray[indexPath.row]
        return cell
    }
}
