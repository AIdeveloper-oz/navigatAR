//
//  SelectNodesViewController.swift
//  navigatAR
//
//  Created by Jack Cai on 2/18/18.
//  Copyright © 2018 MICDS Programming. All rights reserved.
//

import CodableFirebase
import Firebase
import UIKit

class SelectNodesViewController: UITableViewController {

	@IBOutlet var nodesTable: UITableView!
	
	var nodes: [Node]?

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

		nodesTable.dataSource = self
		
		let ref = Database.database().reference()
		
		// Continuously update `nodes` from database
		ref.child("nodes").queryOrdered(byChild: "building").observe(.value, with: { snapshot in
			guard let value = snapshot.value else { return }
			
			do {
				//guard let currentBuilding = Building.current(root: snapshot) else { print(""); return }
				
				self.nodes = Array((try FirebaseDecoder().decode([FirebasePushKey: Node].self, from: value)).values)//.filter({ $0.building == currentBuilding.id })
				self.nodesTable.reloadData()
			} catch let error {
				print(error) // TODO: properly handle error
			}
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return nodes!.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = nodesTable.dequeueReusableCell(withIdentifier: "NodeCell", for: indexPath) as UITableViewCell
		let node = nodes![indexPath.row]
		
		cell.textLabel?.text = node.name
		cell.detailTextLabel?.text = String(describing: node.type)
		
		return cell
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
