//
//  DonateViewController.swift
//  Knowaste
//
//  Created by Jiaqi Wang on 30/8/17.
//  Copyright © 2017 Jiaqi Wang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class DonateViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationArray: [Location]?
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var displayTimes: Int?
    var donateLocationList: [DonateLocation] = []
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermission()
        if (displayTimes == 1){
            loadLocationData()
        } else{
            getCoreData()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    @IBAction func centreUser(_ sender: Any) {
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(currentLocation!, span)
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentLocation != nil{
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(currentLocation!, span)
            mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        currentLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    }
    
    func checkPermission(){
        if(CLLocationManager.authorizationStatus() != .denied) {
            
        }else {
            let aleat = UIAlertController(title: "Get GPS Permission", message:"GPS Permission is disabled. Please go to Settings > Privacy > Location Services to enable the Location Service and allow Knowaste to use the location.", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            }
            let callAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
                if (UIApplication.shared.canOpenURL(url! as URL)) {
                    UIApplication.shared.openURL(url! as URL)
                }
            }
            aleat.addAction(callAction)
            aleat.addAction(tempAction)
            self.present(aleat, animated: true, completion: nil)
        }
    }
    
    func loadLocationData(){
        deleteCoreData()
        let url = URL(string: "http://allrangenowaste.com/location.php")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                
                print("Error")
                
            } else{
                
                if let content = data {
                    do{
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        self.locationArray = (myJson as! NSArray as! [Location])
                        for location in (self.locationArray as! [NSDictionary]){
                            let geocoder = CLGeocoder()
                            let address: String = "\(location.object(forKey: "street")! as! String),\(location.object(forKey: "suburb")! as! String), \(location.object(forKey: "postCode")!)"
                            geocoder.geocodeAddressString(address) {
                                placemarks, error in
                                let placemark = placemarks?.first
                                let lat = placemark?.location?.coordinate.latitude
                                let lon = placemark?.location?.coordinate.longitude
                                let pin = PinAnnotation(title: "Red Cross \(location.object(forKey: "name")! as! String)", subtitle: address, coordinate: (placemark?.location?.coordinate)!)
                                self.mapView.addAnnotation(pin)
                                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                                let dl = DonateLocation(context: context)
                                dl.locationId = (location.object(forKey: "locationId")! as! String)
                                dl.name = (location.object(forKey: "name")! as! String)
                                dl.phone = (location.object(forKey: "phone")! as! String)
                                dl.postCode = (location.object(forKey: "postCode")! as! String)
                                dl.street = (location.object(forKey: "street")! as! String)
                                dl.suburb = (location.object(forKey: "suburb")! as! String)
                                dl.lat = lat!
                                dl.lon = lon!
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            }
                            

                        }
                    } catch{
                        print("ERROR")
                    }
                }
            }
        }
        task.resume()
    }

    func getCoreData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            donateLocationList = try context.fetch(DonateLocation.fetchRequest())
            for donateLocation in (donateLocationList){
                
                let coor = CLLocationCoordinate2DMake(donateLocation.lat, donateLocation.lon)
                
                    let pin = PinAnnotation(title: "Red Cross \(donateLocation.name!)", subtitle: "\(donateLocation.street!),\(donateLocation.suburb!), \(donateLocation.postCode!)", coordinate: coor)
                    self.mapView.addAnnotation(pin)
                }
        }
        catch{
            print("Fetching Failed")
        }
        
    }
    
    
    func deleteCoreData() {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DonateLocation")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
    }
    
}
