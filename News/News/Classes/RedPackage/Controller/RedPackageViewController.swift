//
//  RedPackageViewController.swift
//  News
//
//  Created by 杨蒙 on 2018/2/5.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit

class RedPackageViewController: UITableViewController {

    /// 新年活动
    var newYearActivities = [NewYearActivity]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.keyWindow?.theme_backgroundColor = "colors.tableViewBackgroundColor"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.keyWindow?.theme_backgroundColor = "colors.windowColor"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置 UI
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RedPackageViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newYearActivities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as NewYearActivityCell
        cell.newYearActivity = newYearActivities[indexPath.row]
        return cell
    }
}

extension RedPackageViewController {
    /// 设置 UI
    private func setupUI() {
        // pilst 文件的路径
        let path = Bundle.main.path(forResource: "activity", ofType: "plist")
        // plist 文件中的数据
        let activities = NSArray(contentsOfFile: path!) as! [Any]
        newYearActivities = activities.flatMap({
            NewYearActivity.deserialize(from: $0 as? [String: Any])
        })
        tableView.ym_registerCell(cell: NewYearActivityCell.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 180
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(r: 254, g: 230, b: 207)
        // 判断是否是夜间
        MyThemeStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: NSNotification.Name(rawValue: "dayOrNightButtonClicked"), object: nil)
    }
    /// 接收到了按钮点击的通知
    @objc func receiveDayOrNightButtonClicked(notification: Notification) {
        // 判断是否是夜间
        MyThemeStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
    }
}
