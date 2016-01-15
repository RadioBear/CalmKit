//
//  BRBCalmKitSideBounceAnimator.swift
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

class BRBCalmKitSideBounceAnimator: BRBCalmKitAnimator {
    
    var circleCount: Int = 3
    var totalDuration: NSTimeInterval = 1.5
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        
        let beginTime = CACurrentMediaTime()
        
        let offset: CGFloat = size.width / CGFloat((circleCount * 2) + (circleCount - 1))
        let circleSize: CGFloat = offset * 2
        let increaseTime: NSTimeInterval = totalDuration / Double(circleCount) / 2
        
        for i in 0..<circleCount {
            let circle = CALayer()
            circle.frame = CGRectMake(CGFloat(i) * 3 * offset, size.height / 2, circleSize, circleSize)
            circle.backgroundColor = color.CGColor
            circle.anchorPoint = CGPointMake(0.5, 0.5)
            circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5
            circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            
            let anim = CAKeyframeAnimation(keyPath: "transform")
            anim.removedOnCompletion = false
            anim.repeatCount = HUGE
            anim.duration = totalDuration
            anim.beginTime = beginTime + (increaseTime * Double(i))
            anim.keyTimes = [0.0, 0.5, 1.0]
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            ]
            
            anim.values = [
                NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0)),
            ]
            
            layer.addSublayer(circle)
            circle.addAnimation(anim, forKey:"calmkit-anim")
        }
    }
}
