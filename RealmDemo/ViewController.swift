//
//  ViewController.swift
//  RealmDemo
//
//  Created by ccs on 2019/8/26.
//  Copyright © 2019年 ChenTong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var datas: [TodoModel] = {
        return [TodoModel]()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        SFRealm.deleteAll()
//        setupNavigation()
        // Do any additional setup after loading the view, typically from a nib.
//        loadCache()
        a()
    }
    func a() {
        let model = TodoModel.init()
        model.title = "111"
        SFRealm.addObject(model)
        
        SFRealm.write { (realm) in
            model.title = "222"
        }
        SFRealm.addObjects([TodoModel(),TodoModel(),TodoModel(),TodoModel(),TodoModel()])
        
        SFRealm.createObjectsAsync(type: TodoModel.self, values: [["title":"19990"],["title":"219990"],["title":"319990"],["title":"419990"]])
        let result = SFRealm.queryObjects(TodoModel.self)
        print("result:",result)
    }
    func setupNavigation() {
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(didClickAddItem), for: .touchUpInside)
        button.setTitle("添加", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.orange, for: .normal)
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem.init(customView: button)
    }
    func loadCache() {
        if let result = SFRealm.queryObjects(TodoModel.self) {
            for item in result {
                self.datas.append(item)
            }
        }
        self.tableView.reloadData()
    }
    @objc func didClickAddItem() {
        let id = UUID().uuidString
        let name = "小王" + id
        let model = TodoModel.init(value: ["title": name,"id": id,])
        updateDatas(model: model)
        
        SFRealm.addObject(model)

    }
    func updateDatas(model: TodoModel) {
        self.datas.append(model)
        self.tableView.reloadData()
    }
    func deleteModel(model: TodoModel) {
        if let index = self.datas.firstIndex(of: model),self.datas.contains(model) {
            self.datas.remove(at: index)
            self.tableView.reloadData()
        }
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.datas.count
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = self.datas[indexPath.row].title
        return cell!
    }
}
