//
//  ViewController.swift
//  AppSyncSample
//
//  Created by Hafiz on 29/07/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit
import AWSAppSync

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var todos = [ListMyModelTypesQuery.Data.ListMyModelType.Item?]()
    var appSyncClient: AWSAppSyncClient?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        
        initView()
        fetchData()
    }
    
    func initView() {
        tableView.dataSource = self
    }
    
    func fetchData() {
        let query = ListMyModelTypesQuery(filter: nil, limit: 10, nextToken: nil)
        appSyncClient?.fetch(query: query)  { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            else {
                if let newTodos = result?.data?.listMyModelTypes?.items {
                    self.todos = newTodos
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = todos[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "CommonCell")
        cell.textLabel?.text = item?.title
        cell.detailTextLabel?.text = item?.id
        return cell
    }
    
    
}
