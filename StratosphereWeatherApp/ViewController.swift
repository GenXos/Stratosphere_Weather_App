//
//  ViewController.swift
//  StratosphereWeatherApp
//
//  Created by Todd Fields on 2016-02-14.
//  Copyright © 2016 Skullgate Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var windDirectionLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let weather = Weather(cityName: "Winnipeg", cityId: 6183235)
        
        weather.downloadWeatherDetails() { () -> () in
            // this will be called when download is done.
            //self.updateUI()
            print(weather.temperature)
            self.tempLbl.text = weather.temperature
            self.humidityLbl.text = "Humidity: \(weather.humidity) %"
            self.windSpeedLbl.text = "Wind Speed: \(weather.windSpeed) km/h"
            self.windDirectionLbl.text = "Wind Direction: \(weather.windDirection)"
            self.sunriseLbl.text = "Sunrise: \(weather.sunrise)"
            self.sunsetLbl.text = "Sunset: \(weather.sunset)"
            self.descriptionLbl.text = "\(weather.description)"
            self.cityNameLbl.text = "\(weather.cityName)"
        }
        
    }

}

