//
//  RemoveHKMetricViewController.swift
//  BeeSwift
//
//  Created by Andy Brett on 4/9/18.
//  Copyright © 2018 APB. All rights reserved.
//

import UIKit

class RemoveHKMetricViewController: UIViewController {
    
    var goal : Goal?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.title = ""
        
        let currentMetricLabel = BSLabel()
        self.view.addSubview(currentMetricLabel)
        currentMetricLabel.text = "This goal gets its data from Apple Health (\(self.goal!.humanizedAutodata()!)). You can disconnect the goal with the button below."
        currentMetricLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.85)
        }
        currentMetricLabel.numberOfLines = 0
        currentMetricLabel.textAlignment = .center
        
        let removeButton = BSButton()
        self.view.addSubview(removeButton)
        removeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-20)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.5)
            make.height.equalTo(Constants.defaultTextFieldHeight)
        }
        removeButton.setTitle("Disconnect", for: .normal)
        removeButton.addTarget(self, action: #selector(self.removeButtonPressed), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func removeButtonPressed() {
        guard self.goal != nil else { return }
        self.goal?.autodata = ""
        NSManagedObjectContext.mr_default().mr_saveToPersistentStore { (success, error) in
            var params : [String : [String : String]] = [:]
            params = ["ii_params" : ["name" : "", "metric" : ""]]
            
            RequestManager.put(url: "api/v1/users/\(CurrentUserManager.sharedManager.username!)/goals/\(self.goal!.slug).json", parameters: params,
                               success: { (responseObject) -> Void in
                                // foo
            }) { (error) -> Void in
                // bar
            }
            
            DispatchQueue.main.async {
                DataSyncManager.sharedManager.fetchData(success: {
                    self.navigationController?.popViewController(animated: true)
                }, error: {
                    //
                })
            }
        }
    }
}
