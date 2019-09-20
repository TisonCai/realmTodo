//
//  TodoModel.swift
//  RealmDemo
//
//  Created by ccs on 2019/8/27.
//  Copyright © 2019年 ChenTong. All rights reserved.
//

import UIKit
import RealmSwift

class TodoModel: Object {
    @objc var id: String = UUID().uuidString
    @objc dynamic var title = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    override class func indexedProperties() -> [String] {
        return ["title"]
    }
}
