

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    var videoUrl: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        
        self.videoUrl = dictionary["videoUrl"] as? String
    }
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
}



















