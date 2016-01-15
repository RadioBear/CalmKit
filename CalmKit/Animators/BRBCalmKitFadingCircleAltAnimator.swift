//
//  BRBCalmKitFadingCircleAltAnimator.swift
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

class BRBCalmKitFadingCircleAltAnimator: BRBCalmKitAnimator {
    
    let degToRad: Double = 0.0174532925
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        let beginTime = CACurrentMediaTime()
        
        let radius: CGFloat =  size.width / 2
        
        for i in 0..<12 {
            let circle = CALayer()
            circle.backgroundColor = color.CGColor
            circle.anchorPoint = CGPointMake(0.5, 0.5)
            circle.frame = CGRectMake(radius + CGFloat(cos(degToRad * (30.0 * Double(i)))) * radius , radius + CGFloat(sin(degToRad * (30.0 * Double(i)))) * radius, radius / 2, radius / 2)
            circle.shouldRasterize = true
            circle.rasterizationScale = UIScreen.mainScreen().scale
            circle.cornerRadius = circle.bounds.height * 0.5
            
            let transformAnimation = CAKeyframeAnimation(keyPath: "transform")
            
            transformAnimation.values = [
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0)),
            ]
            
            let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
            
            opacityAnimation.values = [
                1.0,
                0.0,
            ]
            
            let animationGroup = CAAnimationGroup()
            animationGroup.removedOnCompletion = false
            animationGroup.repeatCount = HUGE
            animationGroup.duration = 1.2
            animationGroup.beginTime = beginTime - (1.2 - (0.1 * Double(i)))
            animationGroup.animations = [transformAnimation, opacityAnimation]
            circle.addAnimation(animationGroup, forKey: "calmkit-anim")
            layer.addSublayer(circle)
        }

    }
}
