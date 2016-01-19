//
//  BRBCalmKitDoubleArcAnimator.swift
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

class BRBCalmKitDoubleArcAnimator: BRBCalmKitAnimator {
    
    var arcWidthRate: CGFloat = 0.05
    var totalDuration: NSTimeInterval = 1.0
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        let beginTime = CACurrentMediaTime()
        
        let arcWidth = size.width * arcWidthRate
        let frame: CGRect = CGRectInset(CGRectMake(0.0, 0.0, size.width, size.height), arcWidth, arcWidth)
        let radius: CGFloat = frame.width * 0.5
        let center: CGPoint = CGPointMake(frame.midX, frame.midY)
        
        let arc = CALayer()
        arc.frame = CGRectMake(0.0, 0.0, size.width, size.height)
        arc.backgroundColor = color.CGColor
        arc.anchorPoint = CGPointMake(0.5, 0.5)
        
        let path = CGPathCreateMutable()
        CGPathAddRelativeArc(path, nil, center.x, center.y, radius, p_degToRad(20.0), p_degToRad(140.0))
        let pathAdd = CGPathCreateMutable()
        CGPathAddRelativeArc(pathAdd, nil, center.x, center.y, radius, p_degToRad(200.0), p_degToRad(140.0))
        CGPathAddPath(path, nil, pathAdd)
        
        let mask = CAShapeLayer()
        mask.frame        = CGRectMake(0.0, 0.0, size.width, size.height)
        mask.path         = path
        mask.strokeColor  = UIColor.blackColor().CGColor
        mask.fillColor    = UIColor.clearColor().CGColor
        mask.lineWidth    = arcWidth
        mask.anchorPoint  = CGPointMake(0.5, 0.5)
        mask.lineCap      = kCALineCapRound
        
        arc.mask = mask;
        
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        anim.removedOnCompletion = false
        anim.repeatCount = HUGE
        anim.duration = totalDuration
        anim.beginTime = beginTime
        anim.timeOffset = NSDate.timeIntervalSinceReferenceDate()
        anim.keyTimes = [0.0, 0.5, 1.0]
        
        anim.values = [0.0, M_PI, M_PI * 2.0]
        
        layer.addSublayer(arc)
        arc.addAnimation(anim, forKey:"calmkit-anim")
    }
}
