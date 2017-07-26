//
//  STDownLoader.swift
//  STPlayerExample
//
//  Created by xiudou on 2017/1/23.
//  Copyright © 2017年 CoderST. All rights reserved.
//  下载

import UIKit
import SVProgressHUD
protocol STDownLoaderDelegate : class {
    func downLoading()
}
class STDownLoader: NSObject {

    // MARK:- 变量
    // 外部参数
    /// 请求偏移量
    var requestOffset : Int = 0
    /// 当前已经下载的长度
    var loadedLength : Int = 0
    /// 文件总长度
    var totleFileSize : Int = 0
    /// 文件的mineTyle
    var mimeType : String = ""
    
    weak var delegate : STDownLoaderDelegate?
    
    // 内部参数
    /// 临时路径
    fileprivate var tempPath : String = ""
    /// 缓存路径
    fileprivate var cachePath : String = ""
    var outputStream : OutputStream?
    /// session
    var session : URLSession?
    
    deinit {
        
        print("STDownLoader-释放")
    }
}

// MARK:- 对外接口
extension STDownLoader {
    
    func downLoadWithURL(url : URL, offset : Int, tempPath : String, cachePath : String){
        session?.invalidateAndCancel()
        session = nil
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        // 清理缓存
        STFileManager.removeFileAtPath(filePath: tempPath)

        requestOffset = offset
        loadedLength = 0
        self.tempPath = tempPath
        self.cachePath = cachePath
        
        
        // 重新下载
        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 0)
        // 通过控制range, 控制请求资源字节区间
        request.setValue(String(format: "bytes=%lld-",offset), forHTTPHeaderField: "Range")
        let dataTask = session?.dataTask(with: request)
        dataTask?.resume()

    }
}

// MARK:- URLSessionDataDelegate
extension STDownLoader : URLSessionDataDelegate{
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void){
        print("didReceivecompletionHandler")
        let expected = max(response.expectedContentLength,0)
        totleFileSize = Int(expected)
        if let resmimeType = response.mimeType{
            
            mimeType = resmimeType
        }
        
        // 4 创建通道
        outputStream = OutputStream(toFileAtPath: tempPath, append: true)
        // 5 打开通道
        outputStream?.open()
        // 6 允许接受数据
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        if data.count > 0{
            loadedLength = loadedLength + data.count
            let nsData = data as NSData
            outputStream?.write(nsData.bytes.assumingMemoryBound(to: UInt8.self), maxLength: nsData.length)
        delegate?.downLoading()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        print("didCompleteWithError")
        if error == nil && requestOffset == 0 && loadedLength == totleFileSize{  // 没错误
            STFileManager.moveFile(sourcePath: tempPath, toPath: cachePath)
        }else{  // 有不知道的错误
            guard let err = error as? NSError else { return }
            print(err.userInfo)
            print(err.code)
            switch err.code {
            case -1009:
                SVProgressHUD.showError(withStatus: "网络断开")
            case -1001:
                SVProgressHUD.showError(withStatus: "链接超时")
            default:
                print("")
//                SVProgressHUD.showError(withStatus: "未知错误")
            }
        }
        outputStream?.close()
        outputStream = nil
    }
}

