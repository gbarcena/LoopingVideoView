//
//  ViewController.swift
//  LoopingVideoView
//
//  Created by Gustavo Barcena on 4/11/15.
//
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var videoView : LoopingVideoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

