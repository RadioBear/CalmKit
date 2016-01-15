//
//  BRBCalmKitDotDonutAnimator.swift
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

class BRBCalmKitDotDonutAnimator: BRBCalmKitAnimator {
    
    var circleCount: Int = 3
    var totalDuration: NSTimeInterval = 2.0
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        
        let beginTime = CACurrentMediaTime()
        
        let offset: CGFloat = size.width / CGFloat((circleCount * 2) + (circleCount - 1))
        let circleSize: CGFloat = offset * 2
        let increaseTime: NSTimeInterval = totalDuration / Double(circleCount) / 2
        
        for i in 0..<circleCount {
            let calmness = CALayer()
            calmness.frame = CGRectMake(CGFloat(i) * 3 * offset, size.height / 2, circleSize, circleSize)
            calmness.anchorPoint = CGPointMake(0.5, 0.5)
            calmness.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            calmness.backgroundColor = color.CGColor
            calmness.opacity = 0.0;
            calmness.shouldRasterize = true
            layer.addSublayer(calmness)
            
            let calmnessScaleAnim = CAKeyframeAnimation(keyPath: "transform")

            calmnessScaleAnim.keyTimes = [0.0, 0.4, 0.6, 1.0]

            calmnessScaleAnim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            ]
            
            calmnessScaleAnim.values = [
                NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(0.5, 0.5, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(0.5, 0.5, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
            ]
            
            let calmnessOpacityAnim = CAKeyframeAnimation(keyPath: "opacity")
            
            calmnessOpacityAnim.keyTimes = [0.0, 0.4, 0.6, 1.0]

            calmnessOpacityAnim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            ]
            
            calmnessOpacityAnim.values = [0.0, 1.0, 1.0, 1.0]
            
            let animGroup = CAAnimationGroup()
            animGroup.removedOnCompletion = false
            animGroup.beginTime = beginTime + (increaseTime * Double(i))
            animGroup.repeatCount = HUGE
            animGroup.duration = totalDuration
            animGroup.animations = [calmnessScaleAnim, calmnessOpacityAnim]
            
            calmness.addAnimation(animGroup, forKey:"calmness-anim")
            
            
            
            let orgMaskPath = CGPathCreateWithEllipseInRect(calmness.bounds, nil)
            let beginMaskPath = CGPathCreateMutableCopy(orgMaskPath)!
            CGPathAddEllipseInRect(beginMaskPath, nil, CGRectMake(calmness.bounds.midX, calmness.bounds.midY, 0.0, 0.0))
            CGPathCloseSubpath(beginMaskPath)
            let endMaskPath = CGPathCreateMutableCopy(orgMaskPath)!
            CGPathAddEllipseInRect(endMaskPath, nil, calmness.bounds)
            CGPathCloseSubpath(endMaskPath)
            
            let circleMask = CAShapeLayer()
            circleMask.frame = calmness.bounds
            circleMask.fillColor = UIColor.blackColor().CGColor
            circleMask.anchorPoint = CGPointMake(0.5, 0.5)
            circleMask.fillRule = kCAFillRuleEvenOdd
            circleMask.path = orgMaskPath
            
            let maskAnim = CAKeyframeAnimation(keyPath: "path")
            maskAnim.removedOnCompletion = false
            maskAnim.repeatCount = HUGE
            maskAnim.duration = totalDuration
            maskAnim.beginTime = beginTime + (increaseTime * Double(i))
            maskAnim.keyTimes = [0.0, 0.4, 0.6, 1.0]
            
            maskAnim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            ]
            
            maskAnim.values = [orgMaskPath, orgMaskPath, beginMaskPath, endMaskPath]

            circleMask.addAnimation(maskAnim, forKey:"calmnessMask-anim")
            
            calmness.mask = circleMask
        }
    }
}