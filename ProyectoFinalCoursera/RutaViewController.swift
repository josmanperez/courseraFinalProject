//
//  RutaViewController.swift
//  ProyectoFinalCoursera
//
//  Created by Josman Pérez Expósito on 23/04/16.
//  Copyright © 2016 personal. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RutaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,
CommunicationControllerDelegate, SaveRouteControllerDelegate {
  
  @IBOutlet weak var mapa: MKMapView!
  
  private let manejador = CLLocationManager()
  
  @IBOutlet weak var loading: UIActivityIndicatorView!
  @IBOutlet weak var loadingView: UIView!
  
  var coordenadas:CLLocationCoordinate2D?
  
  var ruta:Ruta?
  
  var listaPtoInteres:[PtoInteres] = []
  var listaMapItems:[MKMapItem] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    manejador.delegate = self
    manejador.desiredAccuracy = kCLLocationAccuracyBest
    manejador.requestWhenInUseAuthorization()
    
    mapa.delegate = self
    
    obtenerLocalizacion()
    
    loading.stopAnimating()
    loadingView.hidden = true
    
    print("nombre ruta: \(ruta?.nombre)")
    
    
  }
  
  func obtenerLocalizacion() {
    var punto = CLLocationCoordinate2D()
    
    if let latitude = manejador.location?.coordinate.latitude, let longitude = manejador.location?.coordinate.longitude {
      let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
      self.mapa.setRegion(region, animated: true)
      
      punto.longitude = longitude
      punto.latitude = latitude
      
      //let inicioPin:MKPointAnnotation = MKPointAnnotation()
      //inicioPin.title = "Inicio!"
      //inicioPin.coordinate = punto
      //mapa.addAnnotation(inicioPin)
      let puntoInicio:PtoInteres = PtoInteres(nombre: "Inicio!", coordenadas: punto)
      listaPtoInteres.append(puntoInicio)
      
    } else {
      let alert = UIAlertController(title: "Error", message: "No se puede localizar su posición, PD: Habilítela en opciones de simulador", preferredStyle: UIAlertControllerStyle.ActionSheet)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
      }))
      
    }
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      manejador.startUpdatingLocation()
      mapa.showsUserLocation = true
    } else {
      manejador.stopUpdatingLocation()
      mapa.showsUserLocation = false
    }
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("\(error)")
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //print("lat: \(manager.location?.coordinate.latitude) long: \(manager.location?.coordinate.longitude)")
    self.coordenadas = manager.location?.coordinate
  }
  
  // MARK: - PtoInteres
  func setPunto(nombre: String, imagen: UIImage?, coordenadas: CLLocationCoordinate2D) {
    print("nombre: \(nombre) imagen: \(imagen) lat: \(coordenadas.latitude)")
    // Creamos el objeto punto
    var punto:PtoInteres
    if let imagenI = imagen {
      punto = PtoInteres(nombre: nombre, imagen: imagenI, coordenadas: coordenadas)
    }
    punto = PtoInteres(nombre: nombre, coordenadas: coordenadas)
    listaPtoInteres.append(punto)
    calcularRuta()
  }
  
  func saveRoute(nombre: String, descripcion: String, imagen: UIImage?) {
    print("nombre: \(nombre) desc: \(descripcion) imagen: \(imagen)")
    ruta = Ruta(nombre: nombre, descripcion: descripcion, imagen: imagen, rutas: listaMapItems)
    let alert = UIAlertController(title: "Ruta guardad con éxito", message: "La ruta \(nombre) se ha guardado con éxito", preferredStyle: UIAlertControllerStyle.ActionSheet)
    alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!)in
    }))
    self.presentViewController(alert, animated: true, completion: nil)
    
  }
  
  func calcularRuta() {
    if (listaPtoInteres.count > 0) {
      for puntos in listaPtoInteres {
        // Creamos los placemarks
        let puntoLugar = MKPlacemark(coordinate: puntos.coordenadas, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: puntoLugar)
        mapItem.name = puntos.nombre
        listaMapItems.append(mapItem)
        self.anotaPunto(mapItem)
      }
      self.obtenerRuta()
    }
  }
  
  func anotaPunto(punto: MKMapItem) {
    let anota: MKPointAnnotation = MKPointAnnotation()
    anota.coordinate = punto.placemark.coordinate
    anota.title = punto.name
    mapa.addAnnotation(anota)
  }
  
  func obtenerRuta() {
    
    if (listaMapItems.count > 1) {
      for i in 0 ..< listaMapItems.count {
        if ((i+1) < listaMapItems.count) {
          print("1º: \(listaMapItems[i].placemark.name) 2º: \(listaMapItems[i+1].placemark.name)")
          self.solicitarRuta(origen: listaMapItems[i],destino: listaMapItems[i+1])
        }
      }
    }
  }
  
  func solicitarRuta(origen origen: MKMapItem, destino: MKMapItem) {
    let solicitud = MKDirectionsRequest()
    solicitud.source = origen
    solicitud.destination = destino
    solicitud.transportType = .Walking
    let indicaciones = MKDirections(request: solicitud)
    loading.startAnimating()
    self.loadingView.hidden = false
    indicaciones.calculateDirectionsWithCompletionHandler({
      (respuesta: MKDirectionsResponse?, error:NSError?) in
      if error != nil {
        print("Error al obtener la ruta")
      } else {
        self.muestraRuta(respuesta!)
      }
      self.loading.stopAnimating()
      self.loadingView.hidden = true
    })
  }
  
  func muestraRuta(respuesta: MKDirectionsResponse) {
    for ruta in respuesta.routes {
      mapa.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
      
    }
    let centro = listaMapItems[listaMapItems.count-1].placemark.coordinate
    let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
    mapa.setRegion(region, animated: true)
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

    if annotation is MKUserLocation {
      return nil
    }
    let reuseId = "pin"
    let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
    
    if pinView == nil {
      let pinView:MKPinAnnotationView = MKPinAnnotationView()
      pinView.annotation = annotation
      pinView.pinTintColor = MKPinAnnotationView.greenPinColor()//MKPinAnnotationColor.Green
      pinView.animatesDrop = true
      pinView.canShowCallout = true
      
    }else{
      pinView!.annotation = annotation
    }
    return pinView
    
  }
  
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "anadirPtoInteres") {
      // Obtener localizacion actual
      ((segue.destinationViewController as! PtoInteresViewController)).coordenadas = coordenadas
      ((segue.destinationViewController as! PtoInteresViewController)).communicationDelegate = self
    }
    if (segue.identifier == "guardarRuta") {
      ((segue.destinationViewController as! SaveRouteViewController)).communicationDelegate = self
    }
    
  }
  
  func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor.greenColor()
    renderer.lineWidth = 3.0
    return renderer
  }
  @IBAction func anadirRuta() {
    self.performSegueWithIdentifier("guardarRuta", sender: nil)
  }
  
  @IBAction func anadirPtoInteres() {
    self.performSegueWithIdentifier("anadirPtoInteres", sender: nil)
  }
}
