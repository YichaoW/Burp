//
//  AddIngredientsTableViewController.swift
//  Burp
//
//  Created by William on 5/29/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import UIKit

class AddIngredientsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	// MARK: - UIElements
	@IBOutlet var tableView: UITableView!
	
	// MARK: - Fields
	let cellReuseIdentifier = "IngredientCell"
	var ingDataCollection = [ingData]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		tableView.delegate = self
		tableView.dataSource = self
		askServer(query: "appl")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

	
	// MARK: - Retrieve Data
	fileprivate func askServer(query : String) {
		var request = URLRequest(url: URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete?metaInformation=false&number=10&query=\(query)")!)
		request.httpMethod = "GET"
//		let postString = ""
//		request.httpBody = postString.data(using: .utf8)
		request.addValue("vxPA0uhUCXmshjiEBrQ1Dgu6pP2dp126FVcjsngqOvVZln3jt9", forHTTPHeaderField: "X-Mashape-Key")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				// check for fundamental networking error
				print("error=\(String(describing: error))")
				return
			}
			
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				// check for http errors
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				print("response = \(String(describing: response))")
			}
			
			let JSONobject = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
			let questions = JSONobject as? [Any]
			self.ingDataCollection.removeAll(keepingCapacity: false)
			for question in questions! {
				self.ingDataCollection.append(ingData(json: question as! [String:Any])!)
			}

		}
		task.resume()
	}
	
	// number of rows in table view
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// create a new cell if needed or reuse an old one
		let cell:IngredientsCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! IngredientsCell
		
		// Configure the cell...
		
		
		return cell
	}
	
	/*
	func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 0
	}
	*/


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}