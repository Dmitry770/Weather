//
//  ViewController.swift
//  Weather
//
//  Created by Macintosh on 29/11/2019.
//  Copyright © 2019 Macintosh. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
//http://api.openweathermap.org/data/2.5/weather?lat=55.75&lon=37.61&units=metric&lang=ru&APPID=d01ef7e74ff4af273f72901d3daddaec

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    var forecastArray: [List] = []
    var forecastWeather: ForecastWeather!
    var savedLocations: [List] = []
   

    override func viewDidLoad() {
        super.viewDidLoad()
        startLM()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    

    func startLM() {
        //request on access to geocoordinates
        locationManager.requestWhenInUseAuthorization()
        
        //check turn on geolocation service
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateVC () {
        nameLabel.text = weatherData.name
        tempLabel.text = weatherData.main.temp.description + "°C"
        iconImageView.image = UIImage(named: weatherData.weather[0].icon)
        descriptionLabel.text = CodeDescription.weatherCode[weatherData.weather[0].id]
        pressureLabel.text = "Pressure: " + weatherData.main.pressure.description + " mmHg"
        humidityLabel.text = "Humidity: " + weatherData.main.humidity.description + " %"
        visibilityLabel.text = "Visibility: " + weatherData.visibility.description + " m"
        windSpeedLabel.text = "Wind speed: " + weatherData.wind.speed.description + " m/s"
    }
    
    
    func updateParameters(latitude: Double, longtitude: Double) {
        let session = URLSession.shared
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&units=metric&lang=ru&APPID=d01ef7e74ff4af273f72901d3daddaec")!
        let downloadTask = session.dataTask(with: url) { (data, response, error) in
         guard error == nil else {
           print(error!.localizedDescription)

                return
            }
            
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                    self.updateVC()
                } // MVVM
            } catch {
                print(error.localizedDescription)
            }
        }
        downloadTask.resume()
    }
    
    func updateForecast(latitude: Double, longitude: Double) {
        let session = URLSession.shared
        let urlForecast = URL(string: "http://api.openweathermap.org/data/2.5/find?lat=\(latitude.description)&lon=\(longitude.description)&cnt=10&units=metric&lang=ru&APPID=d01ef7e74ff4af273f72901d3daddaec")!
        let downloadTaskForecast = session.dataTask(with: urlForecast) { (data, responce, error) in
                guard error == nil else {
                  print(error!.localizedDescription)

                       return
                   }
                   
                   do {
                       self.forecastWeather = try JSONDecoder().decode(ForecastWeather.self, from: data!)
                   self.forecastArray = self.forecastWeather.list
                    if let list = self.forecastWeather.list.first {
                    self.savedLocations.append(list)
                }
                       DispatchQueue.main.async {
                        self.tableView.reloadData()
                       } // MVVM
                   } catch {
                       print(error.localizedDescription)
                   }
               }
        downloadTaskForecast.resume()
        
        
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller: LocationsTableViewController = segue.destination as! LocationsTableViewController
        controller.callBack = {
            (lon,lat)
            in
//            print("\(lon) \(lat)")
            self.updateParameters(latitude: lat, longtitude: lon)
            self.updateForecast(latitude: lat, longitude: lon)
        }
    }
    
    func saveCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "LocationInfo", in: context)
        let locInfo = NSManagedObject(entity: entity!, insertInto: context)
        if let list = savedLocations.first {
        locInfo.setValue(list.name, forKey: "name")
        locInfo.setValue(list.main?.temp, forKey: "temp")
        locInfo.setValue(list.coord?.lon, forKey: "lon")
        locInfo.setValue(list.coord?.lat, forKey: "lat")
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    func deleteCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationInfo")
        do{
       let deletedObjects =  try! context.fetch(fetchRequest)
            for deletedObject in deletedObjects{
                try context.delete(deletedObject as! NSManagedObject)
            }
        }catch {
            print("Failed deleting")        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        saveCoreData()
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        deleteCoreData()
    }
    
    
    @IBAction func historyTapped(_ sender: Any) {

    }

}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateParameters(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
            updateForecast(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            tableView.reloadData()
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastCell
        if let temp:Double = forecastWeather.list[indexPath.row].main!.temp {
            
            let day:Double = Double(forecastWeather.list[indexPath.row].dt!)
            let rawDate = Date(timeIntervalSince1970: day)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            
            cell.configureCell(temp: temp, day: rawDate.dayOfTheWeek())
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
}
