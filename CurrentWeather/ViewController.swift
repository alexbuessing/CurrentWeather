//
//  ViewController.swift
//  CurrentWeather
//
//  Created by Alexander Buessing on 11/22/15.
//  Copyright © 2015 AppFish. All rights reserved.
//

import UIKit
import CoreLocation

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
    var weather = Weather()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        startTime()
        
        weather.downloadWeatherDetails { () -> () in
            
            self.updateUI()
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        print("lat: \(latitude), lon: \(longitude)")
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

    
}

