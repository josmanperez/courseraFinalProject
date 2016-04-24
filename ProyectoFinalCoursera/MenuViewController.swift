//
//  ViewController.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 23/04/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
  }

  @IBAction func showRuta() {
    
    performSegueWithIdentifier("showRuta", sender: nil)
  }
}

