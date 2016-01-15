//
//  BRBCalmKitWordPressAnimator.swift
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

class BRBCalmKitWordPressAnimator: BRBCalmKitAnimator {
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        let beginTime = CACurrentMediaTime()
        
        let calmness = CALayer()
        calmness.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        calmness.anchorPoint = CGPointMake(0.5, 0.5)
        calmness.transform = CATransform3DIdentity
        calmness.backgroundColor = color.CGColor
        calmness.shouldRasterize = true
        calmness.rasterizationScale = UIScreen.mainScreen().scale
        layer.addSublayer(calmness)
        
        let calmnessAnim = CAKeyframeAnimation(keyPath: "transform")
        calmnessAnim.removedOnCompletion = false
        calmnessAnim.repeatCount = HUGE
        calmnessAnim.duration = 1.0
        calmnessAnim.beginTime = beginTime
        calmnessAnim.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        
        calmnessAnim.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
        ]
        
        calmnessAnim.values = [
            NSValue(CATransform3D: CATransform3DMakeRotation(0, 0, 0, 1.0)),
            NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0, 0, 1.0)),
            NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1.0)),
            NSValue(CATransform3D: CATransform3DMakeRotation(3 * CGFloat(M_PI_2), 0, 0, 1.0)),
            NSValue(CATransform3D: CATransform3DMakeRotation(2 * CGFloat(M_PI), 0, 0, 1.0)),
        ]
        
        calmness.addAnimation(calmnessAnim, forKey:"calmkit-anim")
        
        let circleMask = CAShapeLayer()
        circleMask.frame = calmness.bounds
        circleMask.fillColor = UIColor.blackColor().CGColor
        circleMask.anchorPoint = CGPointMake(0.5, 0.5)
        
        let path = CGPathCreateMutable()
        CGPathAddEllipseInRect(path, nil, calmness.frame)
        
        let circleSize: CGFloat = size.width * 0.25;
        CGPathAddEllipseInRect(path, nil, CGRectMake(CGRectGetMidX(calmness.frame) - circleSize/2, 3.0, circleSize, circleSize))
        CGPathCloseSubpath(path)
        circleMask.path = path
        circleMask.fillRule = kCAFillRuleEvenOdd
        
        calmness.mask = circleMask
    }
}