//
//  PilihAdmin.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 12/19/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class PilihAdmin: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var kontakTableView: UITableView!

    var anggotaArray = [Anggota]()
    var kelompok = Kelompok()
    
    var isTest = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SettingLite().getFiltered(keyfile: SettingKey.isTest)! == "0" {
            isTest = false
        } else {
            isTest = true
        }

        kontakTableView.delegate = self
        kontakTableView.dataSource = self
        kontakTableView.tableFooterView = UIView(frame: .zero)
        
        kontakTableView.allowsSelection = false
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anggotaArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listContactTableCell") as! ListContactTCell
        let dataAtIndex = anggotaArray[indexPath.row]
        cell.contactNameLabel.text = dataAtIndex.namaAnggota!
        cell.contactNumberLabel.text = dataAtIndex.hpAnggota!
        
        let peran = Transformator.cekPeranAnggota(permission: dataAtIndex.permission!)
        
        if peran == PeranAnggota.ketua {
            cell.ketuaLabel.isHidden = false
            cell.jadikanAdminButton.isHidden = true
            cell.removeAdminView.isHidden = true
        } else if peran == PeranAnggota.admin {
            cell.ketuaLabel.isHidden = true
            cell.jadikanAdminButton.isHidden = true
            cell.removeAdminView.isHidden = false
        } else if peran == PeranAnggota.anggota {
            cell.ketuaLabel.isHidden = true
            cell.jadikanAdminButton.isHidden = false
            cell.removeAdminView.isHidden = true
        }
        
        cell.jadikanAdminButton.addTarget(self, action: #selector(self.jadikanAdmin(sender:)), for: UIControlEvents.touchUpInside)
        cell.removeAdminButton.addTarget(self, action: #selector(removeAdmin(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    @objc func jadikanAdmin (sender : UIButton) {
        if let cell = sender.superview?.superview as? ListContactTCell {
            let index = kontakTableView.indexPath(for: cell)!.row
            let dataAtIndex = anggotaArray[index]
            dataAtIndex.permission = "1100000000"
            
            Simpan.anggota(isTest: isTest, negaraKel: kelompok.negara!, provKel: kelompok.provinsi!, kotaKel: kelompok.kota!, idLink: dataAtIndex.idLink!, idGrup: dataAtIndex.idGrup!, hpAnggota: dataAtIndex.hpAnggota!, addedBy: dataAtIndex.addedBy!, allowedPin: dataAtIndex.allowedPin!, namaAnggota: dataAtIndex.namaAnggota!, pathFoto: dataAtIndex.pathFoto!, permission: dataAtIndex.permission!, tglInvite: dataAtIndex.tglInvite!, promotedBy: dataAtIndex.promotedBy!, removedBy: dataAtIndex.removedBy!)
            
            kelompok.admin = "\(kelompok.admin!),\(dataAtIndex.hpAnggota!)"
            
            Simpan.kelompok(isTest: isTest, negara: kelompok.negara!, prov: kelompok.provinsi!, kota: kelompok.kota!, idKelompok: kelompok.id!, namaKelompok: kelompok.nama!, deskripsiKelompok: kelompok.deskripsi!, tanggalBuat: kelompok.timeStamp!, idKetua: kelompok.idKetua!, namaKetua: kelompok.namaKetua!, admin: kelompok.admin!, jumlahAnggota: kelompok.jumlahAnggota!, jumlahBerita: kelompok.jumlahBerita!, beritaAkhir: kelompok.beritaAkhir!, fotoGrup: kelompok.foto!, pinGrup: kelompok.pin!, status: kelompok.status!, lastFoto: "")
            
            cell.jadikanAdminButton.isHidden = true
            cell.removeAdminView.isHidden = false
        }
    }
    
    @objc func removeAdmin (sender : UIButton){
        if let cell = sender.superview?.superview?.superview as? ListContactTCell {
            let index = kontakTableView.indexPath(for: cell)!.row
            let dataAtIndex = anggotaArray[index]
            dataAtIndex.permission = "0000000000"
            
            Simpan.anggota(isTest: isTest, negaraKel: kelompok.negara!, provKel: kelompok.provinsi!, kotaKel: kelompok.kota!, idLink: dataAtIndex.idLink!, idGrup: dataAtIndex.idGrup!, hpAnggota: dataAtIndex.hpAnggota!, addedBy: dataAtIndex.addedBy!, allowedPin: dataAtIndex.allowedPin!, namaAnggota: dataAtIndex.namaAnggota!, pathFoto: dataAtIndex.pathFoto!, permission: dataAtIndex.permission!, tglInvite: dataAtIndex.tglInvite!, promotedBy: dataAtIndex.promotedBy!, removedBy: dataAtIndex.removedBy!)
            
            var value = kelompok.admin!
            
            if let range = value.range(of: ",\(dataAtIndex.hpAnggota!)") {
                value.removeSubrange(range)
            }
            else if let range = value.range(of: "\(dataAtIndex.hpAnggota!)") {
                value.removeSubrange(range)
            }
            
            kelompok.admin = value
            
            Simpan.kelompok(isTest: isTest, negara: kelompok.negara!, prov: kelompok.provinsi!, kota: kelompok.kota!, idKelompok: kelompok.id!, namaKelompok: kelompok.nama!, deskripsiKelompok: kelompok.deskripsi!, tanggalBuat: kelompok.timeStamp!, idKetua: kelompok.idKetua!, namaKetua: kelompok.namaKetua!, admin: kelompok.admin!, jumlahAnggota: kelompok.jumlahAnggota!, jumlahBerita: kelompok.jumlahBerita!, beritaAkhir: kelompok.beritaAkhir!, fotoGrup: kelompok.foto!, pinGrup: kelompok.pin!, status: kelompok.status!, lastFoto: "")
            
            
            cell.jadikanAdminButton.isHidden = false
            cell.removeAdminView.isHidden = true
        }
    }


}
