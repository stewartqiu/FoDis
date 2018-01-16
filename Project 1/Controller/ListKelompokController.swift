//
//  ListKelompokController.swift
//  Project 1
//
//  Created by SchoolDroid on 12/4/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import SVProgressHUD

class ListKelompokController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var jumlahKelompokLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var kelompokArray = [Kelompok]()
    var filteredArray = [Kelompok]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        loadData()
        
        print(tableBottomConstraint.constant)
        
        if SettingLite().getFiltered(keyfile: SettingKey.isTest)! == "0" {
            ambilNet()
        } else {
            let alert = UIAlertController(title: "Selamat Datang...", message: "Data yang tersedia saat ini hanya sebagai contoh.\n\n*) Data contoh akan dihapus setelah Anda melakukan registrasi.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        test()
        
        handleSurveiPayment()
        
    }
    
    func test () {
        
        //SimpanNet().deleteGrupAnggota(negaraKel: "Indonesia", provKel: "Riau", kotaKel: "Pekanbaru", idGrup: "6260002", hpToDelete: "625")
        
    }
    
    func ambilNet() {
        let ambil = AmbilNet()
        ambil.grupPath { (path) in
            print(path)
            ambil.grupAddedListener(pathGrup: path, completion: {
                self.loadData()
            })
            ambil.grupChangeListener(pathGrup: path, completion: nil)
            ambil.anggotaRemovedListener(pathGrup: path, completion: nil)
        }
    }
    
    // MARK: - IBACTION
    
    @IBAction func searchItemTapped(_ sender: Any) {
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.keyboardType = .asciiCapable
        searchController.searchBar.placeholder = "Cari nama kelompok"
        
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
        
    }
    
    @IBAction func buatKelompokTapped(_ sender: Any) {
        searchController.dismiss(animated: true, completion: nil)
        
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined {

            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
                if success {
                    self.performSegue(withIdentifier: "addGroupSegue", sender: self)
                }
                else {
                    Authorization.toSetting(sender: self, title: "Akses kontak", message: "Akses untuk membaca kontak dibutuhkan. Mohon berikan akses")
                }
            })
        }
        else if authStatus == CNAuthorizationStatus.authorized {
            self.performSegue(withIdentifier: "addGroupSegue", sender: self)
        }
        else {
            Authorization.toSetting(sender: self, title: "Akses kontak", message: "Akses untuk membaca kontak dibutuhkan. Mohon berikan akses")
        }

        
    }
    
    // MARK: - OVERRIDE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredArray.count
            
        } else {
           return kelompokArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kelompokCell") as! KelompokCell
        
        var kelompokAtIndex = Kelompok()
        
        if searchController.isActive && searchController.searchBar.text != "" {
            kelompokAtIndex = filteredArray[indexPath.row]
        } else {
            kelompokAtIndex = kelompokArray[indexPath.row]
        }
        
        cell.jumlahAnggotaLabel.text = kelompokAtIndex.jumlahAnggota
        cell.namaKelompokLabel.text = kelompokAtIndex.nama
        
        if kelompokAtIndex.beritaAkhir! == "(Belum ada berita)" || kelompokAtIndex.beritaAkhir! == ""{
            cell.deskripsiLabel.text = "(Belum ada berita)"
            cell.tanggalKelompok.text = ""
           
        } else {
            let last = BeritaLite().getFiltered(key: BeritaLite().idBerita_key, value: kelompokAtIndex.beritaAkhir!)
            if !last.isEmpty {
                cell.deskripsiLabel.text = last[0].judul
                cell.tanggalKelompok.text = last[0].tanggal
            }
        }
        
        if kelompokAtIndex.foto != nil && kelompokAtIndex.foto! != "" && kelompokAtIndex.foto! != "null" {
            cell.iconImage.kf.indicatorType = .activity
            cell.iconImage.kf.setImage(with: URL(string: kelompokAtIndex.foto!), placeholder: #imageLiteral(resourceName: "image"))
        }
        
        cell.jumlahAnggotaButton.tag = indexPath.row
        cell.jumlahAnggotaButton.addTarget(self, action: #selector(jumlahAnggotaPressed(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.kelompokProfilButton.tag = indexPath.row
        cell.kelompokProfilButton.addTarget(self, action: #selector(kelompokProfilPressed(sender:)), for: UIControlEvents.touchUpInside)
       
        
        return cell
    }
    
    var selectedKelompokNama = String()
    var selectedKelompokToInspect = Kelompok()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Kelompok Selected")
        searchController.dismiss(animated: true, completion: nil)
        
        let userDefault = UserDefaults.standard
        if searchController.isActive && searchController.searchBar.text != "" {
            userDefault.set(filteredArray[indexPath.row].id, forKey: "KelompokPref")
        } else {
            userDefault.set(kelompokArray[indexPath.row].id, forKey: "KelompokPref")
        }
    
        performSegue(withIdentifier: "toListArtikel", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListArtikel" {
            
        }
        else if segue.identifier == "toListAnggotaKelompok" {
            let destination = segue.destination as! AnggotaKelompok
            destination.kelompok = selectedKelompokToInspect
        }
        else if segue.identifier == "toProfilKelompok" {
            let destination = segue.destination as! BuatKelompokController
            destination.kelompokToEdit = selectedKelompokToInspect
            destination.isEdit = true
        }
    
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = kelompokArray.filter({ (kelompok) -> Bool in
            return kelompok.nama!.lowercased().contains(searchText.lowercased())
           
        })
        tableView.reloadData()
    }
    
    // MARK: - FUNCTION
    // *********************************************************
    
    @objc func handleKeyboardShow (notification : NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]! as! CGRect
            
            let isKeyboardShow = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            if isKeyboardShow {
                print("show")
                self.tableBottomConstraint.constant = -keyboardFrame.height
                self.view.layoutIfNeeded()
            }
            else {
                print("notshow")
                self.tableBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            print(tableBottomConstraint.constant)
        }
    }
    
    @objc func jumlahAnggotaPressed (sender : UIButton) {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedKelompokToInspect = filteredArray[sender.tag]
        } else {
             selectedKelompokToInspect = kelompokArray[sender.tag]
        }
        
        performSegue(withIdentifier: "toListAnggotaKelompok", sender: self)
        
        print(sender.tag)
        
    }
    
    @objc func kelompokProfilPressed (sender : UIButton) {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedKelompokToInspect = filteredArray[sender.tag]
        } else {
            selectedKelompokToInspect = kelompokArray[sender.tag]
        }
        
        performSegue(withIdentifier: "toProfilKelompok", sender: self)
        
        print(sender.tag)
        
    }
    
    func loadData(){
        
        let fetchData = KelompokLite().getData()
        kelompokArray = fetchData
       
        setJumlahKelompokLabel()
        
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func setJumlahKelompokLabel() {
        jumlahKelompokLabel.text = "Kelompok (\(kelompokArray.count))"
    }
    
    
    func handleSurveiPayment () {
        let setting = SettingLite()
        
        if SettingLite().getFiltered(keyfile: SettingKey.caraPayment) == nil || SettingLite().getFiltered(keyfile: SettingKey.caraPayment) == "" || SettingLite().getFiltered(keyfile: SettingKey.caraPayment) == "null" {
            performSegue(withIdentifier: "showSurvei", sender: self)
        } else if SettingLite().getFiltered(keyfile: SettingKey.id) != nil || SettingLite().getFiltered(keyfile: SettingKey.id) != "" || SettingLite().getFiltered(keyfile: SettingKey.id) != "null" {
            if setting.getFiltered(keyfile: SettingKey.sudahSimpanPayment) == nil || setting.getFiltered(keyfile: SettingKey.sudahSimpanPayment) != "1"{
                SimpanNet().payment(negara: setting.getFiltered(keyfile: SettingKey.negara)!, prov: setting.getFiltered(keyfile: SettingKey.provinsi)!, kota: setting.getFiltered(keyfile: SettingKey.kota)!, noHp: setting.getFiltered(keyfile: SettingKey.noHp)!, cara: setting.getFiltered(keyfile: SettingKey.caraPayment)!, tanggal: setting.getFiltered(keyfile: SettingKey.tanggalPayment)!)
                
                let _ = setting.insertData(keyfile: SettingKey.sudahSimpanPayment, value: "1")
            }
        }
    }
    
    
    
}













