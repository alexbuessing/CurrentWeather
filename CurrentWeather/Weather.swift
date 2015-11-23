//
//  Weather.swift
//  CurrentWeather
//
//  Created by Alexander Buessing on 11/22/15.
//  Copyright © 2015 AppFish. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    
    private var _timeDay: String!
    private var _weatherDesc: String!
    private var _currentTemp: String!
    private var _sunrise: String!
    private var _sunset: String!
    private var _windSpeed: String!
    private var _humidity: String!
    private var _pressure: String!
    private var _weatherId: Int!
    private var _weatherURL: String!
    private var _location: String!
    private var _mainImg: UIImage!
    private var _bgImg: UIImage!
    
    var timer = NSTimer()
    
    var timeDay: String {
        if _timeDay == nil {
            _timeDay = ""
        }
        return _timeDay
    }
    
    var weatherDesc: String {
        if _weatherDesc == nil {
            _weatherDesc = ""
        }
        return _weatherDesc
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = ""
        }
        return _currentTemp
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
    var windSpeed: String {
        if _windSpeed == nil {
            _windSpeed = ""
        }
        return _windSpeed
    }
    
    var humidity: String {
        if _humidity == nil {
            _humidity = ""
        }
        return _humidity
    }
    
    var weatherURL: String {
        if _weatherURL == nil {
            _weatherURL = ""
        }
        return _weatherURL
    }
    
    var weatherId: Int {
        if _weatherId == nil {
            _weatherId = 200
        }
        return _weatherId
    }
    
    var location: String {
        if _location == nil {
            _location = ""
        }
        return _location
    }
    
    var pressure: String {
        if _pressure == nil {
            _pressure = ""
        }
        return _pressure
    }
    
    var mainImg: UIImage {
        if _mainImg == nil {
            _mainImg = UIImage(named: "sun.jpg")
        }
        return _mainImg
    }
    
    var bgImg: UIImage {
        if _bgImg == nil {
            _bgImg = UIImage(named:"cloudybg.jpg")
        }
        return _bgImg
    }
    
    init() {
        
        _weatherURL = "\(BASE_URL)\(COORDINATE_URL)\(END_URL)"
        
    }
    
    func kelvinToFarenheit(kelvin: String) -> String {
        
        var farenheit: Double
        farenheit = round((Double(kelvin)! - 273.15) * 1.8 + 32)
        
        return NSString(format: "%.0f", farenheit) as String
    }
    
    func toInchMercury(pressure: String) -> String {
        var str: String
        str = "\(round(Double(pressure)! * 0.02961339710085))"
        
        return str
    }
    
    func getImage(weatherId: Int) {
        
        var image1: UIImage!
        var image2: UIImage!
        
        switch weatherId {
        case 200...232:
            image1 = UIImage(named: "thunderstorms.jpg")
        case 300...321:
            image1 = UIImage(named: "rain.jpg")
            image2 = UIImage(named: "rainbg.jpg")
        case 500...531:
            image1 = UIImage(named: "rain.jpg")
            image2 = UIImage(named: "rainbg.jpg")
        case 600...622:
            image1 = UIImage(named: "snow.jpg")
            image2 = UIImage(named: "snowbg.jpg")
        case 700...781:
            image1 = UIImage(named: "sun.jpg")
            image2 = UIImage(named: "sunbg.jpg")
        case 800:
            image1 = UIImage(named: "sun.jpg")
            image2 = UIImage(named: "sunbg.jpg")
        case 801...804:
            image1 = UIImage(named: "partlycloudy.jpg")
            image2 = UIImage(named: "cloudybg.jpg")
        case 900...906:
            image1 = UIImage(named: "thunderstorms.jpg")
        case 951...962:
            image1 = UIImage(named: "windy.jpg")
        default:
            image1 = UIImage(named: "sun.jpg")
            image2 = UIImage(named: "sunbg.jpg")
        }
        
        _mainImg = image1
        _bgImg = image2
        
    }

    
    func downloadWeatherDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _weatherURL)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let descriptions = dict["weather"] as? [Dictionary<String, AnyObject>] where descriptions.count > 0 {
                    
                    if let description = descriptions[0]["main"] as? String {
                        self._weatherDesc = description
                    }
                    
                    if let id = descriptions[0]["id"] as? Int {
                        self._weatherId = id
                    }
                }
                
                if let name = dict["name"] as? String {
                    self._location = name
                }
                
                if let winds = dict["wind"] as? Dictionary<String, AnyObject> {
                    
                    if let wind = winds["speed"] as? Double {
                        self._windSpeed = NSString(format: "%.0f", wind) as String
                    }
                    
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    
                    if let temp = main["temp"] as? Double {
                        self._currentTemp = String(temp)
                    }
                    
                    if let humid = main["humidity"] as? Int {
                        self._humidity = String(humid)
                    }
                    
                    if let pressure = main["pressure"] as? Double {
                        self._pressure = String(pressure)
                    }
                    
                }
                
                if let details = dict["sys"] as? Dictionary<String, AnyObject> {
                    
                    if let sunrise = details["sunrise"] as? Double {
                        let date = NSDate(timeIntervalSince1970: sunrise)
                        let timeFormatter = NSDateFormatter()
                        timeFormatter.dateFormat = "h:mm a"
                        self._sunrise = timeFormatter.stringFromDate(date)
                    }
                    
                    if let sunset = details["sunset"] as? Double {
                        let date = NSDate(timeIntervalSince1970: sunset)
                        let timeFormatter = NSDateFormatter()
                        timeFormatter.dateFormat = "h:mm a"
                        self._sunset = timeFormatter.stringFromDate(date)
                    }
                    
                }
                
            }
         completed()
        }
    }
    
}

