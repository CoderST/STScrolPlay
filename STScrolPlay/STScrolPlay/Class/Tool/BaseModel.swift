//
//  BaseModel.swift
//  DYZB
//
//  Created by xiudou on 2017/7/4.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

}
