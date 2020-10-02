//
//  ViewController.swift
//  Expense Tracker
//
//  Created by MD Tanvir Alam on 30/9/20.
//  Copyright © 2020 MD Tanvir Alam. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var expenses = [Expense]()
    
    @IBOutlet weak var titleOfExpense: UITextField!
    @IBOutlet weak var expense: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleOfExpense.delegate = self
        expense.delegate = self
        
    }

    @IBAction func submitBtnPressed(_ sender: UIButton) {
        let newExpense = Expense(context: context)
        newExpense.title = titleOfExpense.text
        newExpense.expense = expense.text
        newExpense.date = Date()
        do {
            try context.save()
            showAlert(message: "Data Saved Successfully")
        }catch{
            print("error saving data\(error)")
            showAlert(message: "Saving failed: \(error.localizedDescription)")
        }
        
        removeText()

    }
    @IBAction func thisMonthExpenseBtn(_ sender: UIButton) {
        
        //Create two date objects
        let calender = Calendar.current
        let rightNow = Date()
        let currentMonth = calender.component(.month, from: rightNow)
        let currentYear = calender.component(.year, from: rightNow)

        let dateComponents = DateComponents(calendar: calender, year: currentYear, month: currentMonth)
        let startingDateOfTheMonth = calender.date(from: dateComponents)
        
        //Request and Predicate and Fetch Data
        let request:NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startingDateOfTheMonth! as CVarArg, rightNow as CVarArg)
        do{
            expenses = try context.fetch(request)
        }catch{
            print("Error fetching Data")
        }
        
        performSegue(withIdentifier: "goToShowData", sender: self)
        removeText()
    }
    
    @IBAction func showAllExpenseBtn(_ sender: UIButton) {
        let request:NSFetchRequest<Expense> = Expense.fetchRequest()
        do{
            expenses = try context.fetch(request)
        }catch{
            print("Error fetching Data")
        }
        //go to other screen
        performSegue(withIdentifier: "goToShowData", sender: self)
        // set the Expenses Array to the other screen variable
        removeText()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToShowData"){
            let destinationVC = segue.destination as! ShowDataTableViewController
            destinationVC.expenses = expenses
            
        }
    }
    
    func showAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (action) in
            
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func removeText(){
        titleOfExpense.text = ""
        expense.text = ""
    }
}


// Text Field Delegate Methods
extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
}
