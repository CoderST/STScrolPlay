//
//  STViewModel.swift
//  STPlayerExample
//
//  Created by xiudou on 2017/7/26.
//  Copyright © 2017年 CoderST. All rights reserved.
//

import UIKit
import Alamofire
import MJExtension
let sScreenW = UIScreen.main.bounds.width
let sScreenH = UIScreen.main.bounds.height
let screenSize = UIScreen.main.bounds.size
let NavAndStatusTotalHei : CGFloat = 64.0
let TabbarHei : CGFloat = 49.0
let  RowHei : CGFloat = CGFloat(screenSize.width)*9.0/16.0

public enum kScrollDerection: Int {
    
    case none
    
    case up // scroll up.
    
    case down // scroll down.
}
fileprivate let STCollectionViewCellIdentifier = "STCollectionViewCellIdentifier"
class STViewModel: NSObject,PlayProtocol {
    
//    lazy var models : [STModel] = [STModel]()
    lazy var model : STConnotationModel = STConnotationModel()
    
    lazy var rangeToolModel : STPlayerToolModel = STPlayerToolModel()
    
    /**
     * 刚开始拖拽时scrollView的偏移量Y值, 用来判断滚动方向.
     */
    fileprivate var offsetY_last : CGFloat = 0.0
    
    var playingCell : STCell?
    
    // 播放器
    var player : STPlayer?
    
    // 滚动方向
    fileprivate var currentDerection = kScrollDerection.none

    // collectionView
    fileprivate var collectionView : UICollectionView!

    fileprivate lazy var videoPathStrings: Array = {
        return [
            "http://lavaweb-10015286.video.myqcloud.com/%E5%B0%BD%E6%83%85LAVA.mp4",
            "http://lavaweb-10015286.video.myqcloud.com/lava-guitar-creation-2.mp4",
            "http://lavaweb-10015286.video.myqcloud.com/hong-song-mei-gui-mu-2.mp4",
            "http://lavaweb-10015286.video.myqcloud.com/ideal-pick-2.mp4",
            
            // This path is a https.
            // "https://bb-bang.com:9002/Test/Vedio/20170110/f49601b6bfe547e0a7d069d9319388f4.mp4",
            // "http://123.103.15.1NavAndStatusTotalHei:8880/myVirtualImages/14266942.mp4",
            
            // This video saved in amazon, maybe load sowly.
            // "http://vshow.s3.amazonaws.com/file147801253818487d5f00e2ae6e0194ab085fe4a43066c.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_01.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_02.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_03.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_04.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_05.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_06.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_07.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_08.mp4",
            
            // To simulate the cell have no video to play.
            // "",
            "http://120.25.226.186:32812/resources/videos/minion_10.mp4",
            "http://120.25.226.186:32812/resources/videos/minion_11.mp4",
            "http://lavaweb-10015286.video.myqcloud.com/%E5%B0%BD%E6%83%85LAVA.mp4",
            "http://lavaweb-10015286.video.myqcloud.com/lava-guitar-creation-2.mp4",
            "http://lavaweb-10015286.video.myqcloud.com/hong-song-mei-gui-mu-2.mp4",
            "http://lavaweb-10015286.video.myqcloud.com/ideal-pick-2.mp4"]
    }()

    func loadDatas(finishCallBack : @escaping ()->(), failCallBack : @escaping (_ message : String)->()){
        let urlString = "http://lf.snssdk.com/neihan/stream/mix/v1/?content_type=-101&iid=11612214903&idfa=99F096BA-477A-4D0A-AB26-69B76DDB85C6&version_code=5.8.0&device_type=iPhone%205%20(Global)&live_sdk_version=130&os_version=8.4&screen_width=640&aid=7&vid=D5CDF3B6-1637-454E-B4BD-5CA1DF31E543&device_id=4598024398&os_api=18&app_name=joke_essay&device_platform=iphone&ac=WIFI&openudid=7881ad6e7d291af91681a760a49f1202e5954292&channel=App%20Store&city=%E5%8C%97%E4%BA%AC%E5%B8%82&content_type=-101&count=30&essence=1&latitude=40.08480361223238&longitude=116.391737424483&message_cursor=0&min_time=0&mpic=1"
        NetworkTools.requestData(.get, URLString: urlString) { (result) in
            
            guard let resultDict = result as? [String : Any] else { return }
            
            guard let resultMessage = resultDict["message"] as? String else { return }
            
            if resultMessage != "success"{
                failCallBack(resultMessage)
                return
            }
            
//             self.model = STConnotationModel.mj_object(withKeyValues: resultDict)
            self.model = STConnotationModel(dict: resultDict)
            
//            guard let dataDict = resultDict["data"] as? [String : Any] else { return }
            
            
            
            finishCallBack()
        }
    }
    
//    func setupDatas() {
//        for videoPathString in videoPathStrings{
//            let model = STModel()
//            model.urlString = videoPathString
//            models.append(model)
//        }
//    }
}

extension STViewModel {
    
    // MARK:- 绑定
    func bindViewModel(bindView: UIView) {
        if bindView is UICollectionView{
            let collectionView = bindView as! UICollectionView
            self.collectionView = collectionView
            collectionView.dataSource = self
            collectionView.delegate = self
            // 注册cell
            collectionView.register(STCell.self, forCellWithReuseIdentifier: STCollectionViewCellIdentifier)
        }
    }
}

extension STViewModel : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        if model.data == nil{
//            
//            return 0
//        }
        let count = model.data?.data.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: STCollectionViewCellIdentifier, for: indexPath) as! STCell
        cell.contentView.backgroundColor = UIColor.randomColor()
        cell.indexPath = indexPath
        
        //        let placeholderName = indexPath.item % 2 == 0 ? "placeholder1" : "placeholder2"
        //        cell.videoImv.image = UIImage(named: placeholderName)
        let mod = model.data?.data[indexPath.item]
        cell.videoPath = mod?.group?.mp4_url ?? ""
        cell.videoImv.getNetWorkVidoeImage(url: cell.videoPath)
        if rangeToolModel.maxNumCannotPlayVideoCells>0 {
            if indexPath.row <= rangeToolModel.maxNumCannotPlayVideoCells-1 { // 上不可及
                cell.cellStyle = kJPPlayUnreachCellStyle.up
            }
            else if indexPath.row>=model.data!.data.count - rangeToolModel.maxNumCannotPlayVideoCells { // 下不可及
                cell.cellStyle = kJPPlayUnreachCellStyle.down
            }
            else{
                cell.cellStyle = kJPPlayUnreachCellStyle.none
            }
        }
        else{
            cell.cellStyle = kJPPlayUnreachCellStyle.none
        }
        
        print("cellForItemAt")
        return cell
        
    }

}

extension STViewModel : UICollectionViewDelegateFlowLayout {
    // collectionViewLayout size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let height : CGFloat = CGFloat(arc4random_uniform(100) + 50)
        
        let size  = CGSize(width: sScreenW, height: RowHei)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(collectionView.visibleCells.count)
    }
    
    // 实时监控cell滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollDerectionWithOffset(offsetY: scrollView.contentOffset.y)
        handleQuickScroll()
    }
    
    
    // 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        offsetY_last = scrollView.contentOffset.y
    }
    
    // 已经结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate==false {
            handleScrollStop()
        }
    }
    
    // 已经结束惯性
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollStop()
    }
    
}


// MARK:- 私有方法
extension STViewModel {
    
    // 找到最合适要播放的cell
    func findTheBestToPlayVideoCell() -> STCell?{
        var windowRect = UIScreen.main.bounds
        windowRect.origin.y = NavAndStatusTotalHei;
        windowRect.size.height -= (NavAndStatusTotalHei + TabbarHei);
        
        // To find next cell need play video.
        // 找到下一个要播放的cell(最在屏幕中心的).
        var finialCell : STCell?
        let visiableCells : [STCell] = collectionView.visibleCells as! [STCell];
        var gap : CGFloat = CGFloat(MAXFLOAT)
        
        for cell in visiableCells{
            if cell.videoPath.characters.count>0 { //  如果这个cell有视频
                
                // Find the cell cannot stop in screen center first.
                // 优先查找滑动不可及cell.
                if cell.cellStyle != kJPPlayUnreachCellStyle.none {
                    
                    // Must the all area of the cell is visiable.
                    // 并且不可及cell要全部露出.
                    if cell.cellStyle == kJPPlayUnreachCellStyle.up {
                        var cellLeftUpPoint = cell.frame.origin
                        // 不要在边界上.
                        cellLeftUpPoint.y += 1
                        let coorPoint = cell.superview?.convert(cellLeftUpPoint, to: nil)
                        let contain = windowRect.contains(coorPoint!)
                        if  contain {
                            finialCell = cell
                            break
                        }
                    }
                    else if(cell.cellStyle == kJPPlayUnreachCellStyle.down){
                        let cellLeftUpPoint = cell.frame.origin
                        let cellDownY = cellLeftUpPoint.y+cell.frame.size.height
                        var cellLeftDownPoint = CGPoint(x: 0, y: cellDownY)
                        // 不要在边界上.
                        cellLeftDownPoint.y -= 1
                        let coorPoint = cell.superview?.convert(cellLeftDownPoint, to: nil)
                        let contain = windowRect.contains(coorPoint!)
                        if contain {
                            finialCell = cell
                            break;
                        }
                    }
                }
                else{
                    let coorCenter = cell.superview?.convert(cell.center, to: nil)
                    let delta = fabs((coorCenter?.y)!-NavAndStatusTotalHei-windowRect.size.height*0.5)
                    if delta < gap {
                        print(delta)
                        gap = delta
                        finialCell = cell
                    }
                }
            }
        }
        
        return finialCell
        
    }
    
    
    /// cell滚动停止相关操作
    func handleScrollStop() {
        
        guard let bestCell = findTheBestToPlayVideoCell() else {
            return
        }
        
        // 注意, 如果正在播放的 cell 和 finnalCell 是同一个 cell, 不应该在播放.
        if playingCell?.hash != bestCell.hash{
            // playingCell?.videoImv.stopPlay()
            // 1 把上个离中心距离最近的cell停止播放
            playingCell?.label.text = "stop"
            playingCell?.videoImv.isHidden = false
            player?.stop()
            let url = URL(string: bestCell.videoPath)
            
            // display status view.
            // bestCell.videoImv.jp_playVideoMutedDisplayStatusView(with: url)
            //            print(playingCell?.label.text,bestCell.label.text)
            // hide status view.
            // bestCell.videoImv.jp_playVideoMuted(with: url)
            // 2 新找到的cell赋值给正在播放的cell
            playingCell = bestCell
            
            //playingCell?.backgroundColor = UIColor.white
            // 3 执行正在播放cell的操作
            playingCell?.label.text = "start"
            playingCell?.videoImv.isHidden = true
            startPlayer(palyView: (playingCell?.contentView)!, playUrlString: (playingCell?.videoPath)!)
        }else{   /// 同一个cell
            if bestCell.isScrollowOutWindow == true{
                bestCell.isScrollowOutWindow = false
                playingCell?.label.text = "stop"
                playingCell?.videoImv.isHidden = false
                player?.stop()
                playingCell = bestCell
                playingCell?.label.text = "start"
                playingCell?.videoImv.isHidden = true
                startPlayer(palyView: (playingCell?.contentView)!, playUrlString: (playingCell?.videoPath)!)
                
            }
        }
    }
    
    // 记录滚动方向
    func handleScrollDerectionWithOffset(offsetY : CGFloat) {
        currentDerection = (offsetY-offsetY_last) > 0 ? kScrollDerection.up : kScrollDerection.down
        offsetY_last = offsetY
    }
    
    // 当前播放的cell 在惯性没有停止的时候滚到屏幕外时 要停止这个cell视频的播放
    func handleQuickScroll() {
        if playingCell?.hash==0 {
            return
        }
        
        // 防止弹出新的控制器时  自动调用滚动方法, 导致最后一个 cell 无法播放视频.
        if rangeToolModel.tableViewRange.isHidden {
            return;
        }
        
        // Stop play when the cell playing video is unvisiable.
        // 当前播放视频的cell移出视线，要移除播放器.
        if !playingCellIsVisiable() {
            //stopPlay()
            playingCell?.label.text = "stop"
            playingCell?.videoImv.isHidden = false
            player?.stop()
            playingCell?.isScrollowOutWindow = true
            print("stopPlay()")
        }
    }
    
    // 可见区域是否包含正在播放的cell
    func playingCellIsVisiable() -> Bool {
        guard let cell = playingCell else {
            return true
        }
        
        var windowRect = UIScreen.main.bounds
        windowRect.origin.y = NavAndStatusTotalHei;
        // because have UINavigationBar here.
        windowRect.size.height -= NavAndStatusTotalHei;
        
        if currentDerection==kScrollDerection.up { // 向上滚动
            let cellLeftUpPoint = cell.frame.origin
            let cellDownY = cellLeftUpPoint.y+cell.frame.size.height
            var cellLeftDownPoint = CGPoint(x: 0, y: cellDownY)
            // 不要在边界上.
            cellLeftDownPoint.y -= 1
            let coorPoint = playingCell?.superview?.convert(cellLeftDownPoint, to: nil)
            
            let contain = windowRect.contains(coorPoint!)
            return contain
        }
        else if(currentDerection==kScrollDerection.down){ // 向下滚动
            var cellLeftUpPoint = cell.frame.origin
            // 不要在边界上.
            cellLeftUpPoint.y += 1
            let coorPoint = cell.superview?.convert(cellLeftUpPoint, to: nil)
            
            let contain = windowRect.contains(coorPoint!)
            return contain
        }
        return true
    }
    
    
    // Find first cell need play video in visiable cells.
    // 找到第一个需要播放的cell
    func playVideoInVisiableCells() {
        let visiableCells = collectionView.visibleCells
        
        
        var targetCell : STCell?
        for (index,c) in visiableCells.enumerated() {
            let cell = c as! STCell
            guard let index = collectionView.indexPath(for: c) else { continue }
            if cell.videoPath.characters.count>0 && index.item == 0{
                
                targetCell = cell
                break
            }
        }
        
        // If found, play.
        guard let videoCell = targetCell else {
            return
        }
        playingCell = videoCell
        
        videoCell.label.text = "start"
        videoCell.videoImv.isHidden = true
        startPlayer(palyView: (playingCell?.contentView)!, playUrlString: (playingCell?.videoPath)!)
    }
    
    
 
    func startPlayer(palyView : UIView,playUrlString : String){
        
        let configuration = STConfiguration()
        configuration.isCache = false
        configuration.palyView = palyView
        configuration.playerLayerF = CGRect(x: 0, y: 0, width: sScreenW, height: RowHei)
        guard let url = URL(string: playUrlString) else { return }
        player = STPlayer()
        player?.playWithURL(url, configuration)
        //        player.resume()
    }
    
    func stopPlayer(){
        playingCell?.videoImv.isHidden = true
        player?.stop()
    }
    
}
