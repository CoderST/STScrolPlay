//
//  STConfiguration.swift
//  STPlayerExample
//
//  Created by xiudou on 2017/2/16.
//  Copyright © 2017年 CoderST. All rights reserved.
//  配置

import UIKit

class STConfiguration: NSObject {


    /// 播放的URL
    var playUrl: String = ""
    /// 播放视图
    var palyView: UIView?
    /// 是否需要缓存
    var isCache : Bool = false
    /// playerLayer 尺寸
    var playerLayerF : CGRect = CGRect.zero
    
}
