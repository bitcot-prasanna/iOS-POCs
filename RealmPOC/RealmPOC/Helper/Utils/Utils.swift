//
//  Utils.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/22/24.
//

import UIKit

//MARK: - UIMenu
protocol MenuActionDelegate {
    func didSelectMenuItem(named name: String)
}

//create menus
func createMenu(itemNames: [String], delegate: MenuActionDelegate) -> UIMenu {
    var actions = [UIAction]()
    
    for name in itemNames {
        
        let uiAction = UIAction(title: name) { _ in
            delegate.didSelectMenuItem(named: name)
        }
        actions.append(uiAction)
    }
    
    return UIMenu(title: "", children: actions)
}
