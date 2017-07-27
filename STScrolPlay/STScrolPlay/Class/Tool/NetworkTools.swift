//
//  NetworkTools.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import Alamofire
enum MethodType {
    case get
    case post
}
class NetworkTools {

    class func requestData(_ type : MethodType,URLString : String,parameters:[String : Any]? = nil,finishCallBack : @escaping (_ result : Any) -> ()){
        // 确定请求类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 发送网络请求
       Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
        if let url =  response.request?.url{
            print("请求的URL = \(url)")
        }
        // 守护结果
        guard let result = response.result.value else{
            return
        }
        
        finishCallBack(result: result)
        
        }
        
    }
    
}
