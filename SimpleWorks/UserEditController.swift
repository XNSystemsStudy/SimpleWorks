//
//  UserEditController.swift
//  SimpleWorks
//
//  Created by 심다래 on 2016. 3. 11..
//  Copyright © 2016년 XNRND. All rights reserved.
//

import UIKit
import CoreData

public class UserEditController: UIViewController {
    
    var select_id:String = "";
    
    /* Core Data */
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let coredataName:String = "User"
    
    @IBOutlet weak var mPropName: UITextView!
    @IBOutlet weak var mNumber: UITextView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let action = UserTableViewController()
        select_id = action.getID()
        setting()
    }
    
    func setting() {
        
        let entityDescription = NSEntityDescription.entityForName(coredataName, inManagedObjectContext: managedObjectContext)
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        do {
            
            let objects = try managedObjectContext.executeFetchRequest(request)
            if objects.count > 0 {
                
                for objects: AnyObject in objects {
                    
                    
                    if let key: AnyObject = objects.valueForKey("key") {
                        
                        if(key as! String == select_id) {
                            if let user: AnyObject = objects.valueForKey("name") {
                                print(user)
                                mPropName.text = user as! String
                            }
                        }
                        
                        if(key as! String == select_id) {
                            if let user: AnyObject = objects.valueForKey("phoneNumber") {
                                print(user)
                                mNumber.text = user as! String
                            }
                        }
                    }
                    
                }
            }
        } catch let error as NSError {
            print("findContact => managedObjectContext find function failed!!")
            print(error.code)
        }
    }
}
