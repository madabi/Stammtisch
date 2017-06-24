//
//  ViewController.swift
//  Stammtisch
//
//  Created by Marco Bibrich on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//


import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //var program:ProgramData = ProgramData()
    // get ProgramData from Realm
    let realm = try! Realm()
    
    //var program = ProgramData()
    
    var program:ProgramData = try! Realm().objects(ProgramData.self).first!

    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(program.anlaesse?.count ?? 0)
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        
        //format date
        let cellDayFormatter = DateFormatter()
        cellDayFormatter.dateFormat = "dd.MM"
        let cellHourFormatter = DateFormatter()
        cellHourFormatter.dateFormat = "hh:mm"
        
       
        let event = program.anlaesse?[indexPath.row]

        cell.dayLabel.text = cellDayFormatter.string(from: (event?.eventDate) ?? Date())
        cell.timeLabel.text = cellHourFormatter.string(from:(event?.eventDate) ?? Date())
        cell.restaurantTitle.text = (program.anlaesse?[indexPath.row])?.restaurant?.name ?? ""

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
