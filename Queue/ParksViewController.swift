//
//  ParksViewController.swift
//  Queue
//
//  Created by Adam Binsz on 12/16/15.
//  Copyright © 2015 Adam Binsz. All rights reserved.
//

import UIKit

class ParksViewController: UIViewController {

    let parksManager = ParksManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        parksManager.fetchAttractionsFor(.MagicKingdom) { park, error in
            
            let rawValues = park?.attractions.map{$0.rawValue}
            print(rawValues)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

