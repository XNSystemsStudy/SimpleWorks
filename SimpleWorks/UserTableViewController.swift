//
//  UserTableViewController.swift
//  SimpleWorks
//
//  Created by 심다래 on 2016. 2. 18..
//  Copyright © 2016년 XNRND. All rights reserved.
//

import UIKit
import ContactsUI
import CoreData
//import "Realm.h"

class UserTableViewController: UITableViewController, CNContactPickerDelegate {
    
    @IBOutlet var table: UITableView!
    var names = [String]()
    
    /* Core Data */
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let coredataName:String = "User"
    
    func contactPicker(picker: CNContactPickerViewController,
        didSelectContacts contacts: [CNContact]) {
            print(contacts)
            print("Selected \(contacts.count) contacts")
            /* Realm */
//            let realm = try! Realm()
//            
//            try! realm.write {
//                realm.add(contacts)
//            }
            /* core data set */
            var i=0
            for (i=0; i<contacts.count; i++) {
                
                let entityDescription = NSEntityDescription.entityForName(coredataName, inManagedObjectContext: managedObjectContext)
                let config = User(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
                
                
                let match = contacts[i]
                
                if (match.valueForKey("givenName") != nil) {
                    
                    if let user: AnyObject = match.valueForKey("givenName") {
                        
                        config.name = user as? String
                        self.names.append(user as! String)
                    }
                    
                    do{
                        try managedObjectContext.save()
                        print("SaveContact => Contact saved SUCCESSFULLY!!!")
                        
                    } catch let error as NSError {
                        print("SaveContact => managedObjectContext save function failed!!")
                        print(error.code)
                    }
                }
            }
            self.table.reloadData()
    }
    
    func printcoredata() {
        let entityDescription = NSEntityDescription.entityForName(coredataName, inManagedObjectContext: managedObjectContext)
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        do {
            
            let objects = try managedObjectContext.executeFetchRequest(request)
            if objects.count > 0 {
                
                for objects: AnyObject in objects {
                    
                    if let user: AnyObject = objects.valueForKey("name") {
                        
                        print(user)
                        self.names.append(user as! String)
                    }
                }
                self.table.reloadData()
            }else{
                print("ConfigSetting => Not Config")
            }
        } catch let error as NSError {
            print("findContact => managedObjectContext find function failed!!")
            print(error.code)
        }

    }
    
    //allows multiple selection mixed with contactPicker:didSelectContacts:
    func PhotoTableGet(){
        let controller = CNContactPickerViewController()
        
        controller.delegate = self
        
        navigationController?.presentViewController(controller,
            animated: true, completion: nil)
    }
    
    @IBAction func UserAdd(sender: AnyObject) {
        PhotoTableGet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.registerClass(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        printcoredata()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            table.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = names[indexPath.row]
            
            return cell!
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
