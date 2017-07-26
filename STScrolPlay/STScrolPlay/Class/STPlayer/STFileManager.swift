//
//  STFileManager.swift
//  STPlayerExample
//
//  Created by xiudou on 2017/1/23.
//  Copyright © 2017年 CoderST. All rights reserved.
//  文件操作

import UIKit
import Foundation
import MobileCoreServices
class STFileManager: NSObject {
    
    // 文件是否存在
    class func isFileExists(path : String)->Bool{
    

        var directory: ObjCBool = ObjCBool(false)
        let exists: Bool = FileManager.default.fileExists(atPath: path, isDirectory: &directory)
        
        // 存在并且不是文件夹 -> 是文件
        if exists && directory.boolValue == false {

            return true
            
        } else {
            
//            print(path,"不是文件或者文件不存在")
            return false
        }
    
    }
    
    /// 获取临时路径
    class func getFileTempPath(url : URL)->String{
        let temp = NSTemporaryDirectory()
        return temp + url.lastPathComponent
    }
    
    /// 获取缓存路径
    class func getFileCachePath(url : URL)->String {
        let fileName = url.lastPathComponent
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as NSString
        let cacehStringPath = cachePath.appendingPathComponent(fileName)
        return cacehStringPath
    }
    
    // 获取文件大小
    class func fileSizeWithPath(path : String)-> Int{
        do {
            let fileDict = try FileManager.default.attributesOfItem(atPath: path)
            //  guard let fileSize = fileDict[FileAttributeKey.size] as? Int else { return 0 }
            guard let fileSize = fileDict[.size] as? Int else { return 0 }
            return fileSize
        } catch  {
            print("获取文件大小失败")
        }
        return 0
    }
    
    //移动文件
    class func moveFile(sourcePath : String, toPath : String){
        if isFileExists(path: sourcePath) == false{
            return
        }

        do {
            try FileManager.default.moveItem(atPath: sourcePath, toPath: toPath)
            print("移动文件成功")
        } catch  {
            print("移动文件失败")
        }
    }

    // 删除文件
    class func removeFileAtPath(filePath : String){
        
        if isFileExists(path: filePath) == false{
            
            return
        }
        
        
        do {
            try FileManager.default.removeItem(atPath: filePath)
            print("删除成功")
        } catch  {
            print("删除失败")
        }
    }
    
    class func contentType(cachePath : String) ->String{
        let cachePathNString = cachePath as NSString
        let fileExtension = cachePathNString.pathExtension
        let cfString : CFString = fileExtension as CFString
        let contentTypeCF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, cfString, nil)
        guard let contentType = CFBridgingRetain(contentTypeCF) as? String else {
            
            return "contentType 不存在"
        }
        
        return contentType
    }
    
    deinit {
        print("STFileManager-释放")
    }
}
