//
//  STPlayerToolModel.swift
//  STPlayerExample
//
//  Created by xiudou on 2017/7/26.
//  Copyright © 2017年 CoderST. All rights reserved.
//  画虚线

import UIKit

class STPlayerToolModel: NSObject {

    // 虚线区域View
    lazy var tableViewRange : UIView = self.generateTableViewRange()

    
    let generateTableViewRange = { () -> UIView in
        let tableViewRange = UIView(frame: CGRect(x: 0, y: NavAndStatusTotalHei, width: screenSize.width, height: screenSize.height-NavAndStatusTotalHei-TabbarHei))
        tableViewRange.isUserInteractionEnabled = false
        tableViewRange.backgroundColor = UIColor.clear
        tableViewRange.isHidden = true
        return tableViewRange
    }

    lazy var dictOfVisiableAndNotPlayCells : Dictionary<String, Int> = {
        return ["4" : 1, "3" : 1, "2" : 0]
    }()
    // The number of cells cannot stop in screen center.
    var maxNumCannotPlayVideoCells: Int {
        let radius = screenSize.height / RowHei
        let maxNumOfVisiableCells = Int(ceilf(Float(radius)))
        if maxNumOfVisiableCells >= 3 {
            return dictOfVisiableAndNotPlayCells["\(maxNumOfVisiableCells)"]!
        }
        return 0
    }
    
    func displayCollectionViewRange(centerView : UIView, view : UIView){
        view.insertSubview(tableViewRange, aboveSubview: centerView)
        addDashLineToTableViewRange()

    }
    
    
    func addDashLineToTableViewRange() {
        let linePath1 = UIBezierPath()
        linePath1.move(to: CGPoint(x: 1, y: 1))
        linePath1.addLine(to: CGPoint(x: screenSize.width-1, y: 1))
        linePath1.addLine(to: CGPoint(x: screenSize.width-1, y: screenSize.height-NavAndStatusTotalHei-1-TabbarHei))
        linePath1.addLine(to: CGPoint(x: 1, y: screenSize.height-NavAndStatusTotalHei-1-TabbarHei))
        linePath1.addLine(to: CGPoint(x: 1, y: 1))
        
        let layer1 = CAShapeLayer()
        let drawColor1 = UIColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: 1)
        layer1.path = linePath1.cgPath
        layer1.strokeColor = drawColor1.cgColor
        layer1.fillColor = UIColor.clear.cgColor
        layer1.lineWidth = 1
        layer1.lineDashPattern = [6, 3]
        layer1.lineCap = "round"
        tableViewRange.layer.addSublayer(layer1)
        
        let linePath2 = UIBezierPath()
        linePath2.move(to: CGPoint(x: 1, y: 0.5*(screenSize.height-NavAndStatusTotalHei-1-TabbarHei)))
        linePath2.addLine(to: CGPoint(x: screenSize.width-1, y: 0.5*(screenSize.height-NavAndStatusTotalHei-1-TabbarHei)))
        
        let layer2 = CAShapeLayer()
        let drawColor2 = UIColor(colorLiteralRed: 0, green: 0.98, blue: 0, alpha: 1)
        layer2.path = linePath2.cgPath
        layer2.strokeColor = drawColor2.cgColor
        layer2.fillColor = UIColor.clear.cgColor
        layer2.lineWidth = 1
        layer2.lineDashPattern = [6, 3]
        layer2.lineCap = "round"
        tableViewRange.layer.addSublayer(layer2)
    }

    
}
