//
//  SlidingPanelViewController.swift
//  BNSlidingViewDemo
//
//  Created by Ben Nagar on 1/16/16.
//  Copyright © 2016 bngr.net. All rights reserved.
//

import UIKit

class SlidingPanelViewController: UIViewController {
    
    @IBOutlet var myCollapsedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension SlidingPanelViewController: Slidable{
    
    var viewController:UIViewController {
        get{
            return self
        }
    }
    
    var collapsedView: UIView {
        get{
            return myCollapsedView
        }
    }
    
    var expandedView: UIView {
        get{
            return view
        }
    }
    
    func didChangeState(state: SliderState) {
        
    }
}