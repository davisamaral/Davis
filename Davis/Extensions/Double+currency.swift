import Foundation

extension Double {
    
    var dollarFormatted: String {
        return formatCurrency(locale: Locale(identifier: "en-US"))
    }
    
    var realFormatted: String {
        return formatCurrency(locale: Locale(identifier: "pt-BR"))
    }
    
    private func formatCurrency(locale: Locale) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = locale
        return currencyFormatter.string(from: NSNumber(value: self))!
    }

}
