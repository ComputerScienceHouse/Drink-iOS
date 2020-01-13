//
//  ItemsListTableVC.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit

class ItemsListVC: UITableViewController {
    var machine: (contents: Machine?, identifier: ExistingMachines)!
    var logoutButton: UIBarButtonItem!
    
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
        tableView.isScrollEnabled = false
        tableView.register(ItemTVC.self, forCellReuseIdentifier: "ItemTVC")
        NetworkManager.shared.loadUser()
        refresh()
        createObserver()
        displayLoadingView()
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        view.backgroundColor = .systemBackground
        logoutButton = UIBarButtonItem(title: "? Credits", style: .plain, target: self, action: #selector(logOutButtonTapped))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if NetworkManager.shared.authState == nil{
            let containerVC = AppAuthViewController()
            containerVC.isModalInPresentation = true
            self.present(containerVC, animated: true, completion: nil)
        }
    }
    
    @objc func refresh(){
        
        if NetworkManager.shared.authState != nil{
            if NetworkManager.shared.user != nil{
                NetworkManager.shared.getDrinkCreditsForUser { (numCredits) in
                    DispatchQueue.main.async {
                        NetworkManager.shared.getInfo(for: self.machine.identifier){
                                      machine, error in
                                      self.machine.contents = machine
                                      DispatchQueue.main.async {
                                          self.tableView.reloadData()
                                          self.tableView.backgroundView = nil
                                          self.tableView.isScrollEnabled = true
                                          self.logoutButton.title = "\(numCredits) Credits"

                                      }
                                  }
                    }
                }
            }
            
          
            
        }
    }
    
    func displayLoadingView(){
        let holderView = UIView()
        tableView.backgroundView = holderView
        let loadingView = LoadingView(frame: .zero)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        holderView.addSubview(loadingView)
        holderView.addConstraints([
            loadingView.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: holderView.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 350),
            loadingView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func reset(){
        machine.contents = nil
        tableView.reloadData()
        displayLoadingView()
        self.present(AppAuthViewController(), animated: true, completion: nil)
        
    }
    @objc func logOutButtonTapped(){
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you would like to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {
            alert in
            NetworkManager.shared.signOut()
            self.reset()
            
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTVC")! as! ItemTVC
        cell.item = machine.contents?.slots[indexPath.row].item
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}
