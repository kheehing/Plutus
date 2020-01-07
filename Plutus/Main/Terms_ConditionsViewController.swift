import UIKit

class Terms_ConditionsViewController: UIViewController {
    @IBOutlet weak var TcTitle: UILabel?
    
    var titleText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TcTitle?.text = titleText
    }
}
