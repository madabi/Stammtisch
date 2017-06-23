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
    
    let listData = ["Audi", "Mercedes", "Chevrolet"]
    
    var program:ProgramData = ProgramData(groupName: String(), startDate: Date(), frequency: String(), restaurants: [Restaurant()])
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(program.restaurants.count)
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = program.restaurants[indexPath.row].name
        print(program.restaurants[indexPath.row].name)
        print(program.groupName)
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
