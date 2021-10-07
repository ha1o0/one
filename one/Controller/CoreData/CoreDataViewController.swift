//
//  CoreDataViewController.swift
//  one
//
//  Created by sidney on 2021/10/6.
//

import UIKit

class CoreDataViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    lazy var btn: UIButton = {
        var _startBtn = UIButton()
        _startBtn.setTitle("插入", for: .normal)
        _startBtn.setTitleColor(.main, for: .normal)
        return _startBtn
    }()
    
    lazy var btn2: UIButton = {
        var _startBtn = UIButton()
        _startBtn.setTitle("查询", for: .normal)
        _startBtn.setTitleColor(.main, for: .normal)
        return _startBtn
    }()
    
    lazy var tableView: UITableView = {
        var _tableView = UITableView()
        _tableView.separatorStyle = .none
        return _tableView
    }()
    
    var schoolClasses: [SchoolClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CoreData"
        setCustomNav()
        registerNibWithName("CoreDataSchoolClassTableViewCell", tableView: self.tableView)
        setup()
    }

    func setup() {
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom).offset(40)
        }
        btn.addTarget(self, action: #selector(insert), for: .touchUpInside)
        
        self.view.addSubview(btn2)
        btn2.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom).offset(80)
        }
        btn2.addTarget(self, action: #selector(query), for: .touchUpInside)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.navigationView.snp.bottom).offset(120)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(500)
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.query()
    }
    
    @objc func insert() {
        guard let coreDataContext = CoreDataService.shared.getContext(modelFileName: "Class", sqliteFileName: "SchoolSQL") else {
            return
        }
        let schoolClass = SchoolClassCoreData.shared.insertData(context: coreDataContext)
        let student = StudentCoreData.shared.insertData(context: coreDataContext)
        schoolClass.monitor = student
        let result: ()? = try? coreDataContext.save()
        print(result ?? "...")
        self.query()
    }
    
    @objc func query() {
        guard let coreDataContext = CoreDataService.shared.getContext(modelFileName: "Class", sqliteFileName: "SchoolSQL") else {
            return
        }
        let result = SchoolClassCoreData.shared.query(context: coreDataContext, condition: "studentCount > 0")
        if (result.finalResult?.count ?? 0) > 0 {
            self.schoolClasses = result.finalResult!
            self.tableView.reloadData()
        }
        
    }

}

extension CoreDataViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolClasses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "CoreDataSchoolClassTableViewCell", tableView: self.tableView) as! CoreDataSchoolClassTableViewCell
        cell.setCell(schoolClass: self.schoolClasses[indexPath.row])
        return cell
    }
}
