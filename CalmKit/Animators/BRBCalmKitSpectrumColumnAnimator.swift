//
//  BRBCalmKitSpectrumColumnAnimator.swift
//  CalmKit
//
// Copyright (c) 2016 RadioBear
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import UIKit

class BRBCalmKitSpectrumColumnAnimator: BRBCalmKitAnimator {
    
    var totalDuration: NSTimeInterval = 1.0
    var columnAndPaddingRate: CGFloat = 1.0 / 2.0
    var columnsHeightRate = [CGFloat](arrayLiteral: 0.4, 0.35, 0.6, 0.25)
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {

        if columnsHeightRate.isEmpty {
            return ;
        }
        
        let beginTime = CACurrentMediaTime()
        
        let columnCount = columnsHeightRate.count
        
        let columnWidth = (size.width * columnAndPaddingRate) / ((columnAndPaddingRate * CGFloat(columnCount)) + CGFloat(columnCount - 1))
        let paddingWidth = columnWidth / columnAndPaddingRate
        
        let maxHeightRate = columnsHeightRate.maxElement()!
        
        var curX: CGFloat = 0.0
        for i in 0..<columnCount {
            
            let columnLayer = CALayer()
            columnLayer.anchorPoint = CGPointMake(0.5, 1.0)
            columnLayer.frame = CGRectMake(curX, 0.0, columnWidth, size.height * columnsHeightRate[i])
            columnLayer.position = CGPointMake(columnLayer.position.x, 0.0)
            columnLayer.backgroundColor = color.CGColor
            columnLayer.shouldRasterize = true
            layer.addSublayer(columnLayer)
            
            curX += columnWidth + paddingWidth
            
            let anim = CAKeyframeAnimation(keyPath: "transform.scale.y")
            anim.removedOnCompletion = false
            anim.repeatCount = HUGE
            anim.duration = totalDuration
            anim.beginTime = beginTime + (((i % 2) == 0) ? 0 : (totalDuration * 0.5))
            anim.keyTimes = [0.0, 0.5, 1.0]
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            ]
            
            let maxScale = (maxHeightRate + columnsHeightRate[i]) / columnsHeightRate[i]
            anim.values = [
                1.0,
                maxScale,
                1.0,
            ]
            
            columnLayer.addAnimation(anim, forKey:"calmkit-anim")
        }
        
    }
}