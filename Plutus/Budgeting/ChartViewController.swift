import UIKit
import SwiftChart

class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: Chart!
    
    var timeInterval: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...4 {
            
            let sevenDaysAgo = NSCalendar.current.date(byAdding: .day, value: -i, to: Date())
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.dateFormat = "dd/MM/yy"
            
            timeInterval.append(sevenDaysAgo!.timeIntervalSince1970)
            print(dateFormatter.string(from: sevenDaysAgo!))
            
        }
        
        print(timeInterval)
        
        let data = [0, 2.5, 3.1, 4.2, -2.4, 4.5, 4.0, 3.5]
        let series = ChartSeries(data)
        series.area = true
//        let mainArray = [0, 3, 6, 9, 12,]
//        let displayArray = ["01/03/18", "12/03/18", "15/03/18", "17/03/18", "20/03/18"]
        chartView.xLabels = [0, 2, 5, 7, 8]
//        chartView.xLabelsFormatter =  { (labelIndex: Int, labelValue: Double) -> String in
//            return displayArray[labelIndex]
//        }

        chartView.add(series)
        
        
        
    }

}
