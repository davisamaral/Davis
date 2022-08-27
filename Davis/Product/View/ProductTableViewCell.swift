import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProductPicture: UIImageView!
    @IBOutlet weak var labelViewProductName: UILabel!
    @IBOutlet weak var labelViewProductPrice: UILabel!
    
    func configure(with product: Product) {
        imageViewProductPicture.image = product.pictureUIImage
        labelViewProductName.text = product.name
        labelViewProductPrice.text = product.price.dollarFormatted
    }
}
