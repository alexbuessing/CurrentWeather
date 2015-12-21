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
            _bgImg = UIImage(named: "cloudybg.jpg")
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
            if isDaytime() == true {
                image1 = UIImage(named: "thunderstorms.jpg")
                image2 = UIImage(named: "thunderstormbg.jpg")
            } else {
                image1 = UIImage(named: "thunderstormnight.jpg")
                image2 = UIImage(named: "thunderstormnightbg.jpg")
            }
        case 300...321:
            if isDaytime() == true {
                image1 = UIImage(named: "rain.jpg")
                image2 = UIImage(named: "rainbg.jpg")
            } else {
                image1 = UIImage(named: "rainynight.jpg")
                image2 = UIImage(named: "nightrainbg.jpg")
            }
        case 500...531:
            if isDaytime() == true {
                image1 = UIImage(named: "rain.jpg")
                image2 = UIImage(named: "rainbg.jpg")
            } else {
                image1 = UIImage(named: "rainynight.jpg")
                image2 = UIImage(named: "nightrainbg.jpg")
            }
        case 600...622:
            if isDaytime() == true {
                image1 = UIImage(named: "snow.jpg")
                image2 = UIImage(named: "snowbg.jpg")
            } else {
                image1 = UIImage(named: "snow.jpg")
                image2 = UIImage(named: "snowynightbg.jpg")
            }
        case 700...781:
            if isDaytime() == true {
                image1 = UIImage(named: "sun.jpg")
                image2 = UIImage(named: "sunbg.jpg")
            } else {
                image1 = UIImage(named: "clearnight.jpg")
                image2 = UIImage(named: "clearnightbg.jpg")
            }
        case 800:
            if isDaytime() == true {
                image1 = UIImage(named: "sun.jpg")
                image2 = UIImage(named: "sunbg.jpg")
            } else {
                image1 = UIImage(named: "clearnight.jpg")
                image2 = UIImage(named: "clearnightbg.jpg")
            }
        case 801...804:
            if isDaytime() == true {
                image1 = UIImage(named: "partlycloudy.jpg")
                image2 = UIImage(named: "cloudybg.jpg")
            } else {
                image1 = UIImage(named: "cloudynight.jpg")
                image2 = UIImage(named: "cloudynightbg.jpg")
            }
        case 900...906:
            if isDaytime() == true {
                image1 = UIImage(named: "thunderstorms.jpg")
                image2 = UIImage(named: "thunderstormbg.jpg")
            } else {
                image1 = UIImage(named: "thunderstormnight.jpg")
                image2 = UIImage(named: "thunderstormnightbg.jpg")
            }
        case 951...962:
            image1 = UIImage(named: "windy.jpg")
            image2 = UIImage(named: "windybg.jpg")
        default:
            if isDaytime() == true {
                image1 = UIImage(named: "sun.jpg")
                image2 = UIImage(named: "sunbg.jpg")
            } else {
                image1 = UIImage(named: "clearnight.jpg")
                image2 = UIImage(named: "clearnightbg.jpg")
            }
        }
        
        _mainImg = image1
        _bgImg = image2
        
    }
    
    func parseTime(time: String) -> Array<String> {
        
        var arrayContainer = time.componentsSeparatedByString(":")
        arrayContainer.append(arrayContainer[1].componentsSeparatedByString(" ")[0])
        let testArray = time.componentsSeparatedByString(" ")
        arrayContainer.removeAtIndex(1)
        arrayContainer.append(testArray[1])
        
        return arrayContainer
    }
    
    func isDaytime() -> Bool {
    
        let str = getTimeAndDay()
        var strArr = str.componentsSeparatedByString(" ")
        var currentTime = strArr[0].componentsSeparatedByString(":")
        currentTime.append(strArr[1])
        
        var sunriseArr = parseTime(_sunrise)
        var sunsetArr = parseTime(_sunset)
        
        if Int(currentTime[0])! == 12 && currentTime[2] == "PM" {
            return true
        } else if Int(currentTime[0])! == 12 && currentTime[2] == "AM" {
            
            return false
            
        } else if (Int(currentTime[0])! >= Int(sunriseArr[0])! && currentTime[2] == sunriseArr[2]) {
            
            if (Int(currentTime[0])! == Int(sunriseArr[0])!) {
                
                if Int(currentTime[1])! > Int(sunriseArr[1])! {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else if (Int(currentTime[0])! <= Int(sunsetArr[0])! && currentTime[2] == sunsetArr[2]) {
            
            if (Int(currentTime[0])! == Int(sunsetArr[0])!) {
                
                if Int(currentTime[1])! < Int(sunsetArr[1])! {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return false
        }
    
    }
    
    func startTime() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "getTimeAndDay", userInfo: nil, repeats: true)
        
    }
    
    func getTimeAndDay() -> String {
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
        return "\(time) \(morningAfternoon) \(day)"
    }

    
    func downloadWeatherDetails(completed: DownloadComplete) {
        NSLog("time 3")
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
            NSLog("time 4")
         completed()
        }
    }
    
}

