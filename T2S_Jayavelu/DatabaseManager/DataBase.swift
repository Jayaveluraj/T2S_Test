//
//  DataBase.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 27/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import Foundation
import CoreData
protocol DataBaseDelegate : class {
    func didfinishSavingMenus()
}

class DataBase{
    weak var delegate: DataBaseDelegate?
    
   public static let sharedInstance = DataBase()
    
    private init() {
    }
    
// MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    //MARK : Create Managed Object Context
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "T2S_Jayavelu", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    //MARK : Create Persistance Store
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Database.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true])
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            abort()
        }
        
        return coordinator
    }()
    
    //MARK : Create ManagedobjectContext
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

//MARK : FileFetcher Delegates & Helper Methods
extension DataBase : FileFetcherDelegate{
    
    
//    //MARK : Save Add on list
//    func addOnList(_ list: Array<Dictionary<String, Any>>) {
//        self.saveAddOnItems(list: list)
//
//    }
//    func saveAddOnItems(list : Array<Dictionary<String,Any>>) {
//        for addon in list {
//            generateAddOnsMenuManagedObject(addon)
//        }
//        saveContext()
//    }
//
//    func generateAddOnsMenuManagedObject(_ dictionary : Dictionary<String, Any>) {
//        if let menuid = dictionary["item_addon_cat"] , let menuName = dictionary["name"] {
//            let addOnEntity = NSEntityDescription.entity(forEntityName: "AddOn", in: self.managedObjectContext)
//            let addonManagedObject = AddOn.init(entity: addOnEntity!, insertInto: self.managedObjectContext)
//            addonManagedObject.adonid = (menuid as? String)!
//            addonManagedObject.adonname = menuName as? String
//        }
//    }
    
    //MARK : Save Menu Items
    func menuItems(_ menus: Array<Dictionary<String, Any>>) {
        self.saveMenuItems(menus)
    }
    
    func saveMenuItems(_ menus: Array<Dictionary<String, Any>>) {
        let arr  = FileFetcher().getAddonJSON()
        for menu in menus {
            generateMenuManagedObjectFrom(menu,arradon: arr)
        }
        saveContext()
        self.delegate?.didfinishSavingMenus()
    }
    
    func generateMenuManagedObjectFrom(_ dictionary : Dictionary<String, Any>, arradon: Array<Dictionary<String, Any>>){
        if let menuName = dictionary["name"] {
            let menuEntity = NSEntityDescription.entity(forEntityName: "MainMenu", in: self.managedObjectContext)
            let mainMenu = MainMenu.init(entity: menuEntity!, insertInto: self.managedObjectContext)
                mainMenu.menuname = menuName as? String
            if let subArr : Array<Dictionary<String,Any>> = (dictionary["subcat"] as? Array<Dictionary<String,Any>>) , subArr.count > 0 {
                let setSub = NSMutableSet()
                for dict : Dictionary<String,Any> in subArr {
                    let arrAddons : Array<Dictionary<String,Any>> = dict["item"] as! Array<Dictionary<String,Any>>
                    for dictAddon : Dictionary<String,Any> in arrAddons {
                        setSub.add(self.generateSubMenuManagedObject(dictAddon, arradon: arradon))
                    }
                }
                mainMenu.submenu = NSSet.init(set: setSub)
            }
        }
    }
    
    func generateSubMenuManagedObject(_ dictionary : Dictionary<String, Any>, arradon: Array<Dictionary<String, Any>>) -> NSManagedObject{
        let addOnEntity = NSEntityDescription.entity(forEntityName: "SubMenu", in: self.managedObjectContext)
        let subMenuManagedObject = SubMenu.init(entity: addOnEntity!, insertInto: self.managedObjectContext)
        subMenuManagedObject.submenuid = dictionary["item_addon_cat"] as? String
        subMenuManagedObject.submenuname = dictionary["name"] as? String
        subMenuManagedObject.addon = self.getAddonFor(key:(String(describing:dictionary["item_addon_cat"]!)), arradon: arradon)
        return subMenuManagedObject
    }
    
    func menuItemsFetchResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
       return  getFetchControllerFor(entity: "MainMenu", key: "menuname")
    }
    
    func addOnItemsFetchResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        return  getFetchControllerFor(entity: "AddOn", key: "adonname")
    }
    
    func getAddonFor(key: String, arradon : Array<Dictionary<String, Any>>) -> NSSet{
        let setaddOn = NSMutableSet()
        if arradon.count > 0 {
            for dict in arradon {
                if let valueCategoryId = dict["item_addon_cat"] as? Int {
                    //print("AAAA\(valueCategoryId),\(key)")
                    let categoryId = String(valueCategoryId)
                    if categoryId == key {
                        //print("BBBB")
                        let addOn : AddOn = self.getAddOnEntity()
                        addOn.adonname = dict["name"] as? String
                        addOn.adonid = categoryId
                        setaddOn.add(addOn)
                    }
                }
            }
            
        }
        return setaddOn
    }
    
    func  getAddOnEntity() -> AddOn {
        let addOnEntity = NSEntityDescription.entity(forEntityName: "AddOn", in: self.managedObjectContext)
        let addonManagedObject = AddOn.init(entity: addOnEntity!, insertInto: self.managedObjectContext)
        return addonManagedObject;
    }

    func getFetchControllerFor(entity:String, key : String) -> NSFetchedResultsController<NSFetchRequestResult>?  {
        let nameSort = NSSortDescriptor(key: key, ascending: true)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        fetchRequest.fetchBatchSize = 10
        fetchRequest.sortDescriptors = [nameSort]
        let moc = self.managedObjectContext
        let fRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fRC.performFetch()
            return fRC
        } catch {
            return nil
        }

    }

}


