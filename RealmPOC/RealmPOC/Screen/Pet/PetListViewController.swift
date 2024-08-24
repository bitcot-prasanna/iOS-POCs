//
//  PetListViewController.swift
//  RealmPOC
//
//  Created by Prasanna Joshi on 8/22/24.
//

import UIKit
import RealmSwift

class PetListViewController: UIViewController {
    
    //outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblOwner: UILabel!
    @IBOutlet weak var lblOwnerCity: UILabel!
    
    //variables and constants
    let viewModel = PetListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //User Function
    func setup(){
        setuptable()
        observerPetObject()
        feedData()
        loadNavigation()
    }
    
    //navigation
    func loadNavigation(){
        self.title = NavigationConstant.petList
        let rightBarButton = UIBarButtonItem(
            title: NavigationConstant.addPet,
            style: .plain,
            target: self,
            action: #selector(didTapOnAddPet)
        )
        rightBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func didTapOnAddPet(){
        showAlertWithFields()
    }
    
    //feed data
    func feedData(){
        self.lblOwner.text = self.viewModel.person?.name
        self.lblOwnerCity.text = self.viewModel.person?.city
    }
    
    //setup function which observe when persons get updated
    func observerPetObject() {
        self.viewModel.$person
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.tableView.reloadData()
            }
            .store(in: &self.viewModel.cancellable)
    }
    
    //setup table
    func setuptable() {
        self.tableView.register(
            UINib(
                nibName: PetCell.identifier,
                bundle: .main
            ),
            forCellReuseIdentifier: PetCell.identifier
        )
    }
}

//MARK: table data source method
extension PetListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.person?.pets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PetCell.identifier,
            for: indexPath
        ) as? PetCell else { return UITableViewCell() }
        cell.lblPetName.text = self.viewModel.person?.pets[indexPath.row].name
        cell.lblBreed.text = self.viewModel.person?.pets[indexPath.row].breed
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: -  Alert
extension PetListViewController{
    
    func showAlertWithFields(isCreate: Bool = true){
        
        let alert = UIAlertController(
            title: AlertConstant.person,
            message: "\(isCreate ? AlertConstant.add : AlertConstant.update) \(AlertConstant.personDetails)",
            preferredStyle: .alert
        )
        
        alert.addTextField { personName in
            personName.placeholder = AlertConstant.enterPersonName
        }
        
        alert.addTextField { cityName in
            cityName.placeholder = AlertConstant.enterCityName
        }
        
        let add = UIAlertAction(
            title: AlertConstant.add,
            style: .default
        ) { add in
            if let petName = alert.textFields?.first?.text,
               let breedName = alert.textFields?.last?.text{
                guard let id = self.viewModel.person?.id else { return }
                let petsList = List<Pet>()
                petsList.append(objectsIn: self.viewModel.person?.pets ?? List<Pet>())
                petsList.append(Pet(id: UUID(), name: petName, breed: breedName))
                self.viewModel.savePetObject(
                    person: Person(
                        id: id,
                        name: self.viewModel.person?.name ?? "",
                        city: self.viewModel.person?.city ?? "",
                        pets: petsList
                    )
                )
            }
        }
        let cancel = UIAlertAction(
            title: AlertConstant.cancel,
            style: .destructive
        )
        
        alert.addAction(cancel)
        alert.addAction(add)
        self.present(alert, animated: true)
    }
}

