//
//  ViewController.swift
//  MiniApp26-CoreDate02
//
//  Created by 前田航汰 on 2022/03/08.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!

    @IBAction func didTapCreateButton(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Store", in: managedContext) else { return }
        let storeObject = NSManagedObject(entity: entity, insertInto: managedContext)

        storeObject.setValue(itemTextField.text, forKey: "item")
        storeObject.setValue(Int(priceTextField.text ?? "0"), forKey: "price")

        do {
            try managedContext.save()
            print("保存しました")
        } catch let error as NSError {
            print("保存時にエラー： \(error), \(error.userInfo)")
        }
    }

    @IBAction func didTapConfirmButton(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        do {
            let fetchRequests = try managedContext.fetch(fetchRequest)
            if let results = fetchRequests as? [NSManagedObject] {
                for result in results {
                    if let item = result.value(forKey: "item") as? String, let price = result.value(forKey: "price") as? Int {
                        print("item：\(item), price：\(price)")
                    }
                }
                print("---------------")
            }
        } catch let error as NSError {
            print("確認時にエラー:\(error), \(error.userInfo)")
        }
    }

    @IBAction func didTapUpdataButton(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        do {
            let fetchRequests = try managedContext.fetch(fetchRequest)
            if let results = fetchRequests as? [NSManagedObject] {
                for result in results {
                    if let item = result.value(forKey: "item") as? String, let price = result.value(forKey: "price") as? Int {
                        result.setValue(item + "【値上げした】", forKey: "item")
                        result.setValue(NSNumber(value: Float(price)*1.05), forKey: "price")
                    }
                }
            }
        } catch let error as NSError {
            print("上書き時にエラー:\(error), \(error.userInfo)")
        }
    }

    @IBAction func didTapDeleteButton(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")

        do {
            let fetchRequests = try managedContext.fetch(fetchRequest)
            if let results = fetchRequests as? [NSManagedObject] {
                for result in results {
                    managedContext.delete(result)
                }
            }
        } catch let error as NSError {
            print("削除時にエラー:\(error), \(error.userInfo)")
        }
    }

}

