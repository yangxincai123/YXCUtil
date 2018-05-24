//
//  PopMenuTableController.swift
//  DYPopMenu
//
//  Created by 杨新财 on 2018/3/10.
//  Copyright © 2018年 杨新财. All rights reserved.
//

import UIKit

class PopMenuTableController: UITableViewController, UIAdaptivePresentationControllerDelegate {
    
    var datas:[[String:String]] = [[String:String]]() {
        didSet {
            self.preferredContentSize = CGSize.init(width: 170, height: datas.count * 44)
        }
    }
    var selectRow:Int?
    var completeHandle:((Int) -> ())?
    
    static func instantiate(sourceView:UIView) -> PopMenuTableController{
        
        let popMenu:PopMenuTableController = PopMenuTableController.init(style: .plain)
        popMenu.modalPresentationStyle = .popover
        popMenu.popoverPresentationController?.permittedArrowDirections = .up
        popMenu.popoverPresentationController?.backgroundColor = UIColor.white
        popMenu.popoverPresentationController?.sourceView = sourceView
        popMenu.popoverPresentationController?.sourceRect = sourceView.bounds
        
        return popMenu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = 44.0
        tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DYPopCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        if (selectRow != nil) {
            let selectIndexPath:IndexPath = IndexPath(row: selectRow!, section: 0)
            tableView.scrollToRow(at: selectIndexPath, at: .middle, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectRow = indexPath.row
        self.completeHandle!(self.selectRow!)
        self.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DYPopCell", for: indexPath)
        cell.selectionStyle = .none
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = UIImage.init(named: self.datas[indexPath.row].values.first!)
        cell.textLabel?.text = self.datas[indexPath.row].keys.first
        
        return cell
    }
}
