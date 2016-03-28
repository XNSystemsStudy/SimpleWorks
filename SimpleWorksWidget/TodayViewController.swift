//
//  TodayViewController.swift
//  SimpleWorksWidget
//
//  Created by 심다래 on 2016. 3. 18..
//  Copyright © 2016년 XNRND. All rights reserved.
//

import UIKit
import NotificationCenter

extension UIInputViewController {
    
    func openURL(url: NSURL) -> Bool {
        do {
            let application = try self.sharedApplication()
            return application.performSelector("openURL:", withObject: url) != nil
        }
        catch {
            return false
        }
    }
    
    func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }
            
            responder = responder?.nextResponder()
        }
        
        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }
    
}

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var number: UILabel!
    
    @IBAction func CallBtn(sender: UIButton) {
        print("Call")
        extensionContext?.openURL(NSURL(string: "foo://")!, completionHandler: nil)
//        let urlString = "tel://" + number.text!
//        print(urlString)
//
//        let numberURL = NSURL(string: urlString)
//        UIApplication.sharedApplication().openURL(numberURL!)
        
        
        //UIApplication.openURL(numberURL)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
