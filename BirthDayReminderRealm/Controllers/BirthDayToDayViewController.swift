//
//  BirthDayToDayViewController.swift
//  B1rthD4yReminder
//
//  Created by Nguyen Quoc Huy on 12/12/20.
//

import UIKit
import RealmSwift
class BirthDayToDayViewController: UIViewController {
    
    
    var people: Results<Person>!
    var peopleToken: NotificationToken!
    @IBOutlet weak var birthDayTodayTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDataSource()
        birthDayTodayTableView.delegate = self
        birthDayTodayTableView.dataSource = self
        birthDayTodayTableView.tableFooterView = UIView()
    }
    
    func setupTableViewDataSource() {
        people = RealmManager.shared.realm.objects(Person.self).filter(NSPredicate(format: "mob == %d", Date().currentMonthIntValue()))
        peopleToken = people.observe { [weak self] change in
            self?.birthDayTodayTableView.reloadData()
        }
    }
    
    @IBSegueAction func showActionView(_ coder: NSCoder) -> ActionViewController? {
        guard let indexPath = birthDayTodayTableView.indexPathForSelectedRow else {
            fatalError()
        }
        return ActionViewController(coder: coder, person: people[indexPath.row])
    }
}

extension BirthDayToDayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if people.count == 0 {
            tableView.setEmptyView(title: "No one is birthday today.", message: "Your friend birthday will be in here.", messageImage: #imageLiteral(resourceName: "9"))
        }
        else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BirthDayToDayTableViewCell
        cell.config(person: people[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

