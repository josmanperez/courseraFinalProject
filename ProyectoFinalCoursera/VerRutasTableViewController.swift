//
//  VerRutasTableViewController.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 28/07/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit
import CoreData

class VerRutasTableViewController: UITableViewController {
  
  var contexto:NSManagedObjectContext? = nil
  
  var listaRutas:[Ruta] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.rowHeight = 80
    
    self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let seccionEntidad = NSEntityDescription.entityForName("Rutas", inManagedObjectContext: self.contexto!)
    let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("petRutas")
    
    do {
      let seccionesEntidades = try self.contexto?.executeFetchRequest(peticion!)
      for seccionEntidadInd in seccionesEntidades! {
        let nombre = seccionEntidadInd.valueForKey("nombre")
        let descripcion = seccionEntidadInd.valueForKey("descripcion")
        
        if let hayImagen = seccionEntidadInd.valueForKey("imagen") {
          let ima = UIImage(data: hayImagen as! NSData)
          listaRutas.append(Ruta(nombre: nombre as! String, descripcion: descripcion as! String, imagen: ima))
        } else {
          listaRutas.append(Ruta(nombre: nombre as! String, descripcion: descripcion as! String, imagen: nil))
        }
      }
    } catch {
      print("Error!!!")
    }
    
    if !(listaRutas.count > 0) {
      let alert = UIAlertController(title: "No hay rutas", message: "No hay rutas guardadas para mostrar", preferredStyle: UIAlertControllerStyle.ActionSheet)
      alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
      }))
      self.presentViewController(alert, animated: true, completion: nil)
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listaRutas.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("verRutasCell", forIndexPath: indexPath) as! VerRutasCell
    
    let ruta = listaRutas[indexPath.row]
    
    cell.nombreRuta.text = ruta.nombre
    cell.descripcionRuta.text = ruta.descripcion
    if let imagen = ruta.imagen {
      cell.imagenRuta.image = imagen
    } else {
      cell.imagenRuta.image = UIImage(named: "default")
    }
    
    return cell
  }
  
  
  
  
}
