//
//  BRBCalmKitArcAltAnimator.swift
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

class BRBCalmKitArcAltAnimator: BRBCalmKitAnimator {
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        let beginTime = CACurrentMediaTime()
        
        let frame: CGRect  = CGRectInset(CGRectMake(0.0, 0.0, size.width, size.height), 2.0, 2.0)
        let radius: CGFloat = CGRectGetWidth(frame) / 2.0
        let center: CGPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        
        let arc = CALayer()
        arc.frame           = CGRectMake(0.0, 0.0, size.width, size.height)
        arc.backgroundColor = color.CGColor
        arc.anchorPoint     = CGPointMake(0.5, 0.5)
        arc.cornerRadius    = CGRectGetWidth(arc.frame) / 2.0
        
        let path = CGPathCreateMutable()
        CGPathAddArc(path, nil, center.x, center.y, radius, 0.0, CGFloat(M_PI) * 2.0, false)
        
        let mask = CAShapeLayer()
        mask.frame         = CGRectMake(0.0, 0.0, size.width, size.height)
        mask.path          = path
        mask.strokeColor   = UIColor.blackColor().CGColor
        mask.fillColor     = UIColor.clearColor().CGColor
        mask.lineWidth     = 2.0
        mask.cornerRadius  = frame.size.width / 2.0
        mask.anchorPoint   = CGPointMake(0.5, 0.5)
        
        arc.mask = mask
        
        let duration: CFTimeInterval = 1.2
        
        let strokeEndAnim = CAKeyframeAnimation(keyPath: "strokeEnd")
        strokeEndAnim.removedOnCompletion = false
        strokeEndAnim.repeatCount = HUGE
        strokeEndAnim.duration    = duration
        strokeEndAnim.beginTime   = beginTime
        strokeEndAnim.keyTimes    = [0.0, 0.4, 1.0]
        strokeEndAnim.values      = [0.0, 1.0, 1.0]
        strokeEndAnim.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
        ]
        
        let strokeStartAnim = CAKeyframeAnimation(keyPath: "strokeStart")
        strokeStartAnim.removedOnCompletion = false
        strokeStartAnim.repeatCount = HUGE
        strokeStartAnim.duration    = duration
        strokeStartAnim.beginTime   = beginTime
        strokeStartAnim.keyTimes    = [0.0, 0.6, 1.0]
        strokeStartAnim.values      = [0.0, 0.0, 1.0]
        strokeStartAnim.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
        ]
        
        layer.addSublayer(arc)
        mask.addAnimation(strokeStartAnim, forKey: "calmkit-anim.start")
        mask.addAnimation(strokeEndAnim, forKey: "calmkit-anim.end")
    }
}
