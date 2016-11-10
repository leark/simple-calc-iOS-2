//
//  HistoryViewController.swift
//  simple-calc
//
//  Created by iGuest on 11/10/16.
//  Copyright © 2016 iSchool. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    let screenSize: CGRect = UIScreen.main.bounds
    var history = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for i in 0..<history.count {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: 100, y: i * 21)
            label.textAlignment = .left
            label.text = history[i]
            self.scrollView.addSubview(label)
        }
        
        scrollView.contentSize = CGSize(width: 200, height: history.count * 21)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToCalc(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
