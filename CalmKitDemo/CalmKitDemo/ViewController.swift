//
//  ViewController.swift
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

class ViewController: UIViewController {
    
    
    var numberOfCalmness = 0
    
    override func loadView() {
        
        let screenBounds = UIScreen.mainScreen().bounds
        let scrollView = UIScrollView()
        scrollView.bounds = screenBounds
        scrollView.pagingEnabled = true
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.directionalLockEnabled = true
        scrollView.backgroundColor = UIColor.darkGrayColor()
        self.view = scrollView
        
        self.p_insertCalmKitView(BRBCalmKitDotDonutAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitWanderingCubesAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitFadingCircleAltAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitFadingCircleAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitPulseAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitArcAltAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitArcAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitWordPressAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitWaveAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitPlaneFlipAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitCircleFlipAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitCubeGridAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitBounceAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitChasingDotsAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitCircleAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitSideBounceAnimator())
        
        scrollView.contentSize = CGSizeMake(CGFloat(self.numberOfCalmness) * screenBounds.width, screenBounds.height)
        
        let backgroundLayer = CAGradientLayer()
        let scrollBounds = self.view.bounds
        let backgroundBounds = CGRectMake(scrollBounds.origin.x, scrollBounds.origin.y, scrollBounds.width * CGFloat(self.numberOfCalmness), scrollBounds.height)
        backgroundLayer.frame = backgroundBounds
        backgroundLayer.colors = [UIColor.orangeColor().CGColor, UIColor.magentaColor().CGColor, UIColor.purpleColor().CGColor]
        backgroundLayer.locations = [0.0, 0.5, 1.0]
        backgroundLayer.startPoint = CGPointMake(0.0, 0.5)
        backgroundLayer.endPoint = CGPointMake(1.0, 0.5)
        scrollView.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    private func p_insertCalmKitView(animator : BRBCalmKitAnimator) {
        let viewBounds = self.view.bounds
       
        let calmKitView = BRBCalmKitView(withAnimator: animator)
        calmKitView.center = CGPointMake(viewBounds.midX, viewBounds.midY)
        calmKitView.startAnimating()
        
        let panel = UIView(frame: CGRectOffset(viewBounds, viewBounds.width * CGFloat(self.numberOfCalmness), 0.0))
        panel.backgroundColor = UIColor.clearColor()
        panel.addSubview(calmKitView)
        
        let label = UILabel(frame: CGRectMake(0, 50.0, viewBounds.width, 30.0))
        label.text = String(animator.dynamicType)
        label.font = UIFont.systemFontOfSize(25.0)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = UIColor.clearColor()
        
        panel.addSubview(label)
        
        self.view.addSubview(panel)
        
        ++self.numberOfCalmness
    }
}

