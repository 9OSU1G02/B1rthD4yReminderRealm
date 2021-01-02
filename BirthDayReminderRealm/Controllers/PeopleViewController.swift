//
//  PeopleViewController.swift
//  B1rthD4yReminder
//
//  Created by Nguyen Quoc Huy on 12/10/20.
//

import UIKit
import RealmSwift
class PeopleViewController: UIViewController {
    
    // MARK: - Properties
   
    let searchController    = UISearchController()
    private var textQuery   = ""
    var people: Results<Person>!
    private var peopleToken: NotificationToken?
    var sectionNames: [Int] {
        return Set(people.value(forKeyPath: #keyPath(Person.mob)) as! [Int]).sorted()
    }
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDataSouce()
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        peopleTableView.tableFooterView = UIView()
        configureSearchController()
    }
    
    
   
    // MARK: - IBOutlets
    @IBOutlet weak var peopleTableView: UITableView!
    
    func setupTableViewDataSouce() {
        people = RealmManager.shared.realm.objects(Person.self).sorted(byKeyPath: #keyPath(Person.name))
        peopleToken = people.observe { [weak self] change in
            switch change {
            default:
                self?.peopleTableView.reloadData()
            }
        }
    }
    
    func configureSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder                  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
    }
    
}

// MARK: - Extension

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count == 0 {
            tableView.setEmptyView(title: "You don't have any friend.", message: "Your friend list will be in here.", messageImage: #imageLiteral(resourceName: "6"))
        }
        else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.filter("mob == %@", sectionNames[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonTableViewCell
        cell.config(person: people.filter("mob == %@", sectionNames[indexPath.section])[indexPath.row] )
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let person = people.filter("mob == %@", sectionNames[section]).first
        guard person != nil else {
            return ""
        }
        return person!.monthName
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1)
        headerView.textLabel?.textColor = .red
        
        headerView.textLabel?.font = UIFont(name: "Avenir", size: 25.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    // MARK: - TableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person      = people.filter("mob == %@", sectionNames[indexPath.section])[indexPath.row]
        let personVC    = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "personVC") as! PersonViewController
        personVC.person = person
        navigationController?.pushViewController(personVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let person = people.filter("mob == %@", sectionNames[indexPath.section])[indexPath.row]
        switch editingStyle {
        case .delete:
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [person.id])
            try! RealmManager.shared.realm.write{
                RealmManager.shared.realm.delete(person)
            }
        default:
            break
        }
       
    }
}


extension PeopleViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != nil, !searchController.searchBar.text!.isEmpty else {
            people = RealmManager.shared.realm.objects(Person.self).sorted(byKeyPath: #keyPath(Person.name))
            peopleTableView.reloadData()
            return
        }
        textQuery            = searchController.searchBar.text!
        people = RealmManager.shared.realm.objects(Person.self).filter(NSPredicate(format: "name CONTAINS[cd] %@", textQuery))
        peopleTableView.reloadData()
    }
}


