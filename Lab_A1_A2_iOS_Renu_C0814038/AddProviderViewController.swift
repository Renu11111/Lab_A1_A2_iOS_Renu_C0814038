//
//  AddProviderViewController.swift
//  Lab_A1_A2_iOS_Renu_C0814038
//
//  Created by Mac on 2021-09-17.
//

import UIKit
import CoreData

class AddProviderViewController: UIViewController {
    let context =
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var textProvider: UITextField!
    var selectedProvider : Provider?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pro = selectedProvider{
            textProvider.text = pro.provider
        }

    }
    
    @IBAction func save(_ sender: Any) {
        if let pro = selectedProvider{
            pro.provider = textProvider.text
        }
        else{
            let req : NSFetchRequest<Provider> = Provider.fetchRequest()
            req.predicate = NSPredicate(format: "provider = '\(textProvider.text!)'")
            let storeProvider = try! context.fetch(req)
            if storeProvider.count == 0{
                let provider = Provider(context: context)
                provider.provider = textProvider.text
                
                textProvider.text = nil
            }
        }
        
        try! context.save()
    }
   
}
