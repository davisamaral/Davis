import Foundation
import UIKit

extension Product {
    var formattedPrice: String {
        "$\(price)"
    }
    var pictureUIImage: UIImage? {
        if let data = picture {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
