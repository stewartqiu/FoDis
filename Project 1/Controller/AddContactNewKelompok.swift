//
//  AddContact.swift
//  Project 1
//
//  Created by SchoolDroid on 12/15/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class AddContactNewKelompok: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate , UISearchControllerDelegate{
    
    @IBOutlet weak var jumlahSelectedLabel: UILabel!
    @IBOutlet weak var selectedContactCollectView: UICollectionView!
    @IBOutlet weak var listContactTableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var contactArray = [Kontak]()
    var selectedContactArray = [Kontak]()
    var filteredContactArray = [Kontak]()
    
    var isTambah = false
    var anggotaKelompok = [Anggota]()
    var kelompokTambah = Kelompok()
    var urutTerbesar = 0
    
    var isTest = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SettingLite().getFiltered(keyfile: SettingKey.isTest)! == "0" {
            isTest = false
        } else {
            isTest = true
        }
        
        navigationItemConfig()

        selectedContactCollectView.delegate = self
        selectedContactCollectView.dataSource = self
        
        listContactTableView.delegate = self
        listContactTableView.dataSource = self
        listContactTableView.allowsMultipleSelection = true
        listContactTableView.tableFooterView = UIView(frame: .zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        //let _ = HandleKeyboa
        
        if isTest{
            showRegisAlert()
        }
        
        let contactArray = STool.fetchContacts()
        
        let persHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)!
        
        for contact in contactArray {
            let kontak = Kontak()
            kontak.nama = contact.givenName + " " + contact.familyName
            var noHp = Transformator.getNumberFromContactObj(contact: contact)
            if noHp.first == "0" {
                noHp.removeFirst()
                noHp = "62" + noHp
            } else if noHp.first == "+"{
                noHp.removeFirst()
            }
            kontak.nomorHp = noHp
            if noHp != persHp{
                self.contactArray.append(kontak)
            }
        }
        
        if isTambah {
            setTambah()
        }
        
    }
    
    // MARK: - OVERRIDE

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedContactArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addedContactCollectCell", for: indexPath) as! SelectedContactCollectCell
        let contactAtIndex = selectedContactArray[indexPath.row]
        cell.contactNameLabel.text = contactAtIndex.nama
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredContactArray.count
        }else {
            return contactArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listContactTableCell") as! ListContactTCell
        var contactAtIndex = Kontak()
        
        if searchController.isActive && searchController.searchBar.text != "" {
            contactAtIndex = filteredContactArray[indexPath.row]
        }else {
            contactAtIndex = contactArray[indexPath.row]
        }
        
        let contactPhoneNumber = contactAtIndex.nomorHp
        cell.contactNameLabel.text = contactAtIndex.nama
        cell.contactNumberLabel.text = contactPhoneNumber
        
        for data in selectedContactArray {
            if data.nomorHp == contactAtIndex.nomorHp {
                listContactTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var contactAtIndex = Kontak()
        
        if searchController.isActive && searchController.searchBar.text != "" {
            contactAtIndex = filteredContactArray[indexPath.row]
        }else {
            contactAtIndex = contactArray[indexPath.row]
        }
        selectedContactArray.append(contactAtIndex)
        
        selectedContactCollectView.reloadData()
        
        checkSelected()
        
        let item = self.collectionView(self.selectedContactCollectView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.selectedContactCollectView.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.right, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var contactAtIndex = Kontak()
        
        if searchController.isActive && searchController.searchBar.text != "" {
            contactAtIndex = filteredContactArray[indexPath.row]
        } else {
            contactAtIndex = contactArray[indexPath.row]
        }
        
        let filteredRemoveIndex = selectedContactArray.index { (kontak) -> Bool in
            return kontak.nomorHp == contactAtIndex.nomorHp
        }
        selectedContactArray.remove(at: filteredRemoveIndex!)
        
        selectedContactCollectView.reloadData()
        
        checkSelected()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        listContactTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredContactArray = contactArray.filter({ (contact) -> Bool in
            let fullNameContact = contact.nama!
            return fullNameContact.lowercased().contains(searchText.lowercased())
        })
        listContactTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBuatKelompok" {
            let destination = segue.destination as! BuatKelompokController
            destination.addedContactArray = selectedContactArray
        }
    }
    
    // MARK: - FUNCTION
    
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
    
    func navigationItemConfig () {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(backView))
        
        let rightItem1 = UIBarButtonItem(title: "Lanjut", style: .plain, target: self, action: #selector(doneProses))
        rightItem1.isEnabled = false
        let rightItem2 = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchController))
        let rightItems : [UIBarButtonItem] = [rightItem1,rightItem2]
        
        navigationItem.setRightBarButtonItems(rightItems, animated: true)
    }
    
    @objc func showSearchController(){
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.keyboardType = .asciiCapable
        searchController.searchBar.placeholder = "Cari nama kontak"
        
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @objc func doneProses () {
        if isTambah {
            
            kelompokTambah.jumlahAnggota = String(Int(kelompokTambah.jumlahAnggota!)! + selectedContactArray.count)
            Simpan.kelompok(isTest: isTest, negara: kelompokTambah.negara!, prov: kelompokTambah.provinsi!, kota: kelompokTambah.kota!, idKelompok: kelompokTambah.id!, namaKelompok: kelompokTambah.nama! , deskripsiKelompok: kelompokTambah.deskripsi!, tanggalBuat: kelompokTambah.timeStamp!, idKetua: kelompokTambah.idKetua!, namaKetua: kelompokTambah.namaKetua!, admin: kelompokTambah.admin!, jumlahAnggota: kelompokTambah.jumlahAnggota!, jumlahBerita: kelompokTambah.jumlahBerita!, beritaAkhir: kelompokTambah.beritaAkhir!, fotoGrup: kelompokTambah.foto!, pinGrup: kelompokTambah.pin!, status: kelompokTambah.status!, lastFoto: kelompokTambah.lastFoto!)
            
            SimpanNet().statistikGrupList(negara: kelompokTambah.negara!, prov: kelompokTambah.provinsi!, kota: kelompokTambah.kota!, idGrup: kelompokTambah.id!, namaGrup: kelompokTambah.nama!, jumlahAnggota: kelompokTambah.jumlahAnggota!, jumlahBerita: kelompokTambah.jumlahBerita!)
            
            for i in 0 ..< selectedContactArray.count {
                let kontak = selectedContactArray[i]
                let urut = "00000\(urutTerbesar+i+1)"
                let idLink = kelompokTambah.id! + urut.suffix(4)
                
                let persHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)!
                
                Simpan.anggota(isTest: isTest, negaraKel: kelompokTambah.negara!, provKel: kelompokTambah.provinsi!, kotaKel: kelompokTambah.kota!, idLink: idLink, idGrup: kelompokTambah.id!, hpAnggota: kontak.nomorHp!, addedBy: persHp, allowedPin: "", namaAnggota: kontak.nama!, pathFoto: "", permission: "0000000000", tglInvite: Transformator.getNow(format: "dd-MM-yyyy"), promotedBy: "", removedBy: "")
            }
            
            self.dismiss(animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "toBuatKelompok", sender: self)
        }
    }
    
    @objc func backView () {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkSelected() {
        let doneItem = navigationItem.rightBarButtonItems![0]
        if selectedContactArray.count > 0 {
            doneItem.isEnabled = true
        } else {
            doneItem.isEnabled = false
        }
        
        jumlahSelectedLabel.text = "Jumlah Anggota : \(selectedContactArray.count)"
    }
    
    func setTambah() {
        
        navigationItem.rightBarButtonItems![0].title = "Tambah"
        
        for anggota in anggotaKelompok {
            var indexSama : Int?
            
            let urut = Int(anggota.idLink!.suffix(4))!
            
            if urut > urutTerbesar{
                urutTerbesar = urut
            }
            
            for i in 0 ..< contactArray.count {
                let contact = contactArray[i]
                if anggota.hpAnggota == contact.nomorHp {
                    indexSama = i
                }
            }
            
            if let index = indexSama{
                contactArray.remove(at: index)
            }
        }
        listContactTableView.reloadData()
        
    }
    
    func showRegisAlert () {
        
        let alert = UIAlertController(title: "Buat Grup", message: "Untuk membuat grup baru, anda perlu mendaftarkan Nomor Handphone terlebih dahulu", preferredStyle: .alert)
        
        let actionNanti = UIAlertAction(title: "Nanti", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let actionDaftar = UIAlertAction(title: "Daftar Sekarang", style: .default) { (_) in
            self.performSegue(withIdentifier: "toDaftar", sender: self)
        }
        
        alert.addAction(actionNanti)
        alert.addAction(actionDaftar)
        
        present(alert, animated: true, completion: nil)
        
    }


}
