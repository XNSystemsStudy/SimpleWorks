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
import RealmSwift

class Person: Object {
    dynamic var key = ""
    dynamic var givenName = ""
    dynamic var familyName = ""
    dynamic var phoneNumbers = ""
    dynamic var digits = ""
}
extension String {
    
    var length: Int { return characters.count }
    
    func startsWith(string: String) -> Bool {
        
        guard let range = rangeOfString(string, options:[.AnchoredSearch, .CaseInsensitiveSearch]) else {
            return false
        }
        
        return range.startIndex == startIndex
    }
}

var select_id:String = ""

class UserTableViewController: UITableViewController, CNContactPickerDelegate {
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var EditCall: UITableViewCell!
    var names = [Person]()
    
    /* Core Data */
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let coredataName:String = "User"
    /* Realm */
    let realm = try! Realm()
    
    func contactPicker(picker: CNContactPickerViewController,
        didSelectContacts contacts: [CNContact]) {
      //      print(contacts.)
            print("Selected \(contacts.count) contacts")
            
            /* core data set */
            var i=0
            for (i=0; i<contacts.count; i++) {
                
                let entityDescription = NSEntityDescription.entityForName(coredataName, inManagedObjectContext: managedObjectContext)
                let config = User(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
                let realm = try! Realm()
                let selectPerson = Person()
                
                let match = contacts[i]
                
//                
//                [<CNContact: 0x12578fe20: identifier=1E6F1138-84D5-4392-963E-1D202D9D7124, givenName=심다래, familyName=, organizationName=, phoneNumbers=(
//                    "<CNLabeledValue: 0x12550b710: identifier=434C31AA-6C92-414E-BCD9-12345D660F14, label=_$!<Mobile>!$_, value=<CNPhoneNumber: 0x1255cc2f0: countryCode=kr, digits=01037632562>>"
//                    ), emailAddresses=(
//                    ), postalAddresses=(
//                    )>]
                
                if (match.valueForKey("givenName") != nil) {
                    
                    if let user: AnyObject = match.valueForKey("givenName") {
                        
                        config.name = user as? String
                        selectPerson.familyName = ""
                        selectPerson.givenName = user as! String
                    }
                }
                NSLog("%d", __LINE__)
                
                if (match.valueForKey("identifier") != nil) {
                    NSLog("%d", __LINE__)
                    if let user: AnyObject = match.valueForKey("identifier") {
                        config.key = (user as? String)!
                        selectPerson.key = (user as? String)!
                        NSLog("%d %s", __LINE__, selectPerson.key)
                    }
                }
                
                if (match.valueForKey("phoneNumbers") != nil) {
                    if let str: AnyObject = match.valueForKey("phoneNumbers") {
                        
//                        for c in str {
//                            print(c["digits"] as NSString)
//                        }
                        
                        
//                        let match_2 = str
//                        if let user2: AnyObject = match.valueForKey("value=") != nil {
//                            print(user2)
//                        }
                        let str_2:String = String(str)
                        print(str)
                        print(str_2)
                        
                        NSLog("%d", __LINE__)
                        if (str_2.rangeOfString("digits=") != nil) {
                            NSLog("%d=>%s", __LINE__, str_2)
                            var propertyArrs:[String] = str_2.componentsSeparatedByString(",");
                            
                                                    for (var i:Int = 1; i < propertyArrs.count; i++) {
                                                        NSLog("%d=%s", __LINE__, propertyArrs[i])
                                                        if (propertyArrs[i].startsWith("digits=")) {
                                                            print("TEST")
                                                            print(propertyArrs[i])
                                                        }
                            }
                        }
    
                        //let test = str.rangeOfString("value=")
                       // print(test)

                        
//                        var propertyArrs:[String] = str.componentsSeparatedByString(" ");
//                        
//                        for (var i:Int = 1; i < propertyArrs.count; i++) {
//                            if (propertyArrs[i].startsWith("digits=")) {
//                                config.phoneNumber = propertyArrs[i].substringFromIndex("digits=".length);
//                                selectPerson.phoneNumbers = propertyArrs[i].substringFromIndex("digits=".length);
//                            }
//                        }
                    }
                }

                try! realm.write {
                    realm.add(selectPerson)
                }
                self.names.append(selectPerson)
                do{
                    try managedObjectContext.save()
                    print("SaveContact => Contact saved SUCCESSFULLY!!!")
                    
                } catch let error as NSError {
                    print("SaveContact => managedObjectContext save function failed!!")
                    print(error.code)
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
                    
                    let selectPerson = Person()
                    
                    if let user: AnyObject = objects.valueForKey("name") {
                        
                        
                        selectPerson.familyName = ""
                        selectPerson.givenName = user as! String
                        print(user)
                    }
                    
                    if let key: AnyObject = objects.valueForKey("key") {
                        
                    
                        selectPerson.key = key as! String
                    }
                    
                    if let key: AnyObject = objects.valueForKey("phoneNumber") {
                        
                        
                        selectPerson.digits = key as! String
                    }
                    
                      self.names.append(selectPerson )

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
        table.dequeueReusableCellWithIdentifier("PersonCell")
        
        cell!.textLabel!.text = names[indexPath.row].givenName
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("click")
        select_id = names[indexPath.row].key
        print(select_id)
    }
    
    func getID() -> String {
        return select_id
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
