//
//  ViewController.swift
//  CurrentWeather
//
//  Created by Alexander Buessing on 11/22/15.
//  Copyright © 2015 AppFish. All rights reserved.
//

import UIKit
import CoreLocation

var latitude: CLLocationDegrees = 43.2065
var longitude: CLLocationDegrees = -71.5365

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var timeDay: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    @IBOutlet var weatherImg: UIImageView!
    @IBOutlet var backgroundImg: UIImageView!
    
    var timer: NSTimer!
    var weather: Weather!
    var locationMan = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationMan.delegate = self
        locationMan.desiredAccuracy = kCLLocationAccuracyBest
        locationMan.requestWhenInUseAuthorization()
        locationMan.startUpdatingLocation()
    
        startTime()
        
    }
    
    func startTime() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "getTimeAndDay", userInfo: nil, repeats: true)
        
    }
    
    func getTimeAndDay() {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        let dayArr = String(formatter.stringFromDate(date)).componentsSeparatedByString(" ")
        let day = dayArr[0].stringByReplacingOccurrencesOfString(",", withString: "")
        let date2 = NSDate()
        let formatter2 = NSDateFormatter()
        formatter2.timeStyle = .FullStyle
        var fullTime = String(formatter2.stringFromDate(date2)).componentsSeparatedByString(" ")
        let morningAfternoon = fullTime[1]
        let time = String(fullTime[0].characters.dropLast(3))
        timeDay.text = "\(time) \(morningAfternoon) \(day)"
    }
    
    func updateUI() {
        
        weather.getImage(weather.weatherId)
        weatherDesc.text = weather.weatherDesc
        weatherImg.image = weather.mainImg
        backgroundImg.image = weather.bgImg
        locationLbl.text = weather.location
        windSpeed.text = "\(weather.windSpeed) MPH"
        humidity.text = weather.humidity + "%"
        currentTemp.text = weather.kelvinToFarenheit(weather.currentTemp) + "º"
        pressure.text = weather.toInchMercury(weather.pressure) + " InHg"
        sunset.text = weather.sunset
        sunrise.text = weather.sunrise
    }

    func changeLocation(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        COORDINATE_URL = "lat=\(lat)&lon=\(lon)"
        
    }
    
    func waitForDownload() {
        
        weather.downloadWeatherDetails { () -> () in
            
            self.updateUI()

        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            latitude = locationMan.location!.coordinate.latitude
            longitude = locationMan.location!.coordinate.longitude
            changeLocation(latitude, lon: longitude)
            weather = Weather()
            waitForDownload()

        } else {
            print("Phone does not have users location")
        }
    }
    
    @IBAction func refreshedPressed(sender: AnyObject) {
        latitude = locationMan.location!.coordinate.latitude
        longitude = locationMan.location!.coordinate.longitude
        changeLocation(latitude, lon: longitude)
        waitForDownload()
        
    }
    
    
}

