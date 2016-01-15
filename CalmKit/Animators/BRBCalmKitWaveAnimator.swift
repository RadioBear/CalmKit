//
//  BRBCalmKitWaveAnimator.swift
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

class BRBCalmKitWaveAnimator: BRBCalmKitAnimator {
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        let beginTime = CACurrentMediaTime() + 1.2
        let barWidth: CGFloat = size.width / 5.0
        
        for i in 0..<5 {
            let bar = CALayer()
            bar.backgroundColor = color.CGColor
            bar.frame = CGRectMake(barWidth * CGFloat(i), 0.0, barWidth - 3.0, size.height)
            bar.transform = CATransform3DMakeScale(1.0, 0.3, 0.0)
            
            let anim = CAKeyframeAnimation(keyPath: "transform")
            anim.removedOnCompletion = false
            anim.beginTime = beginTime - (1.2 - (0.1 * Double(i)))
            anim.duration = 1.2
            anim.repeatCount = HUGE
            
            anim.keyTimes = [0.0, 0.2, 0.4, 1.0]
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            ]
            
            anim.values = [
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0)),
                NSValue(CATransform3D: CATransform3DMakeScale(1.0, 0.4, 0.0)),
            ]
            
            bar.addAnimation(anim, forKey: "calmkit-anim")
            
            layer.addSublayer(bar)
        }
    }

}