//
//  ConfigureNotificationsViewController.swift
//  BeeSwift
//
//  Created by Andy Brett on 12/20/17.
//  Copyright © 2017 APB. All rights reserved.
//

import UIKit

class ConfigureNotificationsViewController: UIViewController {
    
    fileprivate var goals : [Goal] = []
    fileprivate var cellReuseIdentifier = "configureNotificationsTableViewCell"
    fileprivate var tableView = UITableView()
    fileprivate var emergencyRemindersSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        self.view.backgroundColor = .white
    
        let emergencyRemindersLabel = BSLabel()
        self.view.addSubview(emergencyRemindersLabel)
        emergencyRemindersLabel.text = "Goal emergency notifications"
        emergencyRemindersLabel.snp.makeConstraints { (make) -> Void in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(10)
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.leftMargin).offset(15)
            } else {
                make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10)
                make.left.equalTo(self.view).offset(15)
            }
        }
        
        self.view.addSubview(self.emergencyRemindersSwitch)
        self.emergencyRemindersSwitch.addTarget(self, action: #selector(self.emergencyRemindersSwitchChanged), for: .valueChanged)
        self.emergencyRemindersSwitch.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(emergencyRemindersLabel)
            if #available(iOS 11.0, *) {
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.rightMargin).offset(-15)
            } else {
                make.right.equalTo(-15)
            }
        }
        self.emergencyRemindersSwitch.isOn = RemoteNotificationsManager.sharedManager.on()
    
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(emergencyRemindersLabel.snp.bottom).offset(10)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
            } else {
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            }
        }
        self.tableView.isHidden = !RemoteNotificationsManager.sharedManager.on()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        self.loadGoalsFromDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadGoalsFromDatabase() {
        self.goals = Goal.mr_findAllSorted(by: "slug", ascending: true, with: NSPredicate(format: "serverDeleted = false")) as! [Goal]
    }
    
    @objc func emergencyRemindersSwitchChanged() {
        self.tableView.isHidden = !self.emergencyRemindersSwitch.isOn
        if self.emergencyRemindersSwitch.isOn {
            RemoteNotificationsManager.sharedManager.turnNotificationsOn()
        }
        else {
            RemoteNotificationsManager.sharedManager.turnNotificationsOff()
        }
    }
}

extension ConfigureNotificationsViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 { return self.goals.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! SettingsTableViewCell!
        if (indexPath as NSIndexPath).section == 0 {
            cell?.title = "Default notification settings"
            return cell!
        }
        let goal = self.goals[(indexPath as NSIndexPath).row]
        cell?.title = goal.slug
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 {
            self.navigationController?.pushViewController(EditDefaultNotificationsViewController(), animated: true)
        } else {
            let goal = self.goals[(indexPath as NSIndexPath).row]
            self.navigationController?.pushViewController(EditGoalNotificationsViewController(goal: goal), animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
