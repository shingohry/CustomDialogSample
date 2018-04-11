//
//  ViewController.swift
//  CustomDialog
//
//  Created by hiraya.shingo on 2018/04/11.
//  Copyright © 2018 hiraya.shingo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dialogViewController = storyboard?.instantiateViewController(withIdentifier: "CustomDialogViewController")
        present(dialogViewController!, animated: true)
    }
}
