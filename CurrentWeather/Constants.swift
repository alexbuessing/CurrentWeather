//
//  Constants.swift
//  CurrentWeather
//
//  Created by Alexander Buessing on 11/22/15.
//  Copyright © 2015 AppFish. All rights reserved.
//

import Foundation
import CoreLocation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
var COORDINATE_URL = "lat=\(latitude)&lon=\(longitude)"
let END_URL = "&appid=2de143494c0b295cca9337e1e96b00e0"

typealias DownloadComplete = () -> ()

