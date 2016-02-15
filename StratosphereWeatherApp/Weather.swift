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
    
    private var _cityId: Int!
    private var _cityName: String!
    private var _overview: String!
    private var _description: String!
    private var _temperature: String!
    private var _pressure: String!
    private var _humidity: String!
    private var _windSpeed: String!
    private var _windDirection: String!
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
            _windDirection = ""
        }
        return _windDirection
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
                        let epochValue = NSTimeInterval(Int(sunrise.stringValue)!)
                        let myDate = NSDate(timeIntervalSince1970: epochValue)
                        let formatter = NSDateFormatter()
                        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                        let dateString = formatter.stringFromDate(myDate)
                        self._sunrise = "\(dateString)"
                        print("Sunrise: \(dateString)")
                    }
                    if let sunset = sys["sunset"] {
                        let epochValue = NSTimeInterval(Int(sunset.stringValue)!)
                        let myDate = NSDate(timeIntervalSince1970: epochValue)
                        let formatter = NSDateFormatter()
                        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                        let dateString = formatter.stringFromDate(myDate)
                        self._sunset = "\(dateString)"
                        print("Sunset: \(dateString)")
                    }
                }
                
                if let weather = dict["weather"] as? NSDictionary {
                    if let description = weather["description"] {
                        self._description = "\(description.stringValue)"
                        print(self.description)
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
                        if windTmp > 0.0 && windTmp <= 11.25 {
                            self._windDirection = "N"
                        } else if windTmp > 11.25 && windTmp <= 33.75 {
                            self._windDirection = "NNE"
                        } else if windTmp > 33.75 && windTmp <= 56.25 {
                            self._windDirection = "NE"
                        } else if windTmp > 56.25 && windTmp <= 78.75 {
                            self._windDirection = "ENE"
                        } else if windTmp > 78.75 && windTmp <= 101.25 {
                            self._windDirection = "E"
                        } else if windTmp > 101.25 && windTmp <= 123.75 {
                            self._windDirection = "ESE"
                        } else if windTmp > 123.75 && windTmp <= 146.25 {
                            self._windDirection = "SE"
                        } else if windTmp > 146.25 && windTmp <= 168.75 {
                            self._windDirection = "SSE"
                        } else if windTmp > 168.75 && windTmp <= 191.25 {
                            self._windDirection = "S"
                        } else if windTmp > 191.25 && windTmp <= 213.75 {
                            self._windDirection = "SSW"
                        } else if windTmp > 213.75 && windTmp <= 236.25 {
                            self._windDirection = "SW"
                        } else if windTmp > 236.25 && windTmp <= 258.75 {
                            self._windDirection = "WSW"
                        } else if windTmp > 258.75 && windTmp <= 281.25 {
                            self._windDirection = "W"
                        } else if windTmp > 281.25 && windTmp <= 303.75 {
                            self._windDirection = "WNW"
                        } else if windTmp > 303.75 && windTmp <= 326.25 {
                            self._windDirection = "NW"
                        } else if windTmp > 326.25 && windTmp <= 348.75 {
                            self._windDirection = "NNW"
                        } else if windTmp > 348.75 && windTmp <= 360.0 {
                            self._windDirection = "N"
                        }
                    }
                }
             }
            completed()
        }
    }
}












