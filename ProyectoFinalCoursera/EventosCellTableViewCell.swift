//
//  EventosCellTableViewCell.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 26/07/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit

class EventosCellTableViewCell: UITableViewCell {

  @IBOutlet weak var fecha: UILabel!
  @IBOutlet weak var nombre: UILabel!
  @IBOutlet weak var descripcion: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
