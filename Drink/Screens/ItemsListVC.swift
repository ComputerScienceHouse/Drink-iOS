//
//  ItemsListTableVC.swift
//  Drink
//
//  Created by Lonnie Gerol on 1/5/20.
//  Copyright © 2020 Lonnie Gerol. All rights reserved.
//

import UIKit
protocol ItemsListTVCDelegate{
    func userDidSelect(slot: Slot)
}



class ItemsListVC: UITableViewController {
    //TODO: Determine whether tuple is still necessary
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
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 25/255, blue: 126/255, alpha: 1.00)]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 176/255, green: 25/255, blue: 126/255, alpha: 1.00)]
        navigationController?.navigationBar.barTintColor = UIColor(red: 176/255, green: 25/255, blue: 126/255, alpha: 1.00)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = UIColor(red: 176/255, green: 25/255, blue: 126/255, alpha: 1.00)
        NetworkManager.shared.loadUser()
        refresh()
        createObserver()
        displayLoadingView()
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        view.backgroundColor = .systemBackground
        logoutButton = UIBarButtonItem(title: "? Credits", style: .plain, target: self, action: #selector(logOutButtonTapped))
        logoutButton.tintColor = .white
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
        displayLoadingView()
        //TODO: replace with gaurd statements
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
        machine.contents = nil
        tableView.reloadData()
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
        logoutButton.title = "? Credits"
        tableView.reloadData()
        displayLoadingView()
        self.present(AppAuthViewController(), animated: true, completion: nil)
        
    }
    @objc func logOutButtonTapped(){
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you would like to sign out?", preferredStyle: .actionSheet)
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
        cell.slot = machine.contents?.slots[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 40))
    }
    
}

extension ItemsListVC: ItemsListTVCDelegate{
    func userDidSelect(slot: Slot) {
        displayDropDrinkModal(slot: slot)
        print("item: \(slot.item.name) was selected in slot \(slot.number)")
        
    }
    
    func displayDropDrinkModal(slot: Slot){
        let alertController = UIAlertController(title: "Confirm Drop", message: "Are you sure you would like to drop \(slot.item.name) for \(slot.item.price) credits?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            let alertController = UIAlertController(title: "🥤 Dropping Drink...", message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            NetworkManager.shared.dropItem(in: slot.number, and: self.machine.identifier){
               (item, error) in
                DispatchQueue.main.async {
                    alertController.dismiss(animated: true, completion: nil)
                    self.refresh()

                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
