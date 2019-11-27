import UIKit

class ListeningTimeListItem: UIViewController {
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    func configure(_ startTime: Float, endTime: Float) {
        self.startTime.text = String(describing: startTime)
        self.endTime.text = String(describing: endTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
