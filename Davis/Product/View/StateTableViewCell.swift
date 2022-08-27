import UIKit

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var labelViewStateName: UILabel!
    @IBOutlet weak var labelViewStateTax: UILabel!
    
    func configure(with state: State) {
        labelViewStateName.text = state.name
        labelViewStateTax.text = "\(state.tax)"
    }
}
