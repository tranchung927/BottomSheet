//
//  ScrollableBottomSheetViewController.swift
//  BottomSheet
//
//  Created by Chung Sama on 9/10/17.
//  Copyright © 2017 Chung Sama. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaultHeightBottomSheetView: CGFloat = 100
    var maxHeightBottomSheetView: CGFloat {
        return UIScreen.main.bounds.height - 150
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.maxHeightBottomSheetView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 100)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if (y + translation.y >= defaultHeightBottomSheetView) && (y + translation.y <= maxHeightBottomSheetView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        // If end pan
        if recognizer.state == .ended {
            var duration = velocity.y < 0 ? Double((y - maxHeightBottomSheetView) / -velocity.y ) : Double ((defaultHeightBottomSheetView - y) / velocity.y )
            duration = duration > 1.3 ? 1 : duration
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.maxHeightBottomSheetView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.defaultHeightBottomSheetView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.tableView.isScrollEnabled = true
                }
            })
        }
    }
}


extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

extension BottomSheetViewController: UIGestureRecognizerDelegate {
    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == defaultHeightBottomSheetView && tableView.contentOffset.y == 0 && direction > 0) || (y == maxHeightBottomSheetView) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        
        return false
    }
}
