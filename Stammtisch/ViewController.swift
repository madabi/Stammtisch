//
//  ViewController.swift
//  Stammtisch
//
//  Created by Marco Bibrich on 23.06.17.
//  Copyright © 2017 Stammtisch. All rights reserved.
//


import UIKit
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    var program:ProgramData = ProgramData()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(program.anlaesse?.count ?? 0)
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
    
        let event = program.anlaesse?[indexPath.row]
        let date : [String] = getDateFormatted(date: (event?.eventDate) ?? Date())

        cell.dayLabel.text = date[0]
        cell.timeLabel.text = date[1]
        cell.restaurantTitle.text = (program.anlaesse?[indexPath.row])?.restaurant?.name ?? ""
        cell.addressLabel.text = (program.anlaesse?[indexPath.row])?.restaurant?.formatted_address ?? ""

        return(cell)
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let request = UITableViewRowAction(style: .normal, title: "Anfragen") { action, index in
            print("request button tapped")
            let eventDate : [String] = self.getDateFormatted(date: ((self.program.anlaesse?[index.row])?.eventDate)!)
            
            let requestMail = "<p>Sehr geehrte Damen und Herren</p><p>Gerne würde ich anfragen, ob Sie am " + eventDate[0] + " um " + eventDate[1] + " Uhr noch einen Tisch für 10 Personen frei haben. Falls ja, würde ich diesen gerne reservieren.</p><br/><p>Herzlichen Dank für Ihre Rückmeldung und freundliche Grüsse,</p><br>"

            self.sendEmail(message: requestMail, date: eventDate[0] + " " + eventDate[1] + " Uhr")
       
            
        }
        
        
        request.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.0, blue: 0.3, alpha: 0.5)
        
        let share = UITableViewRowAction(style: .normal, title: "Teilen") { action, index in
            print("share button tapped")
            
            
            //sharing functionality: help from stackoverflow.com/questions/35931946/basic-example-for-sharing-text-or-image-with-uiactivityviewcontroller-in-swift
            // text to share
            let eventDate : [String] = self.getDateFormatted(date: ((self.program.anlaesse?[index.row])?.eventDate)!)
            let restaurant = (self.program.anlaesse?[index.row])?.restaurant?.name
            
            
            let introSnippet =  "Programm für " + eventDate[0] + ":\n"
            let dateSnippet = "Wann: " + eventDate[1] + " Uhr: \n"
            let restaurantSnippet = "Wo: " + restaurant! + "\n"
            let addressSnippet = "Adresse: " + ((self.program.anlaesse?[index.row])?.restaurant?.formatted_address)!
            let textToShare = [ introSnippet + dateSnippet + restaurantSnippet + addressSnippet ]
            
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        share.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.8, blue: 0.2, alpha: 0.5)
        
        return [request, share]
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /* ralfebert.de/tutorials/ios-swift-uitableviewcontroller/reorderable-cells/ */
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.program.anlaesse?[sourceIndexPath.row]
        self.program.anlaesse?.remove(at: sourceIndexPath.row)
        self.program.anlaesse?.insert(movedObject!, at: destinationIndexPath.row)
    }
    
    
    
    @IBAction func unwindToProgramList(sender: UIStoryboardSegue) {
        let sourceViewController = sender.source as? CreateProgramController
        self.program = (sourceViewController?.program)!
        
        
        self.tableView.reloadData()
        self.updateEditButton()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateEditButton()
        
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
        
        
    }
    
    private func getDateFormatted(date: Date) -> [String] {
        var dates : [String] = [String]()
        let cellDayFormatter = DateFormatter()
        cellDayFormatter.dateFormat = "dd.MM."
        let cellHourFormatter = DateFormatter()
        cellHourFormatter.dateFormat = "hh:mm"
        
        dates.append(cellDayFormatter.string(from: date))
        dates.append(cellHourFormatter.string(from: date))
        
        return dates
        
    }
    
    //hackingwithswift.com/example-code/uikit/how-to-send-an-email
    func sendEmail(message: String, date: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([""])
            mail.setSubject(date)
            mail.setMessageBody(message, isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func updateEditButton(){
        if(self.program.anlaesse == nil){
            self.editBarButton.tintColor = .clear
            self.editBarButton.isEnabled = false
        }else{
            self.editBarButton.tintColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1)
            self.editBarButton.isEnabled = true
        }
    }
}
