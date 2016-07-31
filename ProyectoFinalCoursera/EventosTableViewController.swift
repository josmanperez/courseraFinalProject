//
//  EventosTableViewController.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 26/07/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit

class EventosTableViewController: UITableViewController {
  
  var listaEventos:[Evento] = []
  private let reuseIdentifier = "EventosCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("empezando..")
    print("como no hay url para json leo de json en la propia app")
    //readingJSONFromDirectory()
    readingJSON()
  
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listaEventos.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EventosCellTableViewCell
    
    let evento = listaEventos[indexPath.row]
    
    if let nombre = evento.nombre {
      cell.nombre.text = nombre
    }
    if let fecha = evento.fecha {
      cell.fecha.text = fecha
    }
    if let descripcion = evento.descripcion {
      cell.descripcion.text = descripcion
    }
    
    return cell
    
  }
  
  func readingJSONFromDirectory() {
    if let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
      
      let path:NSString = dir.stringByAppendingPathComponent("eventos.json")
      do {
        
        let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path as String), options: NSDataReadingOptions.DataReadingMappedIfSafe)
        let jsonObj = JSON(data: data)
        if jsonObj != JSON.null {
          print("Leemos del directorio")
          //print("jsonData: \(jsonObj)")
          saveJSON(jsonObj)
        } else {
          print("No se pudo obtener json del archivo")
        }
        
      } catch let error as NSError {
        print(error.localizedDescription)
        readingJSON()
      }
    } else {
      print("Directorio no existe")
    }
  }
  
  func readingJSON() {
    if let path = NSBundle.mainBundle().pathForResource("eventos", ofType: "json") {
      do {
        print("Leemos de Assets")
        let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
        let jsonObj = JSON(data: data)
        if jsonObj != JSON.null {
          //print("jsonData: \(jsonObj)")
          saveJSON(jsonObj)
        } else {
          print("No se pudo obtener json del archivo")
        }
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    } else {
      print("Directorio no existe")
    }
  }
  
  func saveJSON(jsonObj: JSON) {
    for (key,subJson):(String,JSON) in jsonObj["eventos"] {
      print("\(key) : \(subJson["nombre"])")
      if let nombre = subJson["nombre"].string, descripcion = subJson["descripcion"].string, fecha = subJson["fecha"].string {
        
        let evento = Evento(fecha: fecha, descripcion: descripcion, nombre: nombre)
        
        //print(evento.nombre)
        self.listaEventos.append(evento)
        
      }
    }
    self.tableView.reloadData()
  }
  
}
