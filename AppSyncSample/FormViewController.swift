//
//  FormViewController.swift
//  AppSyncSample
//
//  Created by Hafiz on 02/08/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit
import AWSAppSync
import Toast_Swift

class FormViewController: UIViewController {
    var appSyncClient: AWSAppSyncClient?
    
    var item: ListMyModelTypesQuery.Data.ListMyModelType.Item? = nil
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        
        if let todo = item {
            textView.text = todo.title
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @IBAction func handleSaveAction(_ sender: UIBarButtonItem) {
        guard let text = textView.text else {
            return
        }
        
        textView.resignFirstResponder()
        
        if item == nil {
            createItem(text: text)
        }
        else {
            updateItem(text: text)
        }
    }
    
    func createItem(text: String) {
        let createMutation = CreateMyModelTypeMutation(input: CreateMyModelTypeInput(title: text, field2: nil))
        appSyncClient?.perform(mutation: createMutation, queue: .main, optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, err) in
            if err == nil {
                // show success message
                self.view.makeToast("New data successfully added")
                self.textView.text = ""
            }
        })
    }
    
    func updateItem(text: String) {
        guard let todo = item else { return }
        let updateMutation = UpdateMyModelTypeMutation(input: UpdateMyModelTypeInput(id: todo.id, title: todo.title, field2: todo.field2))
        appSyncClient?.perform(mutation: updateMutation, queue: .main, optimisticUpdate: nil, conflictResolutionBlock: nil, resultHandler: { (result, err) in
            if err == nil {
                // show success message
                self.view.makeToast("Data successfully updated")
            }
        })
    }
}
