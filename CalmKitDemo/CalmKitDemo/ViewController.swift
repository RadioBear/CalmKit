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
    
    var mainScrollView: UIScrollView!
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
        self.mainScrollView = scrollView
        
        self.p_insertCalmKitView(BRBCalmKitDropBallAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitDoubleArcAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitPairFadingRingAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitFadingRingAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitSpectrumColumnAnimator())
        
        self.p_insertCalmKitView(BRBCalmKitBigDonutAnimator())
        
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
        backgroundLayer.bounds = backgroundBounds
        backgroundLayer.anchorPoint = CGPointMake(0, 0)
        backgroundLayer.position = CGPointMake(0, 0)
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
    
    
    @available(iOS 8.0, *)
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({
            (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.p_refreshWhenRotationOrientation()
            }) {
                (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                
                
        }
        
    }
    
    @available(iOS, introduced=2.0, deprecated=8.0)
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        self.p_refreshWhenRotationOrientation()
    }


    private func p_insertCalmKitView(animator : BRBCalmKitAnimator) {
        let parentView = self.view
        let viewBounds = self.view.bounds
        
        let panel = UIView(frame: CGRectOffset(viewBounds, viewBounds.width * CGFloat(self.numberOfCalmness), 0.0))
        panel.backgroundColor = UIColor.clearColor()
        panel.translatesAutoresizingMaskIntoConstraints = false
       
        let calmKitView = BRBCalmKitView(withAnimator: animator)
        calmKitView.calmnessSize = 50
        calmKitView.sizeToFit()
        calmKitView.center = CGPointMake(viewBounds.midX, viewBounds.midY)
        calmKitView.translatesAutoresizingMaskIntoConstraints = false
        calmKitView.startAnimating()
        
        panel.addSubview(calmKitView)
        panel.addConstraint(NSLayoutConstraint(item: calmKitView, attribute: .CenterX, relatedBy: .Equal, toItem: panel, attribute: .CenterX, multiplier: 1, constant: 0))
        panel.addConstraint(NSLayoutConstraint(item: calmKitView, attribute: .CenterY, relatedBy: .Equal, toItem: panel, attribute: .CenterY, multiplier: 1, constant: 0))
        
        let label = UILabel(frame: CGRectMake(0, 50.0, viewBounds.width, 30.0))
        label.text = String(animator.dynamicType)
        label.font = UIFont.systemFontOfSize(25.0)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clearColor()
        
        panel.addSubview(label)
        panel.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: panel, attribute: .CenterX, multiplier: 1, constant: 0))
        panel.addConstraint(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: panel, attribute: .Top, multiplier: 1, constant: 50))
        panel.addConstraint(NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: panel, attribute: .Width, multiplier: 1, constant: 0))
        
        let lastView = parentView.subviews.last
        parentView.addSubview(panel)
        parentView.addConstraint(NSLayoutConstraint(item: panel, attribute: .Width, relatedBy: .Equal, toItem: parentView, attribute: .Width, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: panel, attribute: .Height, relatedBy: .Equal, toItem: parentView, attribute: .Height, multiplier: 1, constant: 0))
        if parentView.subviews.count > 0 && lastView != nil {
            parentView.addConstraint(NSLayoutConstraint(item: panel, attribute: .Left, relatedBy: .Equal, toItem: lastView, attribute: .Right, multiplier: 1, constant: 0))
        } else {
            parentView.addConstraint(NSLayoutConstraint(item: panel, attribute: .Left, relatedBy: .Equal, toItem: parentView, attribute: .Left, multiplier: 1, constant: 0))
        }
        
        ++self.numberOfCalmness
    }
    
    
    private func p_refreshWhenRotationOrientation() {
        let oldPageSize = self.mainScrollView.contentSize.width / CGFloat(self.numberOfCalmness)
        let pageIndex = floor(self.mainScrollView.contentOffset.x / oldPageSize)
        
        let viewBounds = self.mainScrollView.bounds
        self.mainScrollView.contentSize = CGSizeMake(CGFloat(self.numberOfCalmness) * viewBounds.width, viewBounds.height)
        let newPageSize = viewBounds.width
        self.mainScrollView.contentOffset.x = newPageSize * pageIndex
        
        if let backgroundLayer = self.mainScrollView.layer.sublayers?.first {
            let scrollBounds = self.view.bounds
            let backgroundBounds = CGRectMake(scrollBounds.origin.x, scrollBounds.origin.y, scrollBounds.width * CGFloat(self.numberOfCalmness), scrollBounds.height)
            backgroundLayer.bounds = backgroundBounds
            backgroundLayer.anchorPoint = CGPointMake(0, 0)
            backgroundLayer.position = CGPointMake(0, 0)
        }
    }
}

