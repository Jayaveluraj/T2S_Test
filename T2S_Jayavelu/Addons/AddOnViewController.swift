//
//  AddOnViewController.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 28/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import UIKit

class AddOnViewController: UITableViewController {
    var addOnList : NSSet?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "AddON's"
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addOnList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Addonidentifier", for: indexPath)
        let submenu : AddOn =  self.addOnList?.allObjects[indexPath.row] as! AddOn
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = submenu.adonname;
        return cell
    }
    

}
