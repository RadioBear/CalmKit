//
//  BRBCalmKitWanderingCubesAnimator.swift
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

class BRBCalmKitWanderingCubesAnimator: BRBCalmKitAnimator {
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        let beginTime = CACurrentMediaTime()
        let cubeSize: CGFloat = floor(size.width / 3.0)
        let widthMinusCubeSize: CGFloat = size.width - cubeSize
        
        for i in 0..<2 {
            let cube = CALayer()
            cube.backgroundColor = color.CGColor
            cube.frame = CGRectMake(0.0, 0.0, cubeSize, cubeSize)
            cube.anchorPoint = CGPointMake(0.5, 0.5)
            cube.shouldRasterize = true
            cube.rasterizationScale = UIScreen.mainScreen().scale
            
            let anim = CAKeyframeAnimation(keyPath: "transform")
            anim.removedOnCompletion = false
            anim.beginTime = beginTime - (Double(i) * 0.9)
            anim.duration = 1.8
            anim.repeatCount = HUGE
            
            anim.keyTimes = [0.0, 0.25, 0.50, 0.75, 1.0]
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            ]
            
            let t0 = CATransform3DIdentity
            
            var t1 = CATransform3DMakeTranslation(widthMinusCubeSize, 0.0, 0.0)
            t1 = CATransform3DRotate(t1, p_degToRad(-90.0), 0.0, 0.0, 1.0)
            t1 = CATransform3DScale(t1, 0.5, 0.5, 1.0)
            
            var t2 = CATransform3DMakeTranslation(widthMinusCubeSize, widthMinusCubeSize, 0.0)
            t2 = CATransform3DRotate(t2, p_degToRad(-180.0), 0.0, 0.0, 1.0)
            t2 = CATransform3DScale(t2, 1.0, 1.0, 1.0)
            
            var t3 = CATransform3DMakeTranslation(0.0, widthMinusCubeSize, 0.0)
            t3 = CATransform3DRotate(t3, p_degToRad(-270.0), 0.0, 0.0, 1.0)
            t3 = CATransform3DScale(t3, 0.5, 0.5, 1.0)
            
            var t4 = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
            t4 = CATransform3DRotate(t4, p_degToRad(-360.0), 0.0, 0.0, 1.0)
            t4 = CATransform3DScale(t4, 1.0, 1.0, 1.0)
            
            anim.values = [
                NSValue(CATransform3D: t0),
                NSValue(CATransform3D: t1),
                NSValue(CATransform3D: t2),
                NSValue(CATransform3D: t3),
                NSValue(CATransform3D: t4),
            ]
            
            layer.addSublayer(cube)
            cube.addAnimation(anim, forKey: "calmkit-anim")
        }
    }
}
