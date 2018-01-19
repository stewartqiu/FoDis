//
//  SharePopUp.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 1/16/18.
//  Copyright © 2018 SchoolDroid. All rights reserved.
//

import UIKit
import SVProgressHUD

class SharePopUp: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var kelompokArray = [Kelompok]()
    var beritaToShare = Berita()
    var isiBeritaToShare = [IsiBerita]()
    
    var isTest = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SettingLite().getFiltered(keyfile: SettingKey.isTest)! == "0" {
            isTest = false
        } else {
            isTest = true
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        loadKelompok()
    }

    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK:- Override
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kelompokArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "grupToShareCell") as! AnggotaKelompokCell
        
        let kelompokAtIndex = kelompokArray[indexPath.row]
        
        cell.namaAnggotaLabel.text = kelompokAtIndex.nama!
        
        if kelompokAtIndex.foto != nil && kelompokAtIndex.foto! != "" && kelompokAtIndex.foto! != "null" {
            cell.anggotaImage.kf.indicatorType = .activity
            cell.anggotaImage.kf.setImage(with: URL(string: kelompokAtIndex.foto!), placeholder: #imageLiteral(resourceName: "group"))
        } else {
            cell.anggotaImage.image = #imageLiteral(resourceName: "group")
        }
        
        cell.anggotaImage.layer.cornerRadius = cell.anggotaImage.frame.height / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.show()
        
        let kelompokSelected = kelompokArray[indexPath.row]
        let beritaArray = BeritaLite().getFiltered(key: BeritaLite().idKelompok_key, value: kelompokSelected.id!)
        var urutTerbesar = 0
        
        for berita in beritaArray {
            let urut = Int(berita.idBerita!.suffix(6))!
            if urut > urutTerbesar {
                urutTerbesar = urut
            }
        }
        
        let urut = "000000\(urutTerbesar+1)"
        
        let idBerita = "\(kelompokSelected.id!)\(urut.suffix(6))"
        let tanggalWaktu = Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss")
        
        Simpan.beritaData(isTest: isTest, negaraKel: kelompokSelected.negara!, provKel: kelompokSelected.provinsi!, kotaKel: kelompokSelected.kota!, idBerita: idBerita, idGrup: kelompokSelected.id!, judul: beritaToShare.judul!, kataKunci: beritaToShare.kataKunci!, created: tanggalWaktu, createdBy: beritaToShare.createdBy!, publish: "T", published: tanggalWaktu, tanggal: beritaToShare.tanggal!, totLike: "0", totView: "0", unpublished: "")
        
        for isiBerita in self.isiBeritaToShare {
            let oldIdIsi = isiBerita.idIsi!
            let newIdIsi = "\(idBerita)\(oldIdIsi.suffix(3))"
            Simpan.isiBerita(isTest: self.isTest, negara: kelompokSelected.negara!, prov: kelompokSelected.provinsi!, kota: kelompokSelected.kota!, idGrup: kelompokSelected.id!, idBerita: idBerita, idIsi: newIdIsi, berita: isiBerita.berita!, fileUrl: isiBerita.fileUrl!, foto: isiBerita.foto!)
        }
        
        
        var beritaKel = BeritaLite().getFiltered(key: BeritaLite().idKelompok_key, value: kelompokSelected.id!)
        beritaKel.sort { (berita1, berita2) -> Bool in
            return berita1.idBerita! < berita2.idBerita!
        }
        
        var lastPublishedBerita = ""
        for berita in beritaKel {
            if berita.publish == "T" {
                lastPublishedBerita = berita.idBerita!
            }
        }
        
        Simpan.updateBeritaAkhir(isTest: isTest, negara: kelompokSelected.negara!, prov: kelompokSelected.negara!, kota: kelompokSelected.kota!, idGrup: kelompokSelected.id!, idBerita: lastPublishedBerita)
        
        SVProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
        SVProgressHUD.showSuccess(withStatus: "Artikel berhasil dibagikan ke Grup \(kelompokSelected.nama!)")
    }
    
    //MARK:- Function
    
    func loadKelompok() {
        kelompokArray = KelompokLite().getData()
        let filteredRemoveIndex = kelompokArray.index { (kelompok) -> Bool in
            return kelompok.id == UserDefaults.standard.string(forKey: "KelompokPref")!
        }
        kelompokArray.remove(at: filteredRemoveIndex!)
        tableView.reloadData()
    }
    
}
