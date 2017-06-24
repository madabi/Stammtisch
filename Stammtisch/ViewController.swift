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
    
    
    var program:ProgramData = ProgramData()
    let realm = try! Realm()
    
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
    
    @IBAction func unwindToProgramList(sender: UIStoryboardSegue) {
        let sourceViewController = sender.source as? CreateProgramController
        let program = sourceViewController?.program
        
        print(program?.anlaesse?.count)
        self.tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var test = realm.objects(ProgramData.self).count
        if test>0 {
            self.program = realm.objects(ProgramData.self).first!
            print(String("Group " + self.program.groupName!) ?? "no group name!!")
        }
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
