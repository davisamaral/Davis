//
//  SettingsFormViewController.swift
//  Davis
//
//  Created by davis.amaral on 04/09/22.
//

import UIKit
import CoreData

class SettingsFormViewController: UIViewController & UITableViewDelegate & UITableViewDataSource {
    
    var states: [State] = []
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var textFieldDollarQuote: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldIofTax: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStates()
        loadConfigs()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadConfigs(){        
        textFieldDollarQuote.text = "\(userDefaults.double(forKey: "dollarQuote"))"
        textFieldIofTax.text = "\(userDefaults.double(forKey: "iofTax"))"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let iofTax = Double(textFieldIofTax?.text ?? "6.38") ?? 6.38
        let dollarQuote = Double(textFieldDollarQuote?.text ?? "3.2") ?? 3.2
        userDefaults.setValue(iofTax, forKey: "iofTax")
        userDefaults.setValue(dollarQuote, forKey: "dollarQuote")
        super.viewDidDisappear(animated)
    }
    
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            states = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    @IBAction func addState(_ sender: Any) {
        showStateAlert()
    }
    
    private func showStateAlert(for state: State? = nil) {
        let title = state == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Nome do Estado"
            textField.text = state?.name
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Imposto"
            textField.keyboardType = .numberPad
            textField.text =  state?.tax == nil ? "" : "\(state?.tax)"
        }
        
        let okAction = UIAlertAction(title: title, style: .default) { _ in
            let state = state ?? State(context: self.context)
            state.name = alert.textFields?.first?.text
            state.tax = Double(alert.textFields?.last?.text ?? "0.0") ?? 0
            try? self.context.save()
            self.loadStates()
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = states.count
        if rows == 0 {
            self.tableView.setEmptyMessage("Nenhum estado cadastrado ainda!")
        } else {
            self.tableView.restore()
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StateTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: states[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.context.delete(states[indexPath.row])
            try? self.context.save()
            loadStates()
        }
    }
}
