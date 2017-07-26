//
//  ViewController.swift
//  转换坐标系
//
//  Created by xiudou on 2017/7/21.
//  Copyright © 2017年 CoderST. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    // MARK:- 懒加载
    
    fileprivate lazy var viewModel : STViewModel = STViewModel()
    
    // collectionView
    lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        let width = sScreenW
        // 默认值(如果改动可以添加代理方法)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:0 , width: screenSize.width , height: screenSize.height), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.gray
        return collectionView;
        
    }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        print("path = \(path)")
        
        // 1 添加collectionView
        view.addSubview(collectionView)
        
        // 2 绑定
        viewModel.bindViewModel(bindView: collectionView)
        
        // 3 添加数据
        viewModel.setupDatas()
        
        collectionView.reloadData()
        
        // 4 画虚线区域
        viewModel.rangeToolModel.displayCollectionViewRange(centerView: collectionView, view: view)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.playingCell == nil {
            
            // Find the first cell need to play video in visiable cells.
            // 在可见cell中找第一个有视频的进行播放.
            viewModel.playVideoInVisiableCells()
        }
        else{
            let url = URL(string: (viewModel.playingCell?.videoPath)!)
            //playingCell?.videoImv.jp_playVideoMutedDisplayStatusView(with: url)
            viewModel.playingCell?.label.text = "start"
            viewModel.startPlayer(palyView: (viewModel.playingCell?.contentView)!, playUrlString: (viewModel.playingCell?.videoPath)!)
        }
        viewModel.rangeToolModel.tableViewRange.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.rangeToolModel.tableViewRange.isHidden = true
        
        if (viewModel.playingCell != nil) {
            // playingCell?.videoImv.stopPlay()
            viewModel.playingCell?.label.text = "stop"
            viewModel.player?.stop()
        }
    }
    
    deinit {
        viewModel.player?.stop()
    }
}
