//
//  CreateProgramController.swift
//  Stammtisch
//
//  Created by Marco Bibrich and Lea Boesch on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import SwiftyJSONRealmObject

class CreateProgramController: UIViewController {
    
    
    var overlay : UIView?
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:nil,action: #selector (donePressed))
    let doneButtonText = UIBarButtonItem(barButtonSystemItem: .done, target:nil,action: #selector (donePressedText))
    
    
    let toolbar = UIToolbar()
    let toolbarText = UIToolbar()
    
    
    var program = ProgramData()
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    let userCalendar = Calendar.current
    
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var datePickerText: UITextField!
    @IBOutlet weak var radiusText: UILabel!
    @IBOutlet weak var frequencyText: UILabel!
    

    @IBAction func radiusSlider(_ sender: UISlider) {
            radiusText.text = String(Int(sender.value))
    }
    
    @IBAction func frequencySlider(_ sender: UISlider) {
            switch Int(sender.value){
            case 4:
                frequencyText.text = "Alle 2 Monate"
            case 3:
                frequencyText.text = "Monatlich"
            case 2:
                frequencyText.text = "Alle 2 Wochen"
            case 1:
                frequencyText.text = "Wöchentlich"
            default:
                frequencyText.text = "Wöchentlich"
            }
    }
    
    
    let datePicker = UIDatePicker()
  
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var requestGroupName: UITextField!
    @IBOutlet weak var requestCityName: UITextField!

    
    @IBAction func requestButton(_ sender: UIButton) {
        performRequest()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.overlay?.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: false)
        toolbarText.sizeToFit()
        toolbarText.setItems([doneButtonText], animated: false)
        requestCityName.inputAccessoryView = toolbarText
        requestGroupName.inputAccessoryView = toolbarText
        makeDatePicker()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func makeDatePicker(){
        //datepicker after tutorial: youtube.com/watch?v=_ADJxJ7pjRk#t=426.928552063
        datePicker.datePickerMode = .dateAndTime
        //connect datepicker with label
        datePickerText.inputAccessoryView = toolbar
        datePickerText.inputView = datePicker
        
    }
    
    func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd.MM.YYYY HH:mm"
        datePickerText.text = dateFormatter.string(from:datePicker.date)
        self.view.endEditing(true)
    }
    func donePressedText(){
        self.view.endEditing(true)
    }

    
    
    
    
    func performRequest(){
    
        addOverlay()
    
        
        
        let urlStr =  "https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants+in+\(replaceUmlaute(cityName: requestCityName.text!))&radius=\(radiusText.text!)000&key=AIzaSyCXtLy-FhROvM7nlqfp0ZCAD_7jzisdQew&sensor=true"
        guard let url = URL(string: urlStr) else {
            print("invalid url")
            print(urlStr)
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) {  (data:Data?, response: URLResponse?, error: Error?) in
            
            if let error = error{
                print(error)
                self.performSegue(withIdentifier: "unwindToProgramList", sender: self)
                
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
            print(json["results"][0])
            
            var restaurants = [Restaurant]()
            
            
            let resultCount = json["results"].count
            var maxRestaurants = 20
            if(resultCount < maxRestaurants){
                maxRestaurants = resultCount
            }
            
            for index in 0 ..< maxRestaurants {
                var resti_json = json["results"][index]
                var resti = Restaurant()
                resti.name = resti_json["name"].stringValue
                resti.location_lat = resti_json["geometry"]["location"]["lat"].doubleValue
                resti.location_long = resti_json["geometry"]["location"]["lng"].doubleValue
                resti.formatted_address = resti_json["formatted_address"].stringValue
                
                //for extension purposes we keep these values commented
                //resti.icon = resti_json["icon"].url
                //resti.id = resti_json["id"].stringValue
                //resti.place_id = resti_json["place_id"].stringValue
                //resti.rating = resti_json["rating"].doubleValue
                //resti.photo_width = resti_json["photos"]["photo_width"].intValue
                //resti.photo_height = resti_json["photos"]["photo_height"].intValue
                //resti.photo_url = resti_json["photos"]["html_attributions"].stringValue
                
                
                restaurants.append(resti)
            }
            
            restaurants.shuffle()
            
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
            self.program.anlaesse.append(objectsIn: self.generateEvents(startDate: startDate, restaurants: restaurants, frequency: self.frequencyText.text!))
            
            
//Debugging
//            print("Request:")
//            print(self.requestCityName.text!)
//            print(self.program.groupName)
//            print(self.program.frequency)
//            print("Startdatum: ", startDate)
//            print("Radius: ", self.radiusText.text!)
            
            
            self.performSegue(withIdentifier: "unwindToProgramList", sender: self)
        }
        
        task.resume()
        
    
    }

    func generateEvents(startDate: Date, restaurants: [Restaurant], frequency: String) -> [Anlass]{
        var anlaesse = [Anlass]()
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
        
        for index in 0 ..< restaurants.count {
            let newAnlass = Anlass()
            newAnlass.eventDate = tempdate
            newAnlass.restaurant = restaurants[index]
            if(index>0){
                if (valueDay>0) {
                    newAnlass.eventDate = userCalendar.date(byAdding: .day, value: valueDay, to: tempdate)!
                }else{
                    newAnlass.eventDate = userCalendar.date(byAdding: .month, value: valueMonth, to: tempdate)!
                }
            }
            
            anlaesse.append(newAnlass)
            tempdate = newAnlass.eventDate!
            
        }
        return anlaesse
        
    }
    
    func addOverlay(){
        self.overlay = UIView(frame: view.frame)
        self.overlay!.backgroundColor = .white
        self.overlay!.alpha = 0.8
        view.addSubview(self.overlay!)
    }
  
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            var ProgramVC : ViewController = segue.destination as! ViewController
                ProgramVC.program = self.program
       }
    
    func replaceUmlaute(cityName: String) -> String{
        var cleanedCityName = cityName
        cleanedCityName = cleanedCityName.replace(target: "ü", withString:"ue")
        cleanedCityName = cleanedCityName.replace(target: "ä", withString:"ae")
        cleanedCityName = cleanedCityName.replace(target: "ö", withString:"oe")
        cleanedCityName = cleanedCityName.replace(target: "Ü", withString:"Ue")
        cleanedCityName = cleanedCityName.replace(target: "Ä", withString:"Ae")
        cleanedCityName = cleanedCityName.replace(target: "Ö", withString:"Oe")
        
        return cleanedCityName
    }
    
}

//ijoshsmith.com/2014/06/17/randomly-shuffle-a-swift-array/
extension Array {
        /** Randomizes the order of an array's elements. */
        mutating func shuffle()
        {
            for _ in 0..<10
            {
                sort { (_,_) in arc4random() < arc4random() }
            }
        }
}
//stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
