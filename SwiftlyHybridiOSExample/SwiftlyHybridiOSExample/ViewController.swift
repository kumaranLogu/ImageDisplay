
import UIKit

class ViewController: UIViewController {
    var theHandler:SwiftlyMessageHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theHandler = SwiftlyMessageHandler(theController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

