//
//  User+CoreDataProperties.swift
//  SimpleWorks
//
//  Created by 심다래 on 2016. 2. 22..
//  Copyright © 2016년 XNRND. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var test: NSNumber?

}
