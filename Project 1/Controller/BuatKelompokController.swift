//
//  TambahKelompokController.swift
//  Project 1
//
//  Created by SchoolDroid on 12/6/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import DropDown
import SVProgressHUD

class BuatKelompokController: UIViewController , UITextFieldDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UITextViewDelegate , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
   
    @IBOutlet weak var namaKelompokTF: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var collecView: UICollectionView!
    @IBOutlet weak var jumlahAnggotaLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var menu: UIImageView!
    @IBOutlet weak var kelompokImage: UIImageView!
    
    var isNamaKelompokComplete = false
    var isDeskripsiKelompokComplete = false
    
    var addedContactArray = [Kontak]()
    
    var kelompokToEdit = Kelompok()
    var anggotaArray = [Anggota]()
    var isEdit = false
    
    let dropDown = DropDown()
    
    var selectedImage : UIImage?
    
    var peran = ""
    
    var isTest = true
    
    let persHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)!
    
    var inDeleteMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SettingLite().getFiltered(keyfile: SettingKey.isTest)! == "0" {
            isTest = false
        } else {
            isTest = true
        }

        configureTextView()
        
        namaKelompokTF.delegate = self
        namaKelompokTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        
        configureCollectionView()
        
        imageKelompokConfig()
        
        jumlahAnggotaLabel.text = "Anggota : \(addedContactArray.count)"
        
        if isEdit {
            setEdit()
        }
        
    }
  
    // MARK: - IBACTION
    // *************************************************************************
    
    @IBAction func saveButton(_ sender: Any) {
        
        let namaKelompok = namaKelompokTF.text
        let deskripsi = descTextView.text
        
        if isEdit {

            kelompokToEdit.nama = namaKelompok
            kelompokToEdit.deskripsi = deskripsi
            // foto
            
            Simpan.kelompok(isTest: isTest, negara: kelompokToEdit.negara!, prov: kelompokToEdit.provinsi!, kota: kelompokToEdit.kota!, idKelompok: kelompokToEdit.id!, namaKelompok: kelompokToEdit.nama!, deskripsiKelompok: kelompokToEdit.deskripsi!, tanggalBuat: kelompokToEdit.timeStamp!, idKetua: kelompokToEdit.idKetua!, namaKetua: kelompokToEdit.namaKetua!, admin: kelompokToEdit.admin!, jumlahAnggota: kelompokToEdit.jumlahAnggota!, jumlahBerita: kelompokToEdit.jumlahBerita!, beritaAkhir: kelompokToEdit.beritaAkhir!, fotoGrup: kelompokToEdit.foto!, pinGrup: kelompokToEdit.pin!, status: kelompokToEdit.status!, lastFoto: kelompokToEdit.lastFoto!)
            
            SimpanNet().statistikGrupList(negara: kelompokToEdit.negara!, prov: kelompokToEdit.provinsi!, kota: kelompokToEdit.kota!, idGrup: kelompokToEdit.id!, namaGrup: kelompokToEdit.nama!, jumlahAnggota: kelompokToEdit.jumlahAnggota!, jumlahBerita: kelompokToEdit.jumlahBerita!)
            
            if let image = selectedImage {
                SVProgressHUD.show(withStatus: "Mengunggah foto")
                SimpanNet().uploadImageKelompok(idGrup: kelompokToEdit.id!, image: image, url: { (url) in
                    Simpan.updateImageUrlGrup(negara: self.kelompokToEdit.negara!, prov: self.kelompokToEdit.provinsi!, kota: self.kelompokToEdit.kota!, idGrup: self.kelompokToEdit.id!, url: url)
                    SVProgressHUD.dismiss()
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                 self.navigationController?.popViewController(animated: true)
            }
            
            
            
        } else {
        
            var idKelompok = String()
            let setting = SettingLite()
            let persHp = setting.getFiltered(keyfile: SettingKey.noHp)!
            let data = KelompokLite().getData()
            let namaKetua = setting.getFiltered(keyfile: SettingKey.nama)!
            let negara = setting.getFiltered(keyfile: SettingKey.negara)!
            let prov = setting.getFiltered(keyfile: SettingKey.provinsi)!
            let kota = setting.getFiltered(keyfile: SettingKey.kota)!
            
            if data.isEmpty {
                idKelompok = persHp + "0001"
            } else {
                let urut = "00000" + String(data.count+1)
                idKelompok = persHp + urut.suffix(4)
            }
            
            print(idKelompok)
            
            Simpan.kelompok(isTest: isTest, negara: negara, prov: prov, kota: kota, idKelompok: idKelompok, namaKelompok: namaKelompok!, deskripsiKelompok: deskripsi!, tanggalBuat: Transformator.getNow(format: "dd-MM-yyyy"), idKetua: persHp, namaKetua: namaKetua, admin: persHp, jumlahAnggota: String(addedContactArray.count+1), jumlahBerita: "0", beritaAkhir: "(Belum ada berita)", fotoGrup: "", pinGrup: "", status: "" , lastFoto: "")
            
            Simpan.anggota(isTest: isTest, negaraKel: negara, provKel: prov, kotaKel: kota, idLink: idKelompok + "0000", idGrup: idKelompok, hpAnggota: persHp, addedBy: persHp, allowedPin: "", namaAnggota: setting.getFiltered(keyfile: SettingKey.nama)!, pathFoto: setting.getFiltered(keyfile: SettingKey.foto)!, permission: "1111000000", tglInvite: Transformator.getNow(format: "dd-MM-yyyy"), promotedBy: persHp, removedBy: "")
            
            for i in 0 ..< addedContactArray.count {
                let urut = "00000" + String(i+1)
                let idlink = idKelompok + urut.suffix(4)
                let kontak = addedContactArray[i]
                let tglnow = Transformator.getNow(format: "dd-MM-yyyy")
                
                Simpan.anggota(isTest: isTest, negaraKel: negara, provKel: prov, kotaKel: kota, idLink: idlink, idGrup: idKelompok, hpAnggota: kontak.nomorHp!, addedBy: persHp, allowedPin: "", namaAnggota: kontak.nama!, pathFoto: "", permission: "0000000000", tglInvite: tglnow, promotedBy: "", removedBy: "")
                
            }
            
            SimpanNet().statistikGrupList(negara: negara, prov: prov, kota: kota, idGrup: idKelompok, namaGrup: namaKelompok!, jumlahAnggota: "\(addedContactArray.count+1)", jumlahBerita: "0")
            
            if let image = selectedImage {
                SVProgressHUD.show(withStatus: "Mengunggah foto")
                SimpanNet().uploadImageKelompok(idGrup: idKelompok, image: image, url: { (url) in
                    Simpan.updateImageUrlGrup(negara: negara, prov: prov, kota: kota, idGrup: idKelompok, url: url)
                    SVProgressHUD.dismiss()
                    self.navigationController?.dismiss(animated: true, completion: nil)
                })
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    // MARK: - OVERRIDE
    // **************************************************************************
    
    override func viewDidAppear(_ animated: Bool) {
        if isEdit {
            loadAnggota()
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = namaKelompokTF.text!
        if text.count == 0 {
            isNamaKelompokComplete = false
        }
        else {
            isNamaKelompokComplete = true
        }
        checkComplete()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == namaKelompokTF {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 50
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isEdit {
            return anggotaArray.count
        }
        return addedContactArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCollecView", for: indexPath) as! contactCollectCell
        
        if isEdit {
            
            let anggotaAtIndex = anggotaArray[indexPath.row]
            
            cell.contactNameLabel.text = anggotaAtIndex.namaAnggota
            
            if inDeleteMode {
                if kelompokToEdit.idKetua! == anggotaAtIndex.hpAnggota! || persHp == anggotaAtIndex.hpAnggota!{
                    cell.deletebtn.isHidden = true
                    cell.controller = nil
                } else {
                    cell.deletebtn.isHidden = false
                    cell.controller = self
                    cell.anggotaToDelete = anggotaAtIndex
                }
            } else {
                cell.deletebtn.isHidden = true
                cell.controller = nil
            }
            
        }else{
            cell.contactNameLabel.text = addedContactArray[indexPath.row].nama
             cell.deletebtn.isHidden = true
        }
        
        
        return cell
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Deskripsi singkat" && textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Deskripsi singkat"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == descTextView {
            
            if descTextView.text.count == 0 {
                isDeskripsiKelompokComplete = false
            }
            else {
                isDeskripsiKelompokComplete = true
            }
            
            checkComplete()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == descTextView {
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            
            return updatedText.count <= 100
        }
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editImage = info[UIImagePickerControllerEditedImage] {
            selectedImage = editImage as? UIImage
        }
        else {
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        kelompokImage.image = selectedImage
        dismiss(animated: true, completion: nil)
        checkComplete()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPilihAdmin" {
            let destination = segue.destination as! PilihAdmin
            destination.anggotaArray = anggotaArray
            destination.kelompok = kelompokToEdit
        } else if segue.identifier == "tambahAnggota" {
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! AddContactNewKelompok
            controller.isTambah = true
            controller.anggotaKelompok = anggotaArray
            controller.kelompokTambah = kelompokToEdit
        }
    }

    
    func getKontak(kontakArray: [Kontak]) {
        addedContactArray = kontakArray
    }
    
    // MARK: - FUNCTION
    // ************************************************************************
    
    
    func configureTextView () {
        descTextView.delegate = self
        
        let borderColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 0.7)
        descTextView.layer.borderColor = borderColor.cgColor;
        descTextView.layer.borderWidth = 1.0;
        descTextView.layer.cornerRadius = 5.0;
        descTextView.backgroundColor = UIColor.clear
        
        if !isEdit {
            descTextView.text = "Deskripsi singkat"
            descTextView.textColor = UIColor.lightGray
        }
    }
    
    func configureCollectionView () {
        
        collecView.delegate = self
        collecView.dataSource = self
        
        let jumlahItem : CGFloat = 4
        let horizontalSpacing = 20 / jumlahItem
        
        let itemSize = UIScreen.main.bounds.width / jumlahItem - (jumlahItem + horizontalSpacing)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 20, 10)
        layout.itemSize = CGSize(width: itemSize, height: 95)
        layout.minimumInteritemSpacing = jumlahItem
        layout.minimumLineSpacing = jumlahItem
        
        collecView.collectionViewLayout = layout
        
    }

    
    func checkComplete () {
        if isNamaKelompokComplete && isDeskripsiKelompokComplete {
            saveBtn.isEnabled = true
        }
        else {
            saveBtn.isEnabled = false
        }
    }
    
    func findContacts () -> [CNContact]{
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey] as! [CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts = [CNContact]()
        
        fetchRequest.mutableObjects = false
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault
        
        let contactStoreID = CNContactStore().defaultContainerIdentifier()
        print("APA INI \(contactStoreID)")
        
        do {
            
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                
                    contacts.append(contact)
            }
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
        
        return contacts
        
    }
    
    func setEdit () {
        
        navigationItem.title = "Tentang Kelompok"
        
        namaKelompokTF.text = kelompokToEdit.nama
        descTextView.text = kelompokToEdit.deskripsi
        loadAnggota()
        
        menu.isHidden = false
        
        menu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDropDown)))
        isNamaKelompokComplete = true
        isDeskripsiKelompokComplete = true
        
        if kelompokToEdit.foto != nil && kelompokToEdit.foto! != "" && kelompokToEdit.foto! != "null" {
            kelompokImage.kf.indicatorType = .activity
            kelompokImage.kf.setImage(with: URL(string: kelompokToEdit.foto!), placeholder: #imageLiteral(resourceName: "image"))
        }
        
        for anggota in anggotaArray {
            if anggota.hpAnggota! == persHp {
                peran = Transformator.cekPeranAnggota(permission: anggota.permission!)
            }
        }
        
        if peran == PeranAnggota.ketua {
            namaKelompokTF.isEnabled = true
            descTextView.isEditable = true
            kelompokImage.isUserInteractionEnabled = true
            saveBtn.title = "Simpan"
        }else {
            namaKelompokTF.isEnabled = false
            descTextView.isEditable = false
            kelompokImage.isUserInteractionEnabled = false
            saveBtn.title = ""
        }
        
        dropDownConfig()
        
    }
    
    func dropDownConfig () {
        
        dropDown.anchorView = menu
        
        var dataSource = [String]()
        
        if peran == PeranAnggota.ketua {
            dataSource = ["Pilih Admin" , "Tambah Anggota", "Hapus Anggota","Keluar dari Grup"]
        } else if peran == PeranAnggota.admin {
            dataSource = ["Tambah Anggota" , "Hapus Anggota" , "Keluar dari Grup"]
        } else if peran == PeranAnggota.anggota{
            dataSource = ["Keluar dari Grup"]
        }
        
        dropDown.dataSource = dataSource
        
        dropDown.width = 200
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Pilih Admin" {
                self.performSegue(withIdentifier: "toPilihAdmin", sender: self)
            } else if item == "Tambah Anggota" {
                self.performSegue(withIdentifier: "tambahAnggota", sender: self)
            } else if item == "Hapus Anggota" {
                
                self.inDeleteMode = true
                self.collecView.reloadData()
                
            }
        }
        dropDown.index
        
    }
    
    
    @objc func showDropDown() {
        
        dropDown.show()
    }
    
    func imageKelompokConfig () {
        
        kelompokImage.layer.cornerRadius = kelompokImage.frame.height / 2
        kelompokImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(kelompokImagePressed)))
        
    }
    
    @objc func kelompokImagePressed () {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAct = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let kameraAct = UIAlertAction(title: "Kamera", style: .default) { (_) in
            STool.openKamera(sender: self, editable: true)
        }
        let fotoAct = UIAlertAction(title: "Pilih Foto", style: .default) { (_) in
            STool.openPhotoLibrary(sender: self, editable: true)
        }
        
        alert.addAction(cancelAct)
        alert.addAction(kameraAct)
        alert.addAction(fotoAct)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteAnggota (anggota : Anggota) {
        
        let alert = UIAlertController(title: "Nama Anggota : \(anggota.namaAnggota!)", message: "Apakah anda yakin akan menghapus anggota ?", preferredStyle: .alert)
        
        let actionBatal = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let actionYa = UIAlertAction(title: "Ya", style: .default) { (_) in
            
            self.kelompokToEdit.jumlahAnggota = "\(Int(self.kelompokToEdit.jumlahAnggota!)! - 1)"
            Simpan.deleteAnggota(isTest: self.isTest, negaraKel: self.kelompokToEdit.negara!, provKel: self.kelompokToEdit.provinsi!, kotaKel: self.kelompokToEdit.kota!, idGrup: self.kelompokToEdit.id!, hpToDelete: anggota.hpAnggota!, idLink: anggota.idLink!)
            
            Simpan.kelompok(isTest: self.isTest, negara: self.kelompokToEdit.negara!, prov: self.kelompokToEdit.provinsi!, kota: self.kelompokToEdit.kota!, idKelompok: self.kelompokToEdit.id!, namaKelompok: self.kelompokToEdit.nama!, deskripsiKelompok: self.kelompokToEdit.deskripsi!, tanggalBuat: self.kelompokToEdit.timeStamp!, idKetua: self.kelompokToEdit.idKetua!, namaKetua: self.kelompokToEdit.namaKetua!, admin: self.kelompokToEdit.admin!, jumlahAnggota: self.kelompokToEdit.jumlahAnggota!, jumlahBerita: self.kelompokToEdit.jumlahBerita!, beritaAkhir: self.kelompokToEdit.beritaAkhir!, fotoGrup: self.kelompokToEdit.foto!, pinGrup: self.kelompokToEdit.pin!, status: self.kelompokToEdit.status!, lastFoto: self.kelompokToEdit.lastFoto!)
            
            self.loadAnggota()
            
        }
        
        //alert.addAction(actionYa)
        alert.addAction(actionBatal)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadAnggota () {
        anggotaArray = AnggotaLite().getFiltered(key: AnggotaLite().idGrup, value: kelompokToEdit.id!)
        jumlahAnggotaLabel.text = "Anggota : \(anggotaArray.count)"
        collecView.reloadData()
    }
    
    //    @IBAction func addContact(_ sender: Any) {
    //
    //        print("add contact tapped")
    //        let entityType = CNEntityType.contacts
    //        let authStatus = CNContactStore.authorizationStatus(for: entityType)
    //
    //        if authStatus == CNAuthorizationStatus.notDetermined {
    //
    //
    //
    //            let contactStore = CNContactStore.init()
    //            contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
    //                if success {
    //
    //                    let contactArray = self.findContacts()
    //                    print("NAMA \(contactArray[0].givenName)")
    //                    print((contactArray[0].phoneNumbers[0].value).value(forKey: "digits") as! String)
    //
    //                }
    //                else {
    //                    print("Not Authorized")
    //                }
    //            })
    //
    //        }
    //        else if authStatus == CNAuthorizationStatus.authorized {
    //            let contactArray = self.findContacts()
    //            print("NAMA \(contactArray[0].givenName)")
    //            print((contactArray[0].phoneNumbers[0].value).value(forKey: "digits") as! String)
    //        }
    //
    //    }
    
    //    func openContact (){
    //        let contactPicker = CNContactPickerViewController()
    //        contactPicker.delegate = self
    //        self.present(contactPicker, animated: true, completion: nil)
    //    }
    
    //    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    
    //    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
    //        print("DEBUG \(contacts)")
    //        if contacts.count > 0{
    //            addedContactArray = contacts
    //            jumlahAnggotaLabel.text = "Anggota : \(contacts.count)"
    //            print((contacts[0].phoneNumbers[0].value).value(forKey: "digits") as! String)
    //            collecView.reloadData()
    //        }
    //    }
    
}
