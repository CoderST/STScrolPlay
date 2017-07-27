//
//  STCell.swift
//  转换坐标系
//
//  Created by xiudou on 2017/7/21.
//  Copyright © 2017年 CoderST. All rights reserved.
//

import UIKit
public enum kJPPlayUnreachCellStyle : Int {
    
    case none // normal 播放滑动可及cell.
    
    case up // top 顶部不可及.
    
    case down // bottom 底部不可及.
}
class STCell: UICollectionViewCell {
    
    
    public var cellStyle : kJPPlayUnreachCellStyle? // cell类型
    
    lazy var label : UILabel = UILabel()
    
    lazy var videoImv : UIImageView = {
       
        let videoImv = UIImageView()
        videoImv.contentMode = .scaleAspectFit
        return videoImv
        
    }()
    
    public var videoPath = String()
    

    var isScrollowOutWindow : Bool = false
    
//    var indexPath : IndexPath?{
//        
//        didSet{
//            
//            guard let indexPath = indexPath else { return }
//            
//            
//            label.text = "\(indexPath.item)"
//
//        
//        }
//    }

    public var indexPath: IndexPath?
    
//    public var indexPath: IndexPath {
//        get {
//            return self.indexPath
//        }
//        set {
//            let placeholderName = newValue.row % 2 == 0 ? "placeholder1" : "placeholder2"
//            label.text = "\(newValue.row % 2)"
////            videoImv.image = UIImage(named: placeholderName)
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(videoImv)
        contentView.addSubview(label)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: 100, height: frame.height)
        videoImv.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
