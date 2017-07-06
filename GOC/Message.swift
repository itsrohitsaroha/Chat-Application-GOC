//
//  Message.swift
//  GOC
//
//  Created by Avnish Kumar on 03/07/17.
//  Copyright © 2017 SapeanIT. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
 
    var text : String?
    var toUid : String?
   var timestamp : NSNumber?
    var fromUid : String?
    
    
    
    func recipientUid() -> String? {
        return (FIRAuth.auth()?.currentUser?.uid)! == fromUid ? toUid:fromUid
    }
  
}
