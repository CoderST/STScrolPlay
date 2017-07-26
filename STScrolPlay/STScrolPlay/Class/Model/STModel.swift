//
//  STModel.swift
//  STPlayerExample
//
//  Created by xiudou on 2017/7/26.
//  Copyright © 2017年 CoderST. All rights reserved.
//

import UIKit

class STModel: NSObject {

    var urlString : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override init() {
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
