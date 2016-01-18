//
//  BRBCalmKitPairFadingRingAnimator.swift
//  CalmKitDemo
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

class BRBCalmKitPairFadingRingAnimator: BRBCalmKitAnimator {
    
    var circleWidthRate: CGFloat = 0.1
    var totalDuration: NSTimeInterval = 1.0
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        
        let circleWidth = size.width * circleWidthRate
        let frame: CGRect = CGRectInset(CGRectMake(0.0, 0.0, size.width, size.height), circleWidth, circleWidth)
        
        let circle = CALayer()
        circle.frame                = CGRectMake(0.0, 0.0, size.width, size.height)
        circle.anchorPoint          = CGPointMake(0.5, 0.5)
        circle.backgroundColor      = color.CGColor
        circle.shouldRasterize      = true
        circle.rasterizationScale   = UIScreen.mainScreen().scale
        
        let mask = BRBAngularGradientLayer()
        mask.frame              = CGRectMake(0.0, 0.0, size.width, size.height)
        mask.anchorPoint        = CGPointMake(0.5, 0.5)
        mask.backgroundColor    = UIColor.clearColor().CGColor
        let beginColor = UIColor.blackColor().CGColor
        let endColor = UIColor.clearColor().CGColor
        mask.colors             = [beginColor, endColor, endColor, beginColor, endColor, endColor]
        mask.locations          = [0.0, 0.4, 0.5, 0.5, 0.9, 1.0]
        mask.path               = CGPathCreateWithEllipseInRect(frame, nil)
        mask.lineWidth          = circleWidth
        
        circle.mask = mask
        layer.addSublayer(circle)
        
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        anim.removedOnCompletion = false
        anim.repeatCount = HUGE
        anim.duration = totalDuration
        anim.keyTimes = [0.0, 0.5, 1.0]
        
        anim.values = [0.0, M_PI, M_PI * 2.0]
        
        circle.addAnimation(anim, forKey:"calmkit-anim")
        
    }
}
