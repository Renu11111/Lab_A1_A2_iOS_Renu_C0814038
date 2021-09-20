//
//  AddProductTableViewController.swift
//  Lab_A1_A2_iOS_Renu_C0814038
//
//  Created by Mac on 2021-09-17.
//

import UIKit
import CoreData
class AddProductTableViewController: UITableViewController {
    let context =
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDesc: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var txtProviderName: UITextField!
    var selectedProduct : Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pro = selectedProduct{
            id.text = pro.productID
            productName.text = pro.productName
            productDesc.text = pro.productDesc
            price.text = pro.productPrice
            txtProviderName.text = pro.productName
        }

    }

    @IBAction func save(_ sender: Any) {
        let req : NSFetchRequest<Provider> = Provider.fetchRequest()
        req.predicate = NSPredicate(format: "provider = '\(txtProviderName.text!)'")
        let storeProvider = try! context.fetch(req)
        var provider : Provider!
        if storeProvider.count == 0{
             provider = Provider(context: context)
             provider.provider = txtProviderName.text
        }
        else{
             provider = storeProvider[0]
        }
        if let pro = selectedProduct{
            pro.productDesc = productDesc.text
            pro.productID = id.text
            pro.productName = productName.text
            pro.productPrice = price.text
            pro.provider = provider
        }
        else{
            let product = Product(context: context)
            product.productDesc = productDesc.text
            product.productID = id.text
            product.productName = productName.text
            product.productPrice = price.text
            product.provider = provider
        }
        try! context.save()
        id.text = nil
        productDesc.text = nil
        productName.text = nil
        price.text = nil
        txtProviderName.text = nil
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


}
