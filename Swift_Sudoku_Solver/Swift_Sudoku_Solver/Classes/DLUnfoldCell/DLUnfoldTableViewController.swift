//
//  DLUnfoldTableViewController.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 24/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

private let cellID = "cellId"
private let headViewID = "headViewID"

class DLUnfoldTableViewController: UIViewController {
    
    fileprivate lazy var tableView:UITableView = { 
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tableView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    fileprivate lazy var groupModels: [DLUnfoldGroupModel] = {
        var models = [DLUnfoldGroupModel]()
        var fileName = "DLHelpListEN.plist"
        if Locale.current.languageCode == "zh"{
            fileName = "DLHelpListCN.plist"
        }
        
        let plistPath = Bundle.main.path(forResource: fileName, ofType: nil)!
        
//        let plistURL = URL(string: plistPath)!
        let plistURL = URL(fileURLWithPath: plistPath)
//        let plistURL = URL(fileReferenceLiteralResourceName: fileName)
        
        let data = try! Data(contentsOf:plistURL)
        
        if let struct_models: [DLUnfoldGroupModel] = try! PropertyListDecoder().decode([DLUnfoldGroupModel].self, from: data) {
            models = struct_models
        }
        
        return models;
    }()
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        let backImageView = UIImageView(image: UIImage(named: "iphonetall-background-x13"))
        view.addSubview(backImageView)

        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        let selftableView = tableView
//        print(tableView.style)

    }
    
    fileprivate func setupUI(){
        navigationItem.titleView = UILabel.titleLabel()
        
        tableView.backgroundColor = UIColor.clear
        
        tableView.register(DLUnfoldTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.register(DLUnfoldTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headViewID)

        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension DLUnfoldTableViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headViewID) as! DLUnfoldTableViewHeaderFooterView
        headView.model = groupModels[section]
        headView.block = {
            self.tableView.reloadSections([section], with: .none)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: - Table view data source

extension DLUnfoldTableViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return groupModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if groupModels[section].isSelected {
            return groupModels[section].steps?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DLUnfoldTableViewCell
        cell.textLabel?.text = groupModels[indexPath.section].steps?[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    

}
