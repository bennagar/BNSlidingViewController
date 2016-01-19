//
//  ViewController.swift
//  BNSlidingViewDemo
//
//  Created by Ben Nagar2 on 1/16/16.
//  Copyright © 2016 bngr.net. All rights reserved.
//

import UIKit

class ViewController: BNSlidingViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let slider = sb.instantiateViewControllerWithIdentifier("slidingPanel") as! SlidingPanelViewController
        setup(sliderView: slider, startExpanded: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didChangeState(newState: SliderState) {
        super.didChangeState(newState)
        print(newState)
    }
}

