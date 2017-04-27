//
//  DLCommon.swift
//  Swift_Microblogging
//
//  Created by NowOrNever on 30/03/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

let infoBackGroundColor = UIColor.black

let functionButtonColorHexValue = 0x007aff
//0x007aff
//0x4869f6

let currentLanguage = Locale.current.languageCode

let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height

func RandomColor() -> UIColor {
    let red = CGFloat(arc4random_uniform(256)) / 255.0
    let green = CGFloat(arc4random_uniform(256)) / 255.0
    let blue = CGFloat(arc4random_uniform(256)) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

//class DLCommon: NSObject {
//
//}
