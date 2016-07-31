//
//  SaveRouteViewController.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 24/04/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit
import CoreData

protocol SaveRouteControllerDelegate {
  func saveRoute(nombre: String, descripcion: String, imagen: UIImage?)
}

class SaveRouteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var nombreTextField: UITextField!
  
  @IBOutlet weak var descripcionTextField: UITextField!
  
  @IBOutlet weak var image: UIImageView!
  
  @IBOutlet weak var camaraBoton: UIButton!
  
  private let miPicker = UIImagePickerController()
  
  var imagenPunto:UIImage?
  
  var communicationDelegate:SaveRouteControllerDelegate?
  
  var contexto:NSManagedObjectContext? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    if (!UIImagePickerController.isSourceTypeAvailable(.Camera)) {
      camaraBoton.hidden = true
    }
    
    miPicker.delegate = self
    
  }
  
  func guardarBD() {
    
    let nuevaSeccionEntidad = NSEntityDescription.insertNewObjectForEntityForName("Rutas", inManagedObjectContext: self.contexto!)
    print("nombre: \(nombreTextField.text)")
    if let nombre = nombreTextField.text {
      nuevaSeccionEntidad.setValue(nombre, forKey: "nombre")
    } else {
      nuevaSeccionEntidad.setValue("nombre", forKey: "nombre")
    }
    print("desc: \(descripcionTextField.text)")
    if let desc = descripcionTextField.text {
      nuevaSeccionEntidad.setValue(desc, forKey: "descripcion")
    } else {
      nuevaSeccionEntidad.setValue("descripcion", forKey: "descripcion")
    }
    print("ima: \(imagenPunto)")
    if let imagen = imagenPunto {
      nuevaSeccionEntidad.setValue(UIImagePNGRepresentation(imagen), forKey: "imagen")
    } else {
      nuevaSeccionEntidad.setValue(UIImagePNGRepresentation(UIImage(named: "default")!), forKey: "imagen")
    }
    do {
      try self.contexto?.save()
    } catch {
      print("error al salvar en la BD")
    }
  }
  
  override func  preferredStatusBarStyle()-> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  @IBAction func backgroundTap(sender: UIControl) {
    self.nombreTextField.resignFirstResponder()
    self.descripcionTextField.resignFirstResponder()
  }
  
  @IBAction func nombreDoneEditing(sender : UITextField) {
    sender.resignFirstResponder()
  }
  
  @IBAction func descripcionDoneEditing(sender : UITextField) {
    sender.resignFirstResponder()
  }
  
  @IBAction func anadirFotoCamara(sender: AnyObject) {
    miPicker.sourceType = UIImagePickerControllerSourceType.Camera
    presentViewController(miPicker, animated: true, completion: nil)
  }
  
  @IBAction func anadirFotoAlbum(sender: AnyObject) {
    miPicker.sourceType = .PhotoLibrary
    presentViewController(miPicker, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    self.image.image = image
    self.imagenPunto = image
    picker.dismissViewControllerAnimated(true, completion: nil)
    
  }
  
  @IBAction func exitRoute() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func anadir(sender: AnyObject) {
    if (nombreTextField.text?.characters.count > 0 && descripcionTextField.text?.characters.count > 0) {
      
      dismissViewControllerAnimated(true, completion: nil)
      guardarBD()
      communicationDelegate?.saveRoute(nombreTextField.text!, descripcion: descripcionTextField.text!, imagen: imagenPunto)
      
    } else {
      let alert = UIAlertController(title: "Por favor introduce un nombre y descripción", message: "Debes introducir un nombre y una descripción para guardar la ruta", preferredStyle: UIAlertControllerStyle.ActionSheet)
      alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
      }))
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
}
