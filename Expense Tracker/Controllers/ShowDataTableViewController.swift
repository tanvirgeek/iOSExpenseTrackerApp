//
//  ShowDataTableViewController.swift
//  Expense Tracker
//
//  Created by MD Tanvir Alam on 1/10/20.
//  Copyright © 2020 MD Tanvir Alam. All rights reserved.
//

import UIKit
import CoreData

class ShowDataTableViewController: UITableViewController {
    
    var expenses:[Expense]? {
         didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    @IBAction func totalBtnPressed(_ sender: UIBarButtonItem) {

                var totatExpense = 0.0
                if let expenses = expenses{
                    for expense in expenses{
                        if let cost = Double(expense.expense ?? "0.0"){
                            totatExpense += cost
                        }
                    }
                }
                showAlert(message:"Total Expense: \(totatExpense)")
    }
    //    @IBAction func totalBtnPressed(_ sender: UIBarButtonItem) {
//    }
    
    func showAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(expenses?.count)
        return expenses?.count ?? 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! TableViewCell
        cell.expense.text = expenses?[indexPath.row].title
        cell.taka.text = expenses?[indexPath.row].expense
        
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy h:mm a"
        let date = df.string(for: expenses?[indexPath.row].date)
        cell.date.text = date
        
        return cell
    }
}

