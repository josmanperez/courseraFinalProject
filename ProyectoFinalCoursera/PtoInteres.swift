//
//  PtoInteres.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 23/04/16.
//  Copyright © 2016 personal. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PtoInteres: MKPointAnnotation {
  
  var nombre:String
  var imagen:UIImage? = nil
  
  var coordenadas: CLLocationCoordinate2D
  
  init(nombre: String, imagen: UIImage?, coordenadas: CLLocationCoordinate2D) {
    self.nombre = nombre
    if let imagenR = imagen {
      self.imagen = imagenR
    }
    self.coordenadas = coordenadas
  }
  
  
  init(nombre: String, coordenadas: CLLocationCoordinate2D) {
    self.nombre = nombre 
    self.coordenadas = coordenadas
  }
  
}
