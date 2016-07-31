//
//  VerRutasCell.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 28/07/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit

class VerRutasCell: UITableViewCell {

  @IBOutlet weak var nombreRuta: UILabel!
  
  @IBOutlet weak var descripcionRuta: UILabel!
  
  @IBOutlet weak var imagenRuta: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
