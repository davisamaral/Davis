class GetProducts : GetProductsUseCase {
    
    func getProducts() -> [Product] {
        let california = State(id: "1", name: "California", tax: 3.2)
        let newYork = State(id: "2", name: "New York", tax: 5.6)
        let texas = State(id: "3", name: "Texas", tax: 6.3)
        return [
            Product(id: "1", name: "iPhone 12", picture: "", price: 1199.99, state: california),
            Product(id: "2", name: "MacBoock Pro", picture: "", price: 2099.99, state: newYork),
            Product(id: "3", name: "Surface", picture: "", price: 1499.99, state: texas),
        ]
    }
}
