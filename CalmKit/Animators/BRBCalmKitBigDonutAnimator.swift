//
//  BRBCalmKitBigDonutAnimator.swift
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

class BRBCalmKitBigDonutAnimator: BRBCalmKitAnimator {
    
    let degToRad: Double = 0.0174532925
    
    var circleCount: Int = 8
    var circleWidthRate: CGFloat = 0.15
    var totalDuration: NSTimeInterval = 1.5
    var paddingDegree: Double = 10.0
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        
        if circleCount <= 0 {
            return ;
        }
        
        let beginTime = CACurrentMediaTime()
        
        let circleWidth = circleWidthRate * size.width
        let frame: CGRect  = CGRectInset(CGRectMake(0.0, 0.0, size.width, size.height), circleWidth, circleWidth)
        let radius: CGFloat = frame.width * 0.5
        let center: CGPoint = CGPointMake(frame.midX, frame.midY)
        
        let circlePaddingRadius: CGFloat = CGFloat(degToRad * paddingDegree)
        let circleRadius: CGFloat = CGFloat(((2.0 * M_PI) / Double(circleCount))) - circlePaddingRadius
        let increaseTime: NSTimeInterval = totalDuration / Double(circleCount)
        
        var beginRadius: CGFloat = 0.0
        for i in 0..<circleCount {
            let arc = CALayer()
            arc.frame           = CGRectMake(0.0, 0.0, size.width, size.height)
            arc.backgroundColor = color.CGColor
            arc.anchorPoint     = CGPointMake(0.5, 0.5)
            arc.shouldRasterize = true
            arc.rasterizationScale = UIScreen.mainScreen().scale
            
            let path = CGPathCreateMutable()
            CGPathAddRelativeArc(path, nil, center.x, center.y, radius, beginRadius, circleRadius)
            beginRadius += circleRadius + circlePaddingRadius
            
            let mask = CAShapeLayer()
            mask.frame         = CGRectMake(0.0, 0.0, size.width, size.height)
            mask.anchorPoint   = CGPointMake(0.5, 0.5)
            mask.path          = path
            mask.strokeColor   = UIColor.blackColor().CGColor
            mask.fillColor     = UIColor.clearColor().CGColor
            mask.lineWidth     = circleWidth
            
            let anim = CAKeyframeAnimation(keyPath: "opacity")
            anim.removedOnCompletion = false
            anim.repeatCount = HUGE
            anim.duration = totalDuration
            anim.beginTime = beginTime + (increaseTime * Double(i))
            anim.keyTimes = [0.0, 0.4, 0.6, 1.0]
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            ]
            
            anim.values = [0.0, 1.0, 1.0, 0.0]
            
            arc.mask = mask
            layer.addSublayer(arc)
            mask.addAnimation(anim, forKey: "calmkit-anim")
            
        }
    }
}