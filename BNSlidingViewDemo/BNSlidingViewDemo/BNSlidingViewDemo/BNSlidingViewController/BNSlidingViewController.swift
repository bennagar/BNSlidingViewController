//
//  BNSlidingViewController.swift
//  BNSlidingViewDemo
//
//  Created by Ben Nagar on 1/16/16.
//  Copyright © 2016 bngr.net. All rights reserved.
//

import UIKit

protocol Slidable{
    var viewController: UIViewController {get}
    var collapsedView: UIView {get}
    var expandedView: UIView {get}
    
    func didChangeState(state:SliderState)
}

enum SliderState {
    case Collapsed
    case Expanded
}

class BNSlidingViewController: UIViewController {
    
    private(set) var currentState: SliderState = .Expanded{
        willSet{
            if newValue != currentState{
                didChangeState(newValue)
            }
        }
    }
    
    private var slider: Slidable!
    private var container:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    final func setup(sliderView sliderView:Slidable, startExpanded:Bool = true){
        
        slider = sliderView
        
        container = configInitialView(expanded: startExpanded)
        
        view.addSubview(container)
        addChildViewController(slider.viewController)
        slider.viewController.didMoveToParentViewController(self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        container.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        slider.collapsedView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didChangeState(newState:SliderState){
        slider.didChangeState(newState)
    }
    
    private func configInitialView(expanded expanded:Bool) -> UIView{
        
        slider.collapsedView.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(slider.collapsedView.frame))
        slider.expandedView.frame = CGRectOffset(view.frame, 0, CGRectGetHeight(slider.collapsedView.frame))
        
        
        let collapsedHeight = CGRectGetHeight(slider.collapsedView.frame)
        
        let containerFrame:CGRect!
        if expanded{
            containerFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y - collapsedHeight,  CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) + collapsedHeight)
        }
        else{
            containerFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y - collapsedHeight + CGRectGetHeight(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) + collapsedHeight)
        }
        
        let container = UIView(frame: containerFrame)
        container.addSubview(slider.collapsedView)
        container.addSubview(slider.expandedView)
        
        return container
    }
    
    private func changeCollapsedViewAlfa(containerOrigin containerOrigin: CGFloat, total:CGFloat){
        let alfa = (containerOrigin + CGRectGetMaxY(slider.collapsedView.frame)) / (total)
        changeCollapsedViewAlfa(alfa)
    }
    private func changeCollapsedViewAlfa(alfa:CGFloat){
        slider.collapsedView.alpha = alfa
    }
    
    func animatePanel(shouldExpand shouldExpand: Bool){
        if (shouldExpand) {
            currentState = .Expanded
            
            animatePanelYPosition(targetPosition: -CGRectGetHeight(slider.collapsedView.frame))
            
        } else {
            animatePanelYPosition(targetPosition: CGRectGetHeight(view.frame) - CGRectGetHeight(slider.collapsedView.frame) ) { finished in
                self.currentState = .Collapsed
            }
        }
    }
    
    private func animatePanelYPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.container.frame.origin.y = targetPosition
            self.changeCollapsedViewAlfa( targetPosition > 0 ? 1.0 : 0.0 )
            }, completion: completion)
    }
}

extension BNSlidingViewController: UIGestureRecognizerDelegate {
    
    final func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        switch(recognizer.state) {
        case .Began:
            
            let velocity = recognizer.velocityInView(container).y
            switch(currentState) {
            case .Expanded:
                guard velocity > 0 else {
                    abortCurrentRecognizer(recognizer)
                    return
                }
            case .Collapsed:
                guard velocity < 0 else {
                    abortCurrentRecognizer(recognizer)
                    return
                }
            }
            
            if  velocity > 600 || velocity < -220{
                animatePanel(shouldExpand: velocity < 0)
            }
        case .Changed:
            recognizer.view!.center.y = recognizer.view!.center.y + recognizer.translationInView(container).y
            recognizer.setTranslation(CGPointZero, inView: container)
            changeCollapsedViewAlfa(containerOrigin: recognizer.view!.frame.origin.y, total: CGRectGetHeight(view.bounds))
        case .Ended:
            let hasMovedGreaterThanHalfway = recognizer.view!.center.y < (CGRectGetHeight(view.bounds))
            animatePanel(shouldExpand: hasMovedGreaterThanHalfway)
        default:
            break
        }
    }
    
    private func abortCurrentRecognizer(recognizer: UIPanGestureRecognizer){
        recognizer.enabled = false
        recognizer.enabled = true
    }
    
    final func handleTapGesture(recognizer: UITapGestureRecognizer){
        animatePanel(shouldExpand: true)
    }
    
}