//
//  PersonCell.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/21/24.
//

import UIKit

protocol PersonCellDelegate {
    func personCell(_ cell: PersonCell, didTapOnMenu: String)
}

class PersonCell: UITableViewCell {
    
    //outlets
    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    
    //identifier and other varibables
    static let identifier = String(describing: PersonCell.self)
    var delegate: PersonCellDelegate?
    var menu: UIMenu?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menu = createMenu(
            itemNames: [
                MenuOptionConstant.petInfo,
                MenuOptionConstant.edit,
                MenuOptionConstant.delete
            ],
            delegate: self
        )
        btnMenu.menu = menu
        btnMenu.showsMenuAsPrimaryAction = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//MARK: - Menu delegate method
extension PersonCell: MenuActionDelegate{
    
    func didSelectMenuItem(named name: String) {
        delegate?.personCell(self, didTapOnMenu: name)
    }
}
