//
//  BRBCalmKitCubeGridAnimator.swift
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

class BRBCalmKitCubeGridAnimator: BRBCalmKitAnimator {
    
    let fullSquareBeginRate: Double = 0.4
    let fullSquareEndRate: Double = 0.6
    
    // square count is (matrixSize * matrixSize)
    var matrixSize: Int = 3
    var totalDuration: Double = 1.5
    
    func setupAnimation(inLayer layer : CALayer, withSize size : CGSize, withColor color : UIColor) {
        
        if self.matrixSize <= 0 {
            return ;
        }
        
        let beginTime = CACurrentMediaTime()
        let increaseTime: NSTimeInterval = ((self.fullSquareEndRate - self.fullSquareBeginRate) * self.totalDuration) / Double(self.matrixSize)
        
        let squareSize : CGFloat = size.width / CGFloat(self.matrixSize)
        
        for sum in 0...((self.matrixSize * 2) - 2) {
            for x in 0..<self.matrixSize {
                for y in 0..<self.matrixSize {
                    if x + y == sum {
                        let square = CALayer()
                        square.frame = CGRectMake(CGFloat(x) * squareSize, CGFloat(y) * squareSize, squareSize, squareSize)
                        square.backgroundColor = color.CGColor
                        square.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
                        
                        let anim = CAKeyframeAnimation(keyPath: "transform")
                        anim.removedOnCompletion = false
                        anim.repeatCount = HUGE
                        anim.duration = self.totalDuration
                        anim.beginTime = beginTime + (increaseTime * Double(sum))
                        anim.keyTimes = [0.0, self.fullSquareBeginRate, self.fullSquareEndRate, 1.0]
                        
                        anim.timingFunctions = [
                            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                        ]
                        
                        anim.values = [
                            NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0)),
                            NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
                            NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 0.0)),
                            NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0)),
                        ]
           
                        layer.addSublayer(square)
                        square.addAnimation(anim, forKey: "calmkit-anim")
                    }
                }
            }
        }
    }
    
}