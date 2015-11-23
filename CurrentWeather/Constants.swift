//
//  Constants.swift
//  CurrentWeather
//
//  Created by Alexander Buessing on 11/22/15.
//  Copyright © 2015 AppFish. All rights reserved.
//

import Foundation

//http://api.openweathermap.org/data/2.5/weather?lat=35.9132&lon=-79.05584&appid=2de143494c0b295cca9337e1e96b00e0


let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let COORDINATE_URL = "lat=35.9132&lon=-79.05584"
let END_URL = "&appid=2de143494c0b295cca9337e1e96b00e0"

typealias DownloadComplete = () -> ()