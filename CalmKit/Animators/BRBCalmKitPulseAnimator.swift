//
//  BRBCalmKitPulseAnimator.swift
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

class BRBCalmKitPulseAnimator: BRBCalmKitAnimator {
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        let beginTime = CACurrentMediaTime()
        
        let circle = CALayer()
        circle.frame = CGRectInset(CGRectMake(0.0, 0.0, size.width, size.height), 2.0, 2.0)
        circle.backgroundColor = color.CGColor
        circle.anchorPoint = CGPointMake(0.5, 0.5)
        circle.opacity = 1.0
        circle.cornerRadius = circle.bounds.height * 0.5
        circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        
        let scaleAnim = CAKeyframeAnimation(keyPath: "transform")
        scaleAnim.values = [
            NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0)),
            NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
        ]
        
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.values = [
            1.0,
            0.0
        ]
        
        let animGroup = CAAnimationGroup()
        animGroup.removedOnCompletion = false
        animGroup.beginTime = beginTime
        animGroup.repeatCount = HUGE
        animGroup.duration = 1.0
        animGroup.animations = [scaleAnim, opacityAnim]
        animGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        layer.addSublayer(circle)
        circle.addAnimation(animGroup, forKey: "calmkit-anim")
    }
}
