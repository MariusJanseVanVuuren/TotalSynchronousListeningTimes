import UIKit

class MainContainerViewController: UIViewController {
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var listContainer: UIStackView!
    
    @IBOutlet weak var childView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWithListeningTimes()
    }
    
    private func configureWithListeningTimes() {
        if let listeningTimes = readListeningTimesJsonFile() {
            let fullListeningTime = determineTotalSynchronousListeningTime(from: listeningTimes.times)
            addTotalListeningTimeLabel(fullListeningTime)
            addBarChart(with: listeningTimes.times)
            addListeningTimeListItems(with: listeningTimes)
        }
    }
    
    func addTotalListeningTimeLabel(_ fullListeningTime: Float) {
        let totalListeningDuration = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 70))
        totalListeningDuration.font = UIFont(name:"HelveticaNeue-Bold", size: 25)
        totalListeningDuration.heightAnchor.constraint(equalToConstant: 70).isActive = true
        totalListeningDuration.text = "Total listening time = " + String(fullListeningTime)
        listContainer.addArrangedSubview(totalListeningDuration)
    }
    
    // Graph of listening times
    func addBarChart(with listeningTimes: [ListeningTime]) {
        let barChartView = BarChartView()
        barChartView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: barChartView.contentSpace)
        barChartView.dataEntries = listeningTimes
        barChartView.heightAnchor.constraint(equalToConstant: barChartView.contentSpace).isActive = true
        listContainer.addArrangedSubview(barChartView)
    }
    
    // List of listening times
    private func addListeningTimeListItems(with listeningTimes: ListeningTimes) {
        for listeningTime in listeningTimes.times {
            addListenTimeListItemToScrollView(with: listeningTime)
        }
        updateScrollViewContentSize()
    }
    
    private func addListenTimeListItemToScrollView(with listeningTime: ListeningTime) {
        let listViewItem = ListeningTimeListItem(nibName: String(describing: ListeningTimeListItem.self),bundle: Bundle(for: ListeningTimeListItem.self))
        self.addChild(listViewItem)
        listContainer.addArrangedSubview(listViewItem.view)
        listViewItem.didMove(toParent: self)
        listViewItem.configure(listeningTime.startTime, endTime: listeningTime.endTime)
    }
    
    private func updateScrollViewContentSize() {
        listContainer.layoutIfNeeded()
        containerScrollView.contentSize = CGSize.init(width: listContainer.frame.width,
                                                      height: listContainer.frame.height)// + //barChartContainer.frame.height)
    }
}

