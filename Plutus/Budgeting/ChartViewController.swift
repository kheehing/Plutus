import UIKit
import SwiftChart

class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: Chart!
    
    var timeInterval: [Double] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var seriesData: [Double] = []
        var labels: [Double] = []
        var labelString: Array<String> = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM"
        
        let testData = getData()
        
        for (i, value) in testData.enumerated() {
            
            seriesData.append(value["amount"] as! Double)
            
            let onlyDate = dateFormatter.string(from: value["date"] as! Date)
            
            if (labels.count == 0 || labelString.last != onlyDate) {
                
                labels.append(Double(i))
                labelString.append(onlyDate)
            }
        }
        
        for i in 0...4 {
            
            let sevenDaysAgo = NSCalendar.current.date(byAdding: .day, value: i, to: Date())
            
            labelString.append(dateFormatter.string(from: sevenDaysAgo!))
            
        }
        
        print("\(seriesData)  \(labels)")
        let series = ChartSeries(seriesData)
        series.area = true
        
        chartView.xLabels = labels
        chartView.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return labelString[labelIndex]
        }
        
        chartView.add(series)
        
    }
    
    func getData() -> Array<Dictionary<String, Any>> {
        
        let tmr = NSCalendar.current.date(byAdding: .day, value: 1, to: Date())

        let dataReturn = [["date": Date(), "amount": 4.3],
        ["date": Date(), "amount": 6.4],
        ["date": Date(), "amount": 8.3],
        ["date": Date(), "amount": 2.2],
        ["date": Date(), "amount": 3.1],
        ["date": tmr, "amount": 0.0],
        ["date": tmr, "amount": 0.0]
        ]

        return dataReturn

    }

}
