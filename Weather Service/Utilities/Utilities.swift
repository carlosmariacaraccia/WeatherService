//
//  Utilities.swift
//  Weather Service
//
//  Created by Carlos Caraccia on 4/6/21.
//

import Foundation
import CoreData


class Utilities {
    
    /// Batch insert function used only once to map the file cit.list.json dowloaded from open weather to core data. The corrdinates where not mapped into the database because we don't consider it necessary.
    /// - Parameter container: the nspersistent container
    static func batchInsertIntContext(container:NSPersistentContainer) {
        
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let url = Bundle.main.url(forResource: "city.list", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else { return }
        guard let json = try? JSONDecoder().decode([ImportingCityModel].self, from: data) else { return }
        guard let data2 = try? JSONEncoder().encode(json) else { return }
        guard let objects = try? JSONSerialization.jsonObject(with: data2, options: .mutableLeaves) as? [[String:AnyObject]] else { return }
        backgroundContext.performAndWait {
            let batchInsert = NSBatchInsertRequest(entity: City.entity(), objects: objects)
            batchInsert.resultType = .objectIDs
            let result = try? backgroundContext.execute(batchInsert) as? NSBatchInsertResult
            if let objIds = result?.result as? [NSManagedObjectID], !objIds.isEmpty {
                let save = [NSInsertedObjectsKey: objIds]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: [container.viewContext])
            }
        }
    }

}
