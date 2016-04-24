//
//  WebViewViewController.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 24/04/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {

  @IBOutlet weak var urlText: UILabel!
  
  @IBOutlet weak var webView: UIWebView!
  
  var urls: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      urlText.text = urls
      let url = NSURL(string: urls!)
      let peticion = NSURLRequest(URL: url!)
      webView.loadRequest(peticion)

    }


}
