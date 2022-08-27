import UIKit
import CoreData

class OrderResumeViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var products: [Product] = []
    private var iofTax: Double = 0.0
    private var dollarQuote: Double = 1.0
    
    @IBOutlet weak var labelViewDollarTotal: UILabel!
    
    @IBOutlet weak var labelViewRealTotal: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadProducts()
    }
    
    private func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(fetchRequest)
            calcTotals()
        } catch {
            print(error)
        }
    }
    
    private func calcTotals(){
        iofTax  = userDefaults.double(forKey: "iofTax")
        dollarQuote  = userDefaults.double(forKey: "dollarQuote")
        
        var dollarTotal: Double = 0.0
        var realTotal: Double = 0.0
        
        products.forEach { product in
            dollarTotal += (product.price)
            realTotal += calcRealValue(product: product)
        }
        
        labelViewDollarTotal.text = dollarTotal.dollarFormatted
        labelViewRealTotal.text = realTotal.realFormatted
    }
    
    func calcRealValue(product: Product) -> Double {
        var result = (product.price * dollarQuote)
        let stateTax: Double = product.state?.tax ?? 0.0
        if(stateTax > 0.0){
            result += (result * (stateTax/100))
        }
        if(product.wasPaidByCreditCard && iofTax > 0.0){
            result += (result * (iofTax/100))
        }
        return result
    }
}
