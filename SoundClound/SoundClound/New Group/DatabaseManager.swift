//
//  DatabaseManager.swift
//  SoundClound
//
//  Created by Hai on 7/5/18.
//  Copyright © 2018 Hai. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class DatabaseManager {
    
    private struct Constant {
        static let KDatabaseName = "Tracks"
    }
    
    private class func getManagerContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    class func insertTrack(track: TrackInfo) -> Bool {
        guard let trackModel = track.trackModel else { return false }
        if checkData(track: trackModel) == nil {
            do {
                guard let managedContext = getManagerContext() else { return Bool() }
                guard let trackEntity = NSEntityDescription.entity(forEntityName: Constant.KDatabaseName, in: managedContext) else { return false }
                let trackObject = NSManagedObject(entity: trackEntity, insertInto: getManagerContext())
                trackObject.setValue(track.trackModel?.title, forKey: "title")
                trackObject.setValue(track.trackModel?.description, forKey: "des")
                trackObject.setValue(track.trackModel?.image, forKey: "image")
                trackObject.setValue(track.trackModel?.duration, forKey: "duration")
                trackObject.setValue(track.trackModel?.id, forKey: "id")
                trackObject.setValue(track.trackModel?.url, forKey: "url")
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    class func getTracks() -> [TrackInfo] {
        let managedContext = getManagerContext()
        var tmpTrackList = [TrackInfo]()
        let request = NSFetchRequest<NSManagedObject>(entityName: Constant.KDatabaseName)
        var tmpFetch = [NSManagedObject]()
        if let tmpManagedContext = managedContext {
            do {
                tmpFetch = try tmpManagedContext.fetch(request)
                for index in tmpFetch {
                    let tmpTitle = index.value(forKey: "title") as? String ?? ""
                    let tmpDescription = index.value(forKey: "des") as? String ?? ""
                    let tmpImage = index.value(forKey: "image") as? String ?? ""
                    let tmpDuration = index.value(forKey: "duration") as? Int ?? 0
                    let tmpId = index.value(forKey: "id") as? Int ?? 0
                    let tmpUrl = index.value(forKey: "url") as? String ?? ""
                    
                    let tmpTrackData = TrackModel(title: tmpTitle,
                                                  description: tmpDescription,
                                                  image: tmpImage,
                                                  duration: tmpDuration,
                                                  id: tmpId,
                                                  url: tmpUrl)
                    let tmpTrack = TrackInfo(track: tmpTrackData)
                    tmpTrackList.append(tmpTrack)
                }
            } catch {
                print("Something went wrong!")
            }
        }
        return tmpTrackList
    }
    
    class func cleanAllCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.KDatabaseName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        if let managedContext = getManagerContext() {
            do {
                try managedContext.execute(deleteRequest)
            } catch {
                print("Something went wrong!")
            }
        }
    }
    
    class func deleteTrack(track: TrackModel) -> Bool {
        if let tmpData = checkData(track: track),
            let managedContext = getManagerContext() {
            do {
                managedContext.delete(tmpData)
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    class func checkData(track: TrackModel) -> NSManagedObject? {
        let managedContext = getManagerContext()
        if let tmpManagedContext = managedContext {
            let request = NSFetchRequest<NSManagedObject>(entityName: Constant.KDatabaseName)
            var tmpFetch = [NSManagedObject]()
            do {
                tmpFetch = try tmpManagedContext.fetch(request)
                for index in tmpFetch {
                    let tmpTitle = index.value(forKey: "title") as? String ?? ""
                    if tmpTitle == track.title {
                        return index
                    }
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
