//
//  BRBCalmKitView.swift
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


class BRBCalmKitView : UIView {
    var animator: BRBCalmKitAnimator? {
        didSet {
            if self.animating {
                self.p_pauseLayers()
                self.p_applyAnimation()
                self.p_resumeLayers()
            } else {
                self.dirty = true
            }
        }
    }
    
    var color: UIColor = UIColor.whiteColor() {
        didSet {
            if let sublayers = self.layer.sublayers {
                for layer in sublayers {
                    layer.backgroundColor = self.color.CGColor
                }
            }
        }
    }
    
    var calmnessSize: CGFloat = 37.0 {
        didSet {
            if self.animating {
                self.p_pauseLayers()
                self.p_applyAnimation()
                self.p_resumeLayers()
            } else {
                self.dirty = true
            }
            self.invalidateIntrinsicContentSize()
        }
    }
    var hidesWhenStopped: Bool = true
    private var animating: Bool = false
    private var dirty: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(withAnimator animator : BRBCalmKitAnimator) {
        super.init(frame: CGRectMake(0.0, 0.0, self.calmnessSize, self.calmnessSize))
        
        self.animator = animator
        self.sizeToFit()
        self.hidden = true
    }
    
    init(withAnimator animator : BRBCalmKitAnimator, withSize calmnessSize : CGFloat, withColor color : UIColor) {
        super.init(frame: CGRectMake(0.0, 0.0, calmnessSize, calmnessSize))
        
        self.animator = animator
        self.color = color
        self.calmnessSize = calmnessSize
        self.sizeToFit()
        self.hidden = true
    }
    
    
    func startAnimating() {
        if !self.animating {
            
            if self.dirty {
                self.p_applyAnimation()
                self.dirty = false
            }
            
            if self.hidden {
                self.p_resetLayers()
                self.hidden = false
            } else {
                self.p_resumeLayers()
            }
            self.animating = true
        }
    }
    
    func stopAnimating() {
        if self.animating {
            if self.hidesWhenStopped {
                self.hidden = true
            }
            
            self.p_pauseLayers()
            self.animating = false
        }
    }
    
    func isAnimating() -> Bool {
        return self.animating
    }
    
    
    private func p_applyAnimation() {
        // remove all sublayers
        self.layer.sublayers = nil
        
        if let animator = self.animator {
            let size = CGSizeMake(self.calmnessSize, self.calmnessSize)
            animator.setupAnimation(inLayer: self.layer, withSize: size, withColor: self.color)
        }
    }
    
    private func p_pauseLayers() {
        let pausedTime = self.layer.convertTime(CACurrentMediaTime(), fromLayer:nil)
        self.layer.speed = 0.0
        self.layer.timeOffset = pausedTime
    }

    private func p_resumeLayers() {
        let pausedTime = self.layer.timeOffset
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        let timeSincePause = self.layer.convertTime(CACurrentMediaTime(), fromLayer:nil) - pausedTime
        self.layer.beginTime = timeSincePause
    }
    
    private func p_resetLayers(){
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(self.calmnessSize, self.calmnessSize)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSizeMake(self.calmnessSize, self.calmnessSize)
    }
}
