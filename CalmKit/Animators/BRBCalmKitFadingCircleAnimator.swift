//
//  BRBCalmKitFadingCircleAnimator.swift
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

class BRBCalmKitFadingCircleAnimator: BRBCalmKitAnimator {
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        let beginTime = CACurrentMediaTime()
        
        let radius: CGFloat =  size.width / 2
        let squareSize: CGFloat = size.width / 6
        
        for i in 0..<12 {
            let square = CALayer()
            
            let angle: Double = Double(i) * (M_PI_2/3.0)
            let x: CGFloat = radius + CGFloat(sin(angle)) * radius
            let y: CGFloat = radius - CGFloat(cos(angle)) * radius
            square.frame = CGRectMake(x, y, squareSize, squareSize)
            square.backgroundColor = color.CGColor
            square.anchorPoint = CGPointMake(0.5, 0.5)
            square.opacity = 0.0
            square.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(angle), 0, 0, 1.0)
            
            let anim = CAKeyframeAnimation(keyPath: "opacity")
            anim.removedOnCompletion = false
            anim.repeatCount = HUGE
            anim.duration = 1.0
            anim.beginTime = beginTime + (0.084 * Double(i))
            anim.keyTimes = [0.0, 0.5, 1.0]
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            ]
            
            anim.values = [1.0, 0.0, 0.0]
            
            layer.addSublayer(square)
            square.addAnimation(anim, forKey: "calmkit-anim")
        }
    }
}
