//
//  DLShowInfoFlowLayout.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 22/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

class DLShowInfoFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = (collectionView?.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
    }
}
