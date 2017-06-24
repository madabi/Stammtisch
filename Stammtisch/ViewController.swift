//
//  ViewController.swift
//  Stammtisch
//
//  Created by Marco Bibrich on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var program:ProgramData = ProgramData()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(program.anlaesse?.count ?? 0)
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EventCell(style: UITableViewCellStyle.default, reuseIdentifier: "eventCell")
        
        //format date
        let cellDayFormatter = DateFormatter()
        cellDayFormatter.dateFormat = "dd MM"
        let cellHourFormatter = DateFormatter()
        cellHourFormatter.dateFormat = "hh-mm"
        
        //cellDateFormatter.dateStyle = .full
        //cellDateFormatter.timeStyle = .short
        let event = program.anlaesse?[indexPath.row]
        print(event?.eventDate)
        
        if(event?.eventDate != nil){
        //cell.dayLabel.text = cellDayFormatter.string(from: (event?.eventDate)!)
        //cell.timeLabel.text = cellHourFormatter.string(from:(event?.eventDate)!)
        print(event?.eventDate!)
        
        //cell.restaurantTitle.text = program.anlaesse?[indexPath.row].restaurant?.name ?? ""
        }
        

        


        //print(program.anlaesse?[indexPath.row].eventDate)
        //print(program.restaurants[indexPath.row].name
        //print(program.groupName)
        return(cell)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
    }
    
}
