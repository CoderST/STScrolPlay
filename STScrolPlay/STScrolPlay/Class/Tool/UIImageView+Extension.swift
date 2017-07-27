//
//  UIImageView+Extension.swift
//  DYZB
//
//  Created by xiudou on 16/11/1.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImageView{
    
    /**
     开始动画
     */
    func playGifAnimation(_ images : [UIImage]?){
        guard let imageArray = images else { return }
        animationImages = imageArray
        animationDuration = 0.5
        animationRepeatCount = 0
        startAnimating()
    }
    
    /**
     结束动画
     */
    func stopGifAnimation(){
        if isAnimating == true{
            stopAnimating()
        }
        
        removeFromSuperview()
    }
    
}

// MARK:- 获取网络视频截图
extension UIImageView {
    
    func getNetWorkVidoeImage(url:String){
        
        DispatchQueue.global().async {
            //需要长时间处理的代码
            
            let asset = AVURLAsset(url: URL(string: url)!)
            
            let generator = AVAssetImageGenerator(asset: asset)
            
            generator.appliesPreferredTrackTransform=true
            
            let time = CMTimeMakeWithSeconds(0.0,600)
            
            var actualTime : CMTime = CMTimeMake(0,0)
            
            var image:CGImage?
            
            do{
                image = try generator.copyCGImage(at: time, actualTime: &actualTime)
            }catch let error as NSError{
                print(error)
            }

            DispatchQueue.main.async {
                guard let image = image else { return }
                self.image = UIImage(cgImage: image)
            }
        }
        
    }
}

