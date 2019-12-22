//
//  DLUnfoldGroupModel.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 24/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

class DLUnfoldGroupModel: NSObject,Decodable {
    let name : String
    let details: String?
    let steps : [String]?

    var isSelected : Bool = false
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        details = try? values.decode(String.self, forKey: .details)
        steps = try values.decode([String].self, forKey: .steps)
    }

    enum CodingKeys: String, CodingKey {
        case name
        case details
        case steps
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }
}
