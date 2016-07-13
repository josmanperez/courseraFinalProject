//
//  PtoInteresViewController.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 23/04/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit
import MapKit

protocol CommunicationControllerDelegate {
  func setPunto(nombre:String, imagen: UIImage?, coordenadas:CLLocationCoordinate2D)
}

class PtoInteresViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var nombre: UITextField!
  
  @IBOutlet weak var camaraBoton: UIButton!
  
  @IBOutlet weak var fotoVista: UIImageView!
  
  var imagenPunto:UIImage?
  
  var communicationDelegate:CommunicationControllerDelegate?
  
  private let miPicker = UIImagePickerController()
  
  var coordenadas:CLLocationCoordinate2D?
  
  var puntoInteres: PtoInteres?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if (!UIImagePickerController.isSourceTypeAvailable(.Camera)) {
      camaraBoton.hidden = true
    }
    
    miPicker.delegate = self
    
    if let coordenadasP = coordenadas {
      print("lat: \(coordenadasP.latitude) Long: \(coordenadasP.longitude)")
    }
    
  }
  
  override func  preferredStatusBarStyle()-> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  @IBAction func textFieldDoneEditing(sender : UITextField) {
    sender.resignFirstResponder()
  }
  
  @IBAction func backgroundTap(sender: UIControl) {
    self.nombre.resignFirstResponder()
  }
  
  @IBAction func anadirFotoCamara() {
    miPicker.sourceType = UIImagePickerControllerSourceType.Camera
    presentViewController(miPicker, animated: true, completion: nil)
  }
  
  @IBAction func anadirFotoAlbum() {
    miPicker.sourceType = .PhotoLibrary
    presentViewController(miPicker, animated: true, completion: nil)
    
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    
    self.imagenPunto = image
    fotoVista.image = image
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func exitPto() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func anadirPto() {
    
    if (nombre.text?.characters.count > 0) {
      //print("nombre: \(nombre.text!)")
      //print("imagen: \(imagenPunto)")
      //print("lat: \(coordenadas!.latitude)")
      
      if let coor = coordenadas {
        communicationDelegate?.setPunto(nombre.text!, imagen: imagenPunto, coordenadas: coor)
        self.dismissViewControllerAnimated(true, completion: nil)
      } else {
        self.dismissViewControllerAnimated(true, completion: nil)

      }
      
    } else {
      let alert = UIAlertController(title: "Por favor introduce un nombre", message: "Debes introducir un nombre como mínimo para guardar el punto de interés", preferredStyle: UIAlertControllerStyle.ActionSheet)
      alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
      }))
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
}
