//
//  PersonViewController.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/21/24.
//

import UIKit
import RealmSwift

class PersonViewController: UIViewController {
    
    //outlet
    @IBOutlet weak var tableView: UITableView!
    
    //variables and constants
    let viewModel = PersonViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //actions
    @IBAction func didTapOnAddPerson(_ sender: UIButton) {
        showAlertWithFields()
    }
    
    
    //user functions
    func setup(){
        self.setuptable()
        self.observerPersonObject()
        self.viewModel.getPersons()
    }
    
    //setup table
    func setuptable() {
        self.tableView.register(
            UINib(
                nibName: PersonCell.identifier,
                bundle: .main
            ),
            forCellReuseIdentifier: PersonCell.identifier
        )
    }
    
    //setup function which observe when persons get updated
    func observerPersonObject() {
        self.viewModel.$persons
            .receive(on: DispatchQueue.main)
            .sink { _ in
                debugPrint(self.viewModel.convertRealMObjectToCodaleObject())
                self.tableView.reloadData()
            }
            .store(in: &self.viewModel.cancellable)
    }
    
}

//MARK: table data source method
extension PersonViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PersonCell.identifier,
            for: indexPath
        ) as? PersonCell else { return UITableViewCell() }
        cell.lblPersonName.text = self.viewModel.persons[indexPath.row].name
        cell.lblCity.text = self.viewModel.persons[indexPath.row].city
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: -  Alert
extension PersonViewController{
    
    func showAlertWithFields(
        isCreate: Bool = true,
        person: Person? = nil
    ) {
        
        let alert = UIAlertController(
            title: AlertConstant.person,
            message: "\(isCreate ? AlertConstant.add : AlertConstant.update) \(AlertConstant.personDetails)",
            preferredStyle: .alert
        )
        
        let add = UIAlertAction(
            title: isCreate ? AlertConstant.add : AlertConstant.update,
            style: .default
        ) { add in
            if let personName = alert.textFields?.first?.text,
               let cityName = alert.textFields?.last?.text{
                //check and create/update accordingly
                if !isCreate{
                    guard let id = person?.id,
                          let personIndex = self.viewModel.persons.firstIndex(where: { $0.id == id }) else { return }
                    self.viewModel.updatePerson(
                        id: id,
                        person: Person(
                            id: id,
                            name: personName,
                            city: cityName,
                            pets: self.viewModel.persons[personIndex].pets
                        )
                    )
                    
                    self.viewModel.persons[personIndex] = Person(
                        id: id,
                        name: personName,
                        city: cityName,
                        pets: self.viewModel.persons[personIndex].pets
                    )
                    
                } else {
                    //save on local database
                    let id =  UUID()
                    self.viewModel.savePerson(person: Person(
                        id: id,
                        name: personName,
                        city: cityName)
                    )
                    //append on class property of person type
                    self.viewModel.persons.append(
                        Person(
                            id: id, 
                            name: personName,
                            city: cityName
                        )
                    )
                }
            }
        }
        let cancel = UIAlertAction(
            title: AlertConstant.cancel,
            style: .destructive
        )
        
        alert.addTextField { personName in
            if isCreate{
                personName.placeholder = AlertConstant.enterPersonName
            } else {
                personName.text = person?.name
            }
        }
        
        alert.addTextField { cityName in
            if isCreate{
                cityName.placeholder = AlertConstant.enterCityName
            } else {
                cityName.text = person?.city
            }
           
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        self.present(alert, animated: true)
    }
}


//MARK: -  Alert
extension PersonViewController: PersonCellDelegate {
    
    func personCell(_ cell: PersonCell, didTapOnMenu: String) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        switch didTapOnMenu{
        case MenuOptionConstant.petInfo:
            
            guard let vc = UIStoryboard(
                name: "Main",
                bundle: .main
            ).instantiateViewController(
                withIdentifier: "PetListViewController"
            ) as? PetListViewController else { return }
            
            vc.viewModel.person = self.viewModel.persons[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        case MenuOptionConstant.edit:
            
            showAlertWithFields(
                isCreate: false,
                person: self.viewModel.persons[indexPath.row]
            )
        case MenuOptionConstant.delete:
            
            self.viewModel.deletePerson(
                person: self.viewModel.persons[indexPath.row]
            )
        default:
            return
        }
    }
}
