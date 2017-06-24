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
    
    
    var tableData:TableContents = TableContents()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(tableData.cells.count ?? 0)
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        
        //format date
        let cellDayFormatter = DateFormatter()
        cellDayFormatter.dateFormat = "dd.MM"
        let cellHourFormatter = DateFormatter()
        cellHourFormatter.dateFormat = "hh:mm"
        

        let cellContent = tableData.cells[indexPath.row]

        cell.dayLabel.text = cellDayFormatter.string(from: (cellContent.dateString) ?? Date())
        cell.timeLabel.text = cellHourFormatter.string(from:(cellContent.dateString) ?? Date())
     //   cell.restaurantTitle.text = (program.anlaesse?[indexPath.row])?.restaurant?.name ?? ""
        cell.restaurantTitle.text = (cellContent.restiString ?? "")

        return(cell)
    }
    
    @IBAction func unwindToProgramList(sender: UIStoryboardSegue) {
        let sourceViewController = sender.source as? CreateProgramController
        let tableData = sourceViewController?.tableData
            print("Anzahl Einträge in tableData in unwindToProgramList: ", tableData?.cells.count)
        self.tableView.reloadData()
    }

    func saveTableData (){
        // Get the default Realm
        let realm = try! Realm()
        // You only need to do this once (per thread)
        let eintraege = realm.objects(TableContents.self)
        if eintraege.count>0 {
            try! realm.write {
                realm.deleteAll()
            }
        }
        
        try! realm.write {
            realm.add(self.tableData)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        saveTableData()

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
