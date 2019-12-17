import UIKit

class Terms_ConditionsViewController: UIViewController {
    @IBOutlet weak var TcTitle: UILabel?
    
    var titleText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TcTitle?.text = titleText

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
