//
//  FileFetcher.swift
//  T2S_Jayavelu
//
//  Created by JAYAVELU R on 27/06/18.
//  Copyright © 2018 Jayavelu. All rights reserved.
//

import Foundation
import UIKit
protocol FileFetcherDelegate : class {
    func menuItems(_ menus : Array<Dictionary<String, Any>>)
//    func addOnList(_ list : Array<Dictionary<String,Any>>)
}
class FileFetcher {
    weak var delegate : FileFetcherDelegate?
    //MARK : Fetch Menu File
    func getMenuJSON() {
        if(DataBase.sharedInstance.menuItemsFetchResultsController()?.fetchedObjects?.count == 0)
       {
                 delegate = DataBase.sharedInstance

            if let path = Bundle.main.url(forResource: "Menu", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Array<Dictionary<String,Any>> {
                            self.delegate?.menuItems(jsonResult)
                        }
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        
        }
    }
    //MARK : Fetch AdonFile
    func getAddonJSON() -> Array<Dictionary<String,Any>> {
            delegate = DataBase.sharedInstance
            
            if let path = Bundle.main.url(forResource: "Addon", withExtension: "json") {
                do {
                    let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Array<Dictionary<String,Any>> {
                            return jsonResult
                        }
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
        return []
    }

    

}
