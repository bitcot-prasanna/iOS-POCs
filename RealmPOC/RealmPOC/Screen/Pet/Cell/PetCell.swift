//
//  PetCell.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/22/24.
//

import UIKit

class PetCell: UITableViewCell {
    
    @IBOutlet weak var lblPetName: UILabel!
    @IBOutlet weak var lblBreed: UILabel!
    
    //identifier
    static let identifier =  String(String(describing: PetCell.self))
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
