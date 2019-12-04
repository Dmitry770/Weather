//
//  Weather.swift
//  Weather
//
//  Created by Macintosh on 30/11/2019.
//  Copyright © 2019 Macintosh. All rights reserved.
//

import Foundation

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct  Main: Codable {
    var temp: Double = 0.0
    var pressure: Int = 0
    var humidity:Int = 0
}

struct Wind: Codable {
    var speed: Int = 0
}

struct WeatherData: Codable {
    var weather: [Weather] = []
    var main: Main = Main()
    var wind: Wind = Wind()
    var name: String = ""
    var visibility: Int = 0
}
