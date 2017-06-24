//
//  CreateProgramController.swift
//  Stammtisch
//
//  Created by Marco Bibrich on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CreateProgramController: UIViewController {
    
    var program = ProgramData()
    
    //@IBOutlet weak var datePickerText: UITextField!
//    @IBOutlet weak var datePickerText: UITextField!
//    
//    @IBOutlet weak var locationText: UITextField!
//    @IBOutlet weak var radiusText: UILabel!
    
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var datePickerText: UITextField!
    @IBOutlet weak var radiusText: UILabel!
    @IBOutlet weak var frequencyText: UILabel!
    
//    @IBAction func radiusSlider(_ sender: UISlider) {
//        radiusText.text = String(Int(sender.value))
//    }
//    
//    @IBOutlet weak var frequencyText: UILabel!
//    @IBAction func frequencySlider(_ sender: UISlider) {
//        switch Int(sender.value){
//        case 1:
//            frequencyText.text = "Alle 2 Monate"
//        case 2:
//            frequencyText.text = "Monatlich"
//        case 3:
//            frequencyText.text = "Alle 2 Wochen"
//        case 4:
//            frequencyText.text = "Wöchentlich"
//        default:
//            frequencyText.text = "Wöchentlich"
//        }
//        
//    }
    
    @IBAction func radiusSlider(_ sender: UISlider) {
            radiusText.text = String(Int(sender.value))
    }
    
    @IBAction func frequencySlider(_ sender: UISlider) {
            switch Int(sender.value){
            case 1:
                frequencyText.text = "Alle 2 Monate"
            case 2:
                frequencyText.text = "Monatlich"
            case 3:
                frequencyText.text = "Alle 2 Wochen"
            case 4:
                frequencyText.text = "Wöchentlich"
            default:
                frequencyText.text = "Wöchentlich"
            }
    }
    
    
    let datePicker = UIDatePicker()
    
    //@IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    
    
    @IBOutlet weak var requestGroupName: UITextField!
    
    @IBOutlet weak var requestCityName: UITextField!
    //@IBOutlet weak var requestGroupName: UITextField!
    //@IBOutlet weak var requestCityName: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //makeDatePicker()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func makeDatePicker(){
        //datepicker after tutorial: youtube.com/watch?v=_ADJxJ7pjRk#t=426.928552063
        datePicker.datePickerMode = .dateAndTime
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:nil,action: #selector (donePressed))
        // toolbar
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: false)
        
        
        //connect datepicker with label
        datePickerText.inputAccessoryView = toolbar
        datePickerText.inputView = datePicker
        
    }
    
    func donePressed(){
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        
        datePickerText.text = dateFormatter.string(from:datePicker.date)
        
        
        self.view.endEditing(true)
    }
    
    @IBAction func startRequest(_ sender: Any) {
        performRequest()
        
    }
    
    
    
    func performRequest(){
        
        if radiusText.text == "0" {
            radiusText.text = "1"
        }
        
        let urlStr =  "https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants+in+\(requestCityName.text!)&radius=\(radiusText.text!)000&key=AIzaSyC51kVvQ30YBdmhq4ivir2LhF65U50_6C4&sensor=true"
        guard let url = URL(string: urlStr) else {
            print("invalid url")
            print(urlStr)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data:Data?, response: URLResponse?, error: Error?) in
            
            if let error = error{
                print(error)
                return
            }
            
            if let response = response as? HTTPURLResponse{
                
                if response.statusCode >= 400{
                    print("Computer says NO: \(response.statusCode)")
                    return
                }
            }
            else {
                print("no response received")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            let json = JSON(data:data)
            // print("Received JSON: %@", json.description)
            print(json["results"][0])
            
            var restaurants = [Restaurant]()
            
            for index in 0 ..< json["results"].count {
                var resti_json = json["results"][index]
                var resti = Restaurant()
                resti.name = resti_json["name"].stringValue
                resti.icon = resti_json["icon"].url
                resti.id = resti_json["id"].stringValue
                resti.place_id = resti_json["place_id"].stringValue
                resti.formatted_address = resti_json["formatted_address"].stringValue
                resti.rating = resti_json["rating"].doubleValue
                resti.photo_width = resti_json["photos"]["photo_width"].intValue
                resti.photo_height = resti_json["photos"]["photo_height"].intValue
                resti.photo_url = resti_json["photos"]["html_attributions"].stringValue
                resti.location_lat = resti_json["geometry"]["location"]["lat"].doubleValue
                resti.location_long = resti_json["geometry"]["location"]["lng"].doubleValue
                
                restaurants.append(resti)
            }
            
            
            print(restaurants.count)
            for index in 0 ..< restaurants.count {
                print(restaurants[index].name)
            }
            
            
            let startDate = self.datePicker.date
            
            print(startDate)
            
            
            
            self.program = ProgramData()
            self.program.groupName = self.requestGroupName.text!
            self.program.startDate = startDate
            self.program.frequency = self.frequencyText.text!
            self.program.anlaesse = self.generateEvents(startDate: startDate, restaurants: restaurants, frequency: self.frequencyText.text!)
            
            
            
            print("Request:")
            print(self.requestCityName.text!)
            print(self.program.groupName)
            print(self.program.frequency)
            print("Startdatum: ", startDate)
            print("Radius: ", self.radiusText.text!)
            
            self.performSegue(withIdentifier: "showProgram", sender: self)
            
        }
        
        task.resume()
        
    }
    
    func generateEvents(startDate: Date, restaurants: [Restaurant], frequency: String) -> [Anlass]{
        var dates = [Date()]
        var anlaesse = [Anlass()]
        var tempdate = startDate
        var valueMonth = 0
        var valueDay = 0
        switch frequency {
        case "Alle 2 Monate":
            valueMonth = 2
        case "Monatlich":
            valueMonth = 1
        case "Alle 2 Wochen":
            valueDay = 14
        case "Wöchentlich":
            valueDay = 7
        default:
            valueDay = 7
        }
        var calendar = NSCalendar.current
        for index in 0 ..< restaurants.count {
            var newAnlass = Anlass()
            newAnlass.eventDate = tempdate
            newAnlass.restaurant = restaurants[index]
            anlaesse.append(newAnlass)
            if valueDay>0 {
                // Datum für nächsten Anlass finden:
                // tempdate = tempdate plus valueDay Tage
            }
            if valueMonth>0 {
                // Datum für nächsten Anlass finden:
                // tempdate = tempdate plus valueMonth Monate
            }
            
            
        }
        
        return anlaesse
        
        
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "showProgram") {
                var ProgramVC : ViewController = segue.destination as! ViewController
                ProgramVC.program = self.program
           }
    
       }
    
}
