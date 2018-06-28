//
//  MainListViewController.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 27/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import UIKit
import CoreData
class MainListViewController: UITableViewController , NSFetchedResultsControllerDelegate, DataBaseDelegate{

    @IBOutlet var listView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?

    override func viewDidLoad() {
        super.viewDidLoad()
        DataBase.sharedInstance.delegate = self
        self.tableView.tableFooterView = UIView()
        FileFetcher().getMenuJSON()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializeFetchedResultsController()
    }

    //MARK : Initialize FetchedResultController
    func initializeFetchedResultsController() {
        if let fetchedResultsController = DataBase.sharedInstance.menuItemsFetchResultsController() {
            self.fetchedResultsController = fetchedResultsController
        }

    }
    //MARK : FileFetcher Delegate - Save MenuItems
    func didfinishSavingMenus() {
        initializeFetchedResultsController()
        if let _ = self.fetchedResultsController {
            tableView.reloadData()
        }
        
    }
    //MARK : Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SublistSegueIdentifier", let subLis = sender as? NSSet {
             let controller = segue.destination as! SubListTableViewController
            controller.subList = subLis
        }

    }


// MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.fetchedResultsController?.sections?.count) ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.fetchedObjects?.count ?? 0;

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customidentifier", for: indexPath) as! CustomTableCell
        if let frc = fetchedResultsController,let mainMenu = frc.object(at: indexPath) as? MainMenu, let menuName = mainMenu.menuname, let count = mainMenu.submenu?.count{
            cell.lblMessage.text = menuName
            cell.lblCount.text = String(count)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let frc = fetchedResultsController, let mainMenu = frc.object(at: indexPath) as?  MainMenu {
            if let subList = mainMenu.submenu {
            self.performSegue(withIdentifier: "SublistSegueIdentifier", sender: subList)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    //MARK : Memory Warnning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }




}

