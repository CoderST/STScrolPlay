//
//  STReourceLoaderManager.swift
//  STPlayerExample
//
//  Created by xiudou on 2017/1/23.
//  Copyright © 2017年 CoderST. All rights reserved.
//  

import UIKit
import AVFoundation
fileprivate let kCachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
fileprivate let kTmpPath = NSTemporaryDirectory()
class STReourceLoaderManager: NSObject {
    
    fileprivate var tempFilePath : String = ""
    fileprivate var cacheFilePath : String = ""

    // MARK:- 懒加载
    /// 保存等待被给予视频数据的请求
    fileprivate lazy var pendingRequests: NSMutableArray = NSMutableArray()
    
    /// 视频总大小
    fileprivate var  expectedSize : Int = 0
    
    /// 视频在磁盘缓存的大小
    fileprivate var  receivedSize : Int = 0
    
    /// 视频临时缓存路径
    fileprivate var  tempCacheVideoPath : String = ""
    
    fileprivate lazy var downLoader : STDownLoader = {[weak self] in
       let downLoader = STDownLoader()
        downLoader.delegate = self
        return downLoader
    }()
    
    deinit {
        
        print("STReourceLoaderManager-释放")
    }
}

// MARK:- STDownLoaderDelegate (视频已经接收完一段数据的处理)
extension STReourceLoaderManager : STDownLoaderDelegate{
    func downLoading() {
        
        handleAllRequest()
    }
}

// MARK:- AVAssetResourceLoaderDelegate
extension STReourceLoaderManager : AVAssetResourceLoaderDelegate {
    
    /// 将要等到要加载的数据
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool{

        // 0 获取缓存和临时路径
        guard let urlLastPathComponent = loadingRequest.request.url?.lastPathComponent else { return false}
        
        let cPath = kCachePath as NSString
        cacheFilePath = cPath.appendingPathComponent(urlLastPathComponent)
        
        let tPath = kTmpPath as NSString
        tempFilePath = tPath.appendingPathComponent(urlLastPathComponent)

        pendingRequests.add(loadingRequest)

        // 1 缓存是否有视频
        if STFileManager.isFileExists(path: cacheFilePath){
            handleFullCacheDatas(loadingRequest)
            return true
        }
        // ----------以下属于需要下载处理的情况
        
        // 2 获取下载的url地址  注意 strmingURL -> HTTP URL
        guard let url = loadingRequest.request.url?.httpUrl() else {
            print("url不存在")
            return false
        }
        // 2.1 如果不存在, 判断当前是否有正在下载, 没有则开始下载
        if downLoader.loadedLength == 0{
            downLoader.downLoadWithURL(url: url, offset: 0, tempPath: tempFilePath, cachePath: cacheFilePath)
        }
        
        // 3 如果已经在下载, 则判断是否需要重新下载
        // ⚠️获取的是firstLoadingRequest
        guard let firstLoadingRequest = pendingRequests.firstObject as? AVAssetResourceLoadingRequest else{ return false }
        guard var requestedOffset = firstLoadingRequest.dataRequest?.requestedOffset else {
            print("requestOffset不存在")
            return false
        }
        
        guard let currentOffset = firstLoadingRequest.dataRequest?.currentOffset else {
            print("currentOffset不存在")
            return false
        }
        
        if requestedOffset != currentOffset {
            requestedOffset = currentOffset
        }
        
        // 3.1 有临时数据,要处理本地临时数据和请求数据区间逻辑问题
        // 3.1.1 考虑需要重新下载情况  此次请求requestOffset < 缓存的offset 或者 requestOffset > 缓存的offset + 缓存的区间长度   return
        
        if Int(requestedOffset) < downLoader.requestOffset || Int(requestedOffset) > (downLoader.requestOffset + downLoader.loadedLength + 666){
            // 需要重新下载数据
            downLoader.downLoadWithURL(url: url, offset: 0, tempPath: tempFilePath, cachePath: cacheFilePath)
            return true
        }
        // 2.2.2 requestOffset在缓存区间内 -> 处理requestedLength和缓存区间交汇的情况
        
        handleAllRequest()
        
        return true
    }
    
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest){
        print("取消请求")
        pendingRequests.remove(loadingRequest)
        
    }


}


// MARK:- 私有方法
extension STReourceLoaderManager {
    
    fileprivate func handleAllRequest(){
        guard let loadingRequest = pendingRequests.firstObject  as? AVAssetResourceLoadingRequest else { return }
        //        print("loadingRequest = \(loadingRequest)")
        // 本地资源总大小
        let totleSize = downLoader.totleFileSize
        // 填充信息头信息
        if let contentInformationRequest =  loadingRequest.contentInformationRequest{
            fillInContentInformation(contentInformationRequest: contentInformationRequest, expectedSize: totleSize)
        }
        
        // 把相应的数据给外界
        guard var requestOffset = loadingRequest.dataRequest?.requestedOffset else {
            print("requestOffset不存在")
            return
        }
        
        guard let currentOffset = loadingRequest.dataRequest?.currentOffset else {
            print("currentOffset不存在")
            return
        }
        
        guard let requestedLength = loadingRequest.dataRequest?.requestedLength else {
            print("requestedLength不存在")
            return
        }
        
        if currentOffset != requestOffset {
            requestOffset = currentOffset
        }
        
        // 向外界相应offset
        let responseOffset = Int(requestOffset) - downLoader.requestOffset
        let tempLength = downLoader.requestOffset + downLoader.loadedLength - Int(requestOffset)
        // 向外界相应length
        let responseLength = min(tempLength, requestedLength)
        
        var data = try? NSData(contentsOfFile: tempFilePath, options: NSData.ReadingOptions.mappedIfSafe)
        if data == nil || data?.length == 0{
            data = try? NSData(contentsOfFile: cacheFilePath, options: NSData.ReadingOptions.mappedIfSafe)
        }
        if data != nil && data!.length > 0 {
//            print(responseOffset,responseLength)
            let range = NSMakeRange(Int(responseOffset), Int(responseLength))
            let subNSData = data!.subdata(with: range)
            if loadingRequest.dataRequest != nil{
                
                loadingRequest.dataRequest?.respond(with: subNSData)
                if requestedLength == responseLength {
                    loadingRequest.finishLoading()
                    pendingRequests.remove(loadingRequest)
                }
            }
            
        }
    }
    
    /// 有本地缓存视频
    fileprivate func handleFullCacheDatas(_ loadingRequest: AVAssetResourceLoadingRequest){
        guard let requestOffset = loadingRequest.dataRequest?.requestedOffset else {
            
            print("requestOffset - 不存在")
            return
        }
        guard let requestLength = loadingRequest.dataRequest?.requestedLength else {
            print("requestLength - 不存在")
            return
        }
        
        // 本地资源总大小
        let totleSize = STFileManager.fileSizeWithPath(path: cacheFilePath)
        print(requestOffset,requestLength,totleSize)
        // 填充信息头信息
        if let contentInformationRequest =  loadingRequest.contentInformationRequest{
            fillInContentInformation(contentInformationRequest: contentInformationRequest, expectedSize: totleSize)
        }
        
        
        // 把相应的数据给外界
        do {
            let data = try NSData(contentsOfFile: cacheFilePath, options: NSData.ReadingOptions.mappedIfSafe)
            let subData = data as NSData
            let range = NSMakeRange(Int(requestOffset), Int(requestLength))
            let subNSData = subData.subdata(with: range)
            loadingRequest.dataRequest?.respond(with: subNSData)
            loadingRequest.finishLoading()
        } catch  {
            print("handleFullCacheDatas",error)
        }
        
    }
    
    fileprivate func fillInContentInformation(contentInformationRequest : AVAssetResourceLoadingContentInformationRequest, expectedSize : Int){
        contentInformationRequest.contentLength = Int64(expectedSize)
        contentInformationRequest.isByteRangeAccessSupported = true
        let contentType = STFileManager.contentType(cachePath: cacheFilePath)
        contentInformationRequest.contentType = contentType
    }
    
    func stopAndClear(){
        // 停止URLSession下载
        if downLoader.session != nil {
            downLoader.delegate = nil
            downLoader.session?.invalidateAndCancel()
            downLoader.session = nil
        }
        
    }
    
}
