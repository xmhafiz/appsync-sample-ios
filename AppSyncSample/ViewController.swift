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
    
    func updateTitle(text: String) {
        self.title = text
    }
    
    func initView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchData() {
        updateTitle(text: "Loading..")
        let query = ListMyModelTypesQuery(filter: nil, limit: 10, nextToken: nil)
        appSyncClient?.fetch(query: query, cachePolicy: .returnCacheDataAndFetch)  { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            else {
                if let newTodos = result?.data?.listMyModelTypes?.items {
                    self.todos = newTodos
                    print(newTodos)
                    self.tableView.reloadData()
                    self.updateTitle(text: "")
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = todos[indexPath.row]
            guard let itemId = item?.id else {
                return
            }
            let deleteMutation = DeleteMyModelTypeMutation(input: DeleteMyModelTypeInput(id: itemId))
            updateTitle(text: "Loading..")
            appSyncClient?.perform(mutation: deleteMutation, queue: .main, optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, err) in
                if err == nil {
                    self.fetchData()
                }
            })
        }
    }
}
