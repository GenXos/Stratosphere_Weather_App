//
//  Weather.swift
//  StratosphereWeatherApp
//
//  Created by Todd Fields on 2016-02-14.
//  Copyright © 2016 Skullgate Studios. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    
    enum WindDirection {
        case N
        case NNE
        case NE
        case ENE
        case E
        case ESE
        case SE
        case SSE
        case S
        case SSW
        case SW
        case WSW
        case W
        case WNW
        case NW
        case NNW
    }
    
    private var _cityId: Int!
    private var _cityName: String!
    private var _overview: String!
    private var _description: String!
    private var _temperature: String!
    private var _pressure: String!
    private var _humidity: String!
    private var _windSpeed: String!
    private var _windDirection: WindDirection!
    private var _sunrise: String!
    private var _sunset: String!
    
    private var _weatherURL: String!
    
    var cityID: Int {
        return _cityId
    }
    
    var cityName: String {
        return _cityName
    }
    
    var overview: String {
        if _overview == nil {
            _overview = ""
        }
        return _overview
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var temperature: String {
        if _temperature == nil {
            _temperature = ""
        }
        return _temperature
    }
    
    var pressure: String {
        if _pressure == nil {
            _pressure = ""
        }
        return _pressure
    }
    
    var humidity: String {
        if _humidity == nil {
            _humidity = ""
        }
        return _humidity
    }
    
    var windSpeed: String {
        if _windSpeed == nil {
            _windSpeed = ""
        }
        return _windSpeed
    }
    
    var windDirection: String {
        if _windDirection == nil {
            _windDirection = WindDirection.N
        }
        return "\(_windDirection)"
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
    
    init (cityName: String, cityId: Int) {
        
        self._cityId = cityId
        self._cityName = cityName
        
        _weatherURL = "\(URL_BASE)\(URL_CURRENT_WEATHER)?q=\(self.cityName)&units=metric&APPID=\(API_KEY)"
    }
    
    func getTimeFromEpoch(rawDate: String) -> String {
        
        let epochValue = NSTimeInterval(Int(rawDate)!)
        let myDate = NSDate(timeIntervalSince1970: epochValue)
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let dateString = formatter.stringFromDate(myDate)
        
        return "\(dateString)"
    }
    
    func downloadWeatherDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _weatherURL)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? NSDictionary {
                
                if let main = dict["main"] as? NSDictionary {
                    if let temp = main["temp"] {
                        let tempTmp = round(Double(temp.stringValue)!)
                        self._temperature = "\(Int(tempTmp))"
                    }
                    if let pressure = main["pressure"] {
                        self._pressure = pressure.stringValue
                    }
                    if let humidity = main["humidity"] {
                        self._humidity = humidity.stringValue
                    }
                }
                
                if let sys = dict["sys"] as? NSDictionary {
                    if let sunrise = sys["sunrise"] {

                        self._sunrise = self.getTimeFromEpoch(sunrise.stringValue)
                        print("Sunrise: \(self.sunrise)")
                    }
                    if let sunset = sys["sunset"] {

                        self._sunset = self.getTimeFromEpoch(sunset.stringValue)
                        print("Sunset: \(self._sunset)")
                    }
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] where weather.count > 0 {
                    
                    if let description = weather[0]["description"] as? String {
                    
                        self._description = description
                        print(description)
                    }
                }
                
                if let wind = dict["wind"] as? NSDictionary {
                    if let speed = wind["speed"] {
                        self._windSpeed = speed.stringValue
                    }
                    if let windDir = wind["deg"] {
                        let windTmp = Double(windDir.stringValue)!
                        print(windTmp)
                        switch (windTmp) {
                        case 348.75...360:
                            self._windDirection = WindDirection.N
                        case 0..<11.25:
                            self._windDirection = WindDirection.N
                        case 11.25..<33.75:
                            self._windDirection = WindDirection.NNE
                        case 33.75..<56.25:
                            self._windDirection = WindDirection.NE
                        case 56.25..<78.75:
                            self._windDirection = WindDirection.ENE
                        case 78.75..<101.25:
                            self._windDirection = WindDirection.E
                        case 101.25..<123.75:
                            self._windDirection = WindDirection.ESE
                        case 123.75..<146.25:
                            self._windDirection = WindDirection.SE
                        case 146.25..<168.75:
                            self._windDirection = WindDirection.SSE
                        case 168.75..<191.25:
                            self._windDirection = WindDirection.S
                        case 191.25..<213.75:
                            self._windDirection = WindDirection.SSW
                        case 213.75..<236.25:
                            self._windDirection = WindDirection.SW
                        case 236.25..<258.75:
                            self._windDirection = WindDirection.WSW
                        case 258.75..<281.25:
                            self._windDirection = WindDirection.W
                        case 281.25..<303.75:
                            self._windDirection = WindDirection.WNW
                        case 303.75..<326.25:
                            self._windDirection = WindDirection.NW
                        case 326.25..<348:
                            self._windDirection = WindDirection.NNW
                        default:
                            self._windDirection = WindDirection.N
                        }
                    }
                }
             }
            completed()
        }
    }
}












