//
//  SFRealm.swift
//  RealmDemo
//
//  Created by ccs on 2019/8/26.
//  Copyright © 2019年 ChenTong. All rights reserved.
//

import UIKit
import RealmSwift

class SFRealm: NSObject {
    private static let realmVersion: UInt64 = 0
    private static func realmConfig() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = realmVersion
        config.migrationBlock = {(migration: Migration, oldSchemaVersion: UInt64) in
            // 我们目前还未执行过迁移，因此 oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                // 没有什么要做的！
                // Realm 会自行检测新增和被移除的属性
                // 然后会自动更新磁盘上的架构
            }
        }
        return config
    }
    static func openRealm() {
        Realm.Configuration.defaultConfiguration = realmConfig()
        do {
           let _ = try Realm()
        }catch let error {
            print("打开数据库失败:\(error.localizedDescription)")
        }
    }
    /// 获取当前默认的数据
    ///
    /// - Returns: 返回默认的Realm的数据库实例
    static func getDefaultRealm() -> Realm? {
        do {
            return try Realm()
        }catch let error {
            print("获取默认的Realm的数据库失败:\n\(error.localizedDescription)")
            return nil
        }
    }
    /// 添加一个未管理的对象到realm数据库
    ///
    /// - Parameter model: unmanaged object
    static func addObject<T: Object>(_ model: T) {
        let realm = getDefaultRealm()
        do {
            try realm?.write {
                realm?.add(model, update: .all)
            }
        } catch let error {
            print("添加Object失败:\n\(error.localizedDescription)")
        }
    }
    
    ///  添加一组未管理的对象到realm数据库
    ///
    /// - Parameter model: unmanaged objects
    static func addObjects(_ models: [Object]) {
        let realm = getDefaultRealm()
        do {
            try realm?.write {
                realm?.add(models, update: .all)
            }
        } catch let error {
            print("添加Object失败:\n\(error.localizedDescription)")
        }
    }
    /// 异步插入一组对象到数据库
    ///
    /// - Parameters:
    ///   - type: Object.Type
    ///   - values: [[:]]
    static func createObjectsAsync(type: Object.Type,values: [Any]) {
        DispatchQueue(label: "realmCreateBackground").async {
            let realm = getDefaultRealm()
            realm?.beginWrite()
            for dict in values {
                realm?.create(type, value: dict, update: .all)
            }
            do {
                 try realm?.commitWrite()
            } catch let error {
                print("添加Objects失败:\n\(error.localizedDescription)")
            }
        }
    }
    // 查询
    static func queryObject(type: Object.Type, primaryKey: String) -> Object?{
        let realm = getDefaultRealm()
        let result = realm?.object(ofType: type, forPrimaryKey: primaryKey)
        return result
    }
    static func queryObjects<Element: Object>(_ type: Element.Type) -> Results<Element>?{
        
        let realm = getDefaultRealm()
        return realm?.objects(type)
    }
    /// delete an object to this Realm
    ///
    /// - Parameter model: object
    static func deleteObject(_ model: Object) {
        let realm = getDefaultRealm()
        do {
            try realm?.write {
                realm?.delete(model)
            }
        } catch let error {
            print("添加Object失败:\n\(error.localizedDescription)")
        }
    }
    /// delete an object to this Realm
    ///
    /// - Parameter model: object
    static func deleteObjects(_ models: [Object]) {
        let realm = getDefaultRealm()
        do {
            try realm?.write {
                realm?.delete(models)
            }
        } catch let error {
            print("添加Object失败:\n\(error.localizedDescription)")
        }
    }
    
    static func deleteAll() {
        let realm = getDefaultRealm()
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch let error {
            print("删除Object失败:\n\(error.localizedDescription)")
        }
    }
    
    static func write(closure: (_ realmObject: Realm)->()) {
        guard let realm = getDefaultRealm() else {
            return
        }
        do {
            try realm.write {
                closure(realm)
            }
        } catch let error {
            print("执行write失败:\n\(error.localizedDescription)")
        }
    }
}
