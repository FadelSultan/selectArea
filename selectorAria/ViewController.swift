//
//  ViewController.swift
//  selectorAria
//
//  Created by Fadel on 19/02/1443 AH.
//

import UIKit
import MapKit
import GoogleMaps

class ViewController: UIViewController , CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pointsArea = [CLLocationCoordinate2D]()
    
    let annotation = MKPointAnnotation()
    
    var segmentesCurrentlySelected = 0
    var isSelectedYourLocation = false
    var isFinishSelectRegion = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fillPointsArea()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let gestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleTap))
//        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func isWithin(_ point: CLLocationCoordinate2D) -> Bool {
        let p = GMSMutablePath()
        pointsArea.forEach { value in
            p.add(value)
        }
        return GMSGeometryContainsLocation(point, p, true)
    }
    
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        if(segmentesCurrentlySelected == 1) {
            handleSelectedUserLocation(coordinate: coordinate)
        }
        
        if(segmentesCurrentlySelected == 2) {
            handleAddNewRegion(coordinate: coordinate)
        }
        
    }
    
    
    
    @IBAction func segmentedUserSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentesCurrentlySelected = 0
        case 1:
            segmentesCurrentlySelected = 1
        case 2:
            segmentesCurrentlySelected = 2
            self.pointsArea.removeAll()
        default:
            segmentesCurrentlySelected = 0
        
        }
    }
    
    func fillPointsArea() {

//        Hulailah
        pointsArea.append(CLLocationCoordinate2DMake(25.434927, 49.670170))
        pointsArea.append(CLLocationCoordinate2DMake(25.435050, 49.670195))
        pointsArea.append(CLLocationCoordinate2DMake(25.439274, 49.642820))
        pointsArea.append(CLLocationCoordinate2DMake(25.428028, 49.646149))
        pointsArea.append(CLLocationCoordinate2DMake(25.427690, 49.653355))
        pointsArea.append(CLLocationCoordinate2DMake(25.429213, 49.659389))
        pointsArea.append(CLLocationCoordinate2DMake(25.426778, 49.661059))
        pointsArea.append(CLLocationCoordinate2DMake(25.427739, 49.665625))
        pointsArea.append(CLLocationCoordinate2DMake(25.428335, 49.671691))
        pointsArea.append(CLLocationCoordinate2DMake(25.434927, 49.670170))
        
//         Askan
        pointsArea.append(CLLocationCoordinate2DMake(25.461759, 49.649461))
        
        pointsArea.append(CLLocationCoordinate2DMake(25.462965, 49.643729))
        
        pointsArea.append(CLLocationCoordinate2DMake(25.462648, 49.640151))
        
        pointsArea.append(CLLocationCoordinate2DMake(25.460026, 49.636631))
        
        pointsArea.append(CLLocationCoordinate2DMake(25.447409, 49.640518))
        
        pointsArea.append(CLLocationCoordinate2DMake(25.445910, 49.645304))
        pointsArea.append(CLLocationCoordinate2DMake(25.447010, 49.649566))
        pointsArea.append(CLLocationCoordinate2DMake(25.461678, 49.649515))
        pointsArea.append(CLLocationCoordinate2DMake(25.461759, 49.649461))
         
        
        drawLinesToViewMaps(coordinates: pointsArea)
    
        
    }
    
    
    func drawLinesToViewMaps(coordinates:[CLLocationCoordinate2D] ) {
        
        let myPolyLine_1: MKPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.centerCoordinate = CLLocationCoordinate2DMake(25.463161, 49.650118)
        mapView.delegate = self
        mapView.addOverlay(myPolyLine_1)
        let latDelta: CLLocationDegrees = 0.03
        let lonDelta: CLLocationDegrees = 0.03
        let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(coordinates.last!.latitude, coordinates.last!.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        
        
//        self.mapView.showsUserLocation = true
        
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        let locaton: CLLocationCoordinate2D = CLLocationCoordinate2DMake((locations.last?.coordinate.latitude)!, (locations.last?.coordinate.longitude)!)
        
        if !isSelectedYourLocation {
            let latDelta: CLLocationDegrees = 0.05
            let lonDelta: CLLocationDegrees = 0.05
            let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region: MKCoordinateRegion = MKCoordinateRegion.init(center: locations.last!.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            isSelectedYourLocation = !isSelectedYourLocation
        }
        
        
//        let isInsideArea = locaton.liesInsideRegion(region: pointsArea)
//
//        print(isInsideArea)
        
//        print("\(locaton.latitude ) - \(locaton.longitude)")
        
        
    
    }

  
    
}

extension ViewController: MKMapViewDelegate {
    
    // Delegate method called when addOverlay is done.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Generate renderer.
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        // Specify the thickness of the line.
        myPolyLineRendere.lineWidth = 3
        
        // Specify the color of the line.
        myPolyLineRendere.strokeColor = UIColor.red
        
        return myPolyLineRendere
    }
    
}


extension ViewController {
    func handleDeviceLocation() {
        
    }
    
    func handleSelectedUserLocation(coordinate: CLLocationCoordinate2D) {
//        print("check location: \(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude).liesInsideRegion(region: pointsArea))")
        
        if !isFinishSelectRegion {
            handleAddNewRegion(coordinate: pointsArea.first!)
            print("X: \(pointsArea.first!.latitude) - Y: \(pointsArea.first!.longitude)")
            isFinishSelectRegion = !isFinishSelectRegion
        }
        
        if(isWithin(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))) {
            let alert = UIAlertController(title: "مكان النقطة", message: "النقطة داخل التحديد", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "مكان النقطة", message: "النقطة خارج التحديد", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleAddNewRegion(coordinate: CLLocationCoordinate2D) {
        if pointsArea.count == 0 {
            print("X: \(coordinate.latitude) - Y: \(coordinate.longitude)")
        }
        
        pointsArea.append(coordinate)
//        print("count array: \(pointsArea.count)")
        drawLinesToViewMaps(coordinates: pointsArea)
        
    }
    
}
