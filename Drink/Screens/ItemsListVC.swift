//
//  ItemsListTableVC.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit

class ItemsListVC: UITableViewController {
    var noDataLabel = UILabel()
    var machine: (contents: Machine?, identifier: ExistingMachines)!
    
    init(machineIdentifer: ExistingMachines){
        super.init(style: .plain)
        self.machine = (nil, machineIdentifer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        noDataLabel.text = "No Data"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default-cell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NetworkManager.shared.authState != nil{
            NetworkManager.shared.getInfo(for: self.machine.identifier){
                machine, error in
                self.machine.contents = machine
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        
    
    }
    
    //MARK: TableViewDataSoure + TableViewDelegate Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return machine.contents?.slots.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default-cell")!
        cell.textLabel!.text = self.machine.contents?.slots[indexPath.row].item.name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
}
