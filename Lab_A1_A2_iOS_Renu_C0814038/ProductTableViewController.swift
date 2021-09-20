//
//  ProductTableViewController.swift
//  Lab_A1_A2_iOS_Renu_C0814038
//
//  Created by Mac on 2021-09-17.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segment: UISegmentedControl!
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products : [Product] = []
    var provider : [Provider] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getProducts()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        change(self)
    }
    func getProducts(){
        products = []
        products = try! context.fetch(Product.fetchRequest())
        insertProucts()
        tableView.reloadData()
    }
    func insertProucts(){
        if products.count == 0{
            let provider1 = Provider(context: context)
            provider1.provider = "Nyyka"
            
            let p11 = Product(context: context)
            p11.productDesc = "Lipstick"
            p11.productID = "001"
            p11.productName = "salt"
            p11.productPrice = "100"
            p11.provider = provider1
            
            let p12 = Product(context: context)
            p12.productDesc = "skyyy"
            p12.productID = "002"
            p12.productName = "sky"
            p12.productPrice = "300"
            p12.provider = provider1
            
            let p13 = Product(context: context)
            p13.productDesc = "p1dis"
            p13.productID = "003"
            p13.productName = "bulb"
            p13.productPrice = "400"
            p13.provider = provider1
            
            let provider2 = Provider(context: context)
            provider2.provider = "Suzuki"
            
            let p21 = Product(context: context)
            p21.productDesc = "p1dis"
            p21.productID = "001"
            p21.productName = "bike"
            p21.productPrice = "100"
            p21.provider = provider2
            
            let p22 = Product(context: context)
            p22.productDesc = "p1dis"
            p22.productID = "002"
            p22.productName = "car"
            p22.productPrice = "300"
            p22.provider = provider2
            
            let p23 = Product(context: context)
            p23.productDesc = "p1dis"
            p23.productID = "003"
            p23.productName = "plan"
            p23.productPrice = "400"
            p23.provider = provider2
            try! context.save()
            getProducts()
        }
    }
    //Final exam
    @IBAction func change(_ sender: Any) {
        if segment.selectedSegmentIndex == 0{
            getProducts()
            searchBar.isHidden = false
        }
        else{
            getProvider()
            searchBar.isHidden = true
        }
    }
    @IBAction func add(_ sender: Any) {
        if segment.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: self)
        }
        else{
            performSegue(withIdentifier: "addProvider", sender: self)
        }
    }
    func getProvider(){
        provider = []
        provider = try! context.fetch(Provider.fetchRequest())
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? String{
            if segment.selectedSegmentIndex == 0{
                let vc = segue.destination as! AddProductTableViewController
                vc.selectedProduct = products[tableView.indexPathForSelectedRow!.row]
            }
            else{
                let vc = segue.destination as! GetProductsTableViewController
                vc.selectedProvider = provider[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if segment.selectedSegmentIndex == 0{
            return products.count
        }
        else{
            return provider.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if segment.selectedSegmentIndex == 0{
            cell.textLabel?.text =
                products[indexPath.row].productName
            cell.detailTextLabel?.text = products[indexPath.row].provider?.provider
        }
        else{
            cell.textLabel?.text =
                provider[indexPath.row].provider
            let req : NSFetchRequest<Product> = Product.fetchRequest()
            //req.predicate =  NSPredicate(format: "provider = '\(provider[indexPath.row].provider!)'")
            let productz = try! context.fetch(req)
            var count = 0
            for pro in productz{
                if pro.provider?.provider == provider[indexPath.row].provider{
                    count = count + 1
                }
            }
            cell.detailTextLabel?.text = count.description
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment.selectedSegmentIndex == 0{
            performSegue(withIdentifier: "addProduct", sender: "me")
        }
        else{
            performSegue(withIdentifier: "getProduct", sender: "me")
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if segment.selectedSegmentIndex == 0{
                let pro = products[indexPath.row]
                context.delete(pro)
            }
            else{
                for prod in products{
                    if prod.provider == provider[indexPath.row]{
                        context.delete(prod)
                    }
                }
                let pro = provider[indexPath.row]
                context.delete(pro)
                
            }
            try! context.save()
            change(self)
            
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "productName contains[c] '\(searchText)' || productDesc contains[c] '\(searchText)'")
            let fetchRequest : NSFetchRequest<Product> = Product.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                products = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        else{
            getProducts()
            
        }
        tableView.reloadData()
    }
}
