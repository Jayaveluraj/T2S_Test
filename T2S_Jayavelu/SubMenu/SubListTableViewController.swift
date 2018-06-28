//
//  SubListTableViewController.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 28/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import UIKit

class SubListTableViewController: UITableViewController {

    var subList : NSSet?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Items"
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
    }

    //MARK : Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddonIdentifiers", let addonlist = sender as? NSSet {
            let controller = segue.destination as! AddOnViewController
            controller.addOnList = addonlist 
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcellidentifier", for: indexPath)
        let submenu : SubMenu =  self.subList?.allObjects[indexPath.row] as! SubMenu
        cell.textLabel?.textColor = UIColor.gray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = submenu.submenuname
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let submenu : SubMenu =  self.subList?.allObjects[indexPath.row] as! SubMenu
                self.performSegue(withIdentifier: "AddonIdentifiers", sender: submenu.addon)
    }
    //MARK : Memorry Warnning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
