//
//  ViewController.swift
//  BottomSheet
//
//  Created by Chung Sama on 9/10/17.
//  Copyright © 2017 Chung Sama. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBottomSheetView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBottomSheetView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: "ScrollView")
//        let bottomSheetVC = BottomSheetViewController()
        
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
}

