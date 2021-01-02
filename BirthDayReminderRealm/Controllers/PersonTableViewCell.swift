//
//  PersonTableViewCell.swift
//  B1rthD4yReminder
//
//  Created by Nguyen Quoc Huy on 12/11/20.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var isTodayBirthdayLabel: UILabel!
    
    func config(person: Person) {
        
        nameLabel.text                  = person.name
        
        if let data                     = person.avatar {
            avatarImageView.image       = UIImage(data: data)
        }
        else {
            avatarImageView.image       = UIImage(systemName: "avatar")
        }
        
        dobLabel.text = person.birthday.convertToDayMonthYearFormat()
        
        isTodayBirthdayLabel.isHidden   = !isTodayBirthDay(dob: person.dob, mob: person.mob)
    }
}
