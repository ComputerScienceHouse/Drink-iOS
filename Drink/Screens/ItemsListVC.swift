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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        refresh()
        createObserver()
        UITableView.appearance().separatorColor = .separator
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ProfilePictureButton(imageUrl: "https://profiles.csh.rit.edu/image/lontronix"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "100 Credits", style: .plain, target: nil, action: nil)
       

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func refresh(){
        print("refresh called")
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
    
    @objc func profileButtonTapped(){
        
    }
    
    private func createObserver(){
        let name = Notification.Name(rawValue: loginDismissedKey)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: name, object: nil)
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
        cell.textLabel!.text = "\(self.machine.contents!.slots[indexPath.row].item.name) (\(self.machine.contents!.slots[indexPath.row].item.price) credits)"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
}
