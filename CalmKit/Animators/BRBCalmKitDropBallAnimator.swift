//
//  BRBCalmKitDropBallAnimator.swift
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

class BRBCalmKitDropBallAnimator: BRBCalmKitAnimator {
    
    var circleCount: Int = 3
    var totalDuration: NSTimeInterval = 1.5
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        
        if circleCount <= 0 {
            return ;
        }
        
        let beginTime = CACurrentMediaTime()
        
        let offset: CGFloat = size.width / CGFloat((circleCount * 2) + (circleCount - 1))
        let circleSize: CGFloat = offset * 2
        let increaseTime: NSTimeInterval = totalDuration / Double(circleCount) / 2
        
        for i in 0..<circleCount {
            let circle = CALayer()
            circle.frame = CGRectMake(CGFloat(i) * 3 * offset, 0.0, circleSize, circleSize)
            circle.anchorPoint = CGPointMake(0.5, 0.5)
            circle.backgroundColor = color.CGColor
            circle.cornerRadius = circle.bounds.height * 0.5
            circle.shouldRasterize = true
            layer.addSublayer(circle)
            
            let anim = CAKeyframeAnimation(keyPath: "transform")
            anim.removedOnCompletion = false
            anim.repeatCount = HUGE
            anim.duration = totalDuration
            anim.beginTime = beginTime + (increaseTime * Double(i))
            anim.keyTimes = [0.0, 0.4, 0.5, 0.6, 1.0]
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
            ]
            
            let dropDistance = size.height - circleSize
            let t1 = CATransform3DMakeTranslation(0.0, dropDistance, 0.0)
            var t2 = CATransform3DMakeTranslation(0.0, dropDistance + (circleSize * 0.5), 0.0)
            t2 = CATransform3DScale(t2, 1.5, 0.5, 1.0)
            let t3 = t1
            let t4 = CATransform3DIdentity
            anim.values = [
                NSValue(CATransform3D: CATransform3DIdentity),
                NSValue(CATransform3D: t1),
                NSValue(CATransform3D: t2),
                NSValue(CATransform3D: t3),
                NSValue(CATransform3D: t4),
            ]
            
            circle.addAnimation(anim, forKey:"calmkit-anim")
            
            let shadow = CALayer()
            shadow.frame = CGRectMake(CGFloat(i) * 3 * offset, size.height - (circleSize * 0.25), circleSize, circleSize)
            shadow.anchorPoint = CGPointMake(0.5, 0.5)
            shadow.backgroundColor = color.CGColor
            shadow.cornerRadius = circle.bounds.height * 0.5
            shadow.opacity = 0.5
            shadow.transform = CATransform3DMakeScale(0.0, 0.0, 1.0)
            shadow.shouldRasterize = true
            layer.addSublayer(shadow)
            
            let shadowAnimOpacity = CAKeyframeAnimation(keyPath: "opacity")
            shadowAnimOpacity.keyTimes = [0.0, 0.4, 0.5, 0.6, 1.0]
            
            shadowAnimOpacity.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
            ]
            
            shadowAnimOpacity.values = [
                0.0,
                0.2,
                0.4,
                0.2,
                0.0,
            ]
            
            let shadowAnimTransform = CAKeyframeAnimation(keyPath: "transform")
            shadowAnimTransform.keyTimes = [0.0, 0.4, 0.5, 0.6, 1.0]
            
            shadowAnimTransform.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
            ]
        
            shadowAnimTransform.values = [
                NSValue(CATransform3D: CATransform3DMakeScale(0.3, 0.1, 1.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.3, 1.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.6, 0.4, 1.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.3, 1.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(0.3, 0.1, 1.0)),
            ]
            
            let animGroup = CAAnimationGroup()
            animGroup.removedOnCompletion = false
            animGroup.beginTime = beginTime + (increaseTime * Double(i))
            animGroup.repeatCount = HUGE
            animGroup.duration = totalDuration
            animGroup.animations = [shadowAnimOpacity, shadowAnimTransform]
            
            shadow.addAnimation(animGroup, forKey:"calmkit-shadow anim")
        }
    }
}