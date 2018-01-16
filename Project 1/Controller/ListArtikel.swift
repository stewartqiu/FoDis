//
//  ListArtikel.swift
//  Project 1
//
//  Created by SchoolDroid on 12/9/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import DropDown

class ListArtikel: UIViewController , UITableViewDelegate , UITableViewDataSource , ArtikelBaruDelegate{
    
    let kelompokPref = UserDefaults.standard.string(forKey: "KelompokPref")!
    var kelompok = Kelompok()
    
    var beritaArray = [Berita]()
    var filteredBerita = [Berita]()
    var selectedBerita = Berita()
    
    var judulReturn : String?
    var keywordReturn : String?
    var tanggalReturn : String?
    
    let dropDown = DropDown()
    
    var keywordArray = [String]()
    
    var isFiltering = false
    
    @IBOutlet weak var artikelTableView: UITableView!
    @IBOutlet weak var keywordView: UIView!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var jumlahBeritaLabel: UILabel!
    @IBOutlet weak var dropDownContainer: UIView!
    
    var anggotaArray = [Anggota]()
    
    var isTest = true
    
    var peran = ""
    
    let persHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SettingLite().getFiltered(keyfile: SettingKey.isTest)! == "0" {
            isTest = false
        } else {
            isTest = true
        }
        
        loadData()
        cekPeran()
        
        configKeywordView()
        
        artikelTableView.delegate = self
        artikelTableView.dataSource = self
        artikelTableView.tableFooterView = UIView(frame: .zero)
        
        navigationViewHandler()
        dropDownHandler()
        
        print(kelompokPref)
        
    }
    
    
    // MARK: - OVERRIDE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredBerita.count
        } else {
            return beritaArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListArtikelCell") as! ArtikelCell
        
        var artikelAtIndex = Berita()
        
        if isFiltering {
            artikelAtIndex = filteredBerita[indexPath.row]
        } else {
            artikelAtIndex = beritaArray[indexPath.row]
        }
        
        if artikelAtIndex.unpublished == nil || artikelAtIndex.unpublished!.isEmpty{
        
            cell.judulLabel.text = artikelAtIndex.judul
            cell.keywordLabel.text = artikelAtIndex.kataKunci
            cell.tanggalLabel.text = artikelAtIndex.tanggal
            cell.jlhViewLabel.text = artikelAtIndex.totView
            cell.jlhLikeLabel.text = artikelAtIndex.totLike
            if artikelAtIndex.publish == "" {
                cell.belumTerbitLabel.isHidden = false
                cell.viewlikeView.isHidden = true
            } else {
                cell.belumTerbitLabel.isHidden = true
                cell.viewlikeView.isHidden = false
            }
        
            let listIsi = IsiBeritaLite().getFiltered(key: IsiBeritaLite().idBerita_key, value: artikelAtIndex.idBerita!)
        
            var jumlahFoto = 0
            var jumlahFile = 0
            var lastFotoUrl = ""
            var firstBerita = ""
        
            for isi in listIsi {
                if isi.foto != nil && !isi.foto!.isEmpty && isi.foto! != "null" && isi.foto! != "nil"{
                    jumlahFoto = jumlahFoto + 1
                    if lastFotoUrl.isEmpty{
                        lastFotoUrl = isi.fileUrl!
                    }
                }
                if isi.berita != nil && !isi.berita!.isEmpty{
                    if firstBerita.isEmpty {
                        firstBerita = isi.berita!
                    }
                }
            }
        
            if lastFotoUrl != "" {
                let url = URL(string: lastFotoUrl)
                cell.imageLampiran.kf.indicatorType = .activity
                cell.imageLampiran.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "image"))
            } else {
                cell.imageLampiran.image = #imageLiteral(resourceName: "image")
            }
        
            if firstBerita != ""{
                cell.isiLabel.text = firstBerita
            } else {
                cell.isiLabel.text = "... Selengkapnya"
            }
            
            let filterPembuat = AnggotaLite().getFiltered(key: AnggotaLite().hpAnggota, value: artikelAtIndex.createdBy!)
            
            var pembuat = ""
            if filterPembuat.count > 0 {
                pembuat = filterPembuat[0].namaAnggota!
            } else {
                pembuat = artikelAtIndex.createdBy!
            }
            
            cell.lampiranPenulisLabel.text = "[Lampiran : \(jumlahFoto) foto 0 file] \(pembuat)"
            
            let viewArray = ViewBeritaLite().getFiltered(key: ViewBeritaLite().idBerita_key, value: artikelAtIndex.idBerita!)
            
            let jumlahView = viewArray.count
            var jumlahLike = 0
            
            for view in viewArray {
                if view.like == "T" {
                    jumlahLike += 1
                }
            }
            
            cell.jlhViewLabel.text = "\(jumlahView)"
            cell.jlhLikeLabel.text = "\(jumlahLike)"
            
        }
        else {
            cell.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var artikelAtIndex = Berita()
        
        if isFiltering {
            artikelAtIndex = filteredBerita[indexPath.row]
        } else {
            artikelAtIndex = beritaArray[indexPath.row]
        }
        
        if artikelAtIndex.unpublished == nil || artikelAtIndex.unpublished!.isEmpty{
            return 90
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering {
            selectedBerita = filteredBerita[indexPath.row]
        } else {
            selectedBerita = beritaArray[indexPath.row]
        }
        performSegue(withIdentifier: "toDetailArtikel", sender: self)
    }
    
    func getReturn(judul: String, keyword: String, tanggal: String) {
        
        let idGrup = UserDefaults.standard.string(forKey: "KelompokPref")!
        let persHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)!
        
        var urutTerbesar = 0
        
        for berita in beritaArray {
            let urut = Int(berita.idBerita!.suffix(6))!
            if urut > urutTerbesar {
                urutTerbesar = urut
            }
        }
        
        let urut = "000000\(urutTerbesar+1)"
        
        let idBerita = "\(idGrup)\(urut.suffix(6))"
        let tanggalWaktu = Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss")
        
        let berita = Berita()
        berita.idBerita = idBerita
        berita.idGrup = idGrup
        berita.judul = judul
        berita.kataKunci = keyword
        berita.created = tanggalWaktu
        berita.createdBy = persHp
        berita.publish = ""
        berita.published = ""
        berita.tanggal = tanggal
        berita.totLike = "0"
        berita.totView = "0"
        berita.unpublished = ""
        
        let _ = BeritaLite().simpanData(idBerita: berita.idBerita!, idGrup: berita.idGrup!, judul: berita.judul!, kataKunci: berita.kataKunci!, created: berita.created!, createdBy: berita.createdBy!, publish: berita.publish!, published: berita.published!, tanggal: berita.tanggal!, totLike: berita.totLike!, totView: berita.totView!, unpublished: berita.unpublished!)
        
        selectedBerita = berita
        
        performSegue(withIdentifier: "toDetailArtikel", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newArtikel" {
            let destination = segue.destination as! UINavigationController
            let target = destination.topViewController as! ArtikelBaru
            target.delegate = self
        } else if segue.identifier == "toDetailArtikel" {
            let destination = segue.destination as! DetailArtikel
            destination.currentBerita = selectedBerita
            destination.myPeran = peran
        } else if segue.identifier == "toGrupInfo" {
            let destination = segue.destination as! BuatKelompokController
            let kelompok = KelompokLite().getFiltered(key: KelompokLite().idKelompok_key, value: kelompokPref)[0]
            destination.kelompokToEdit = kelompok
            destination.isEdit = true
        }
    }
    
     // MARK: - ACTION
    
    @objc func grupInfo () {
        performSegue(withIdentifier: "toGrupInfo", sender: self)
    }
    
    @objc func toNewArtikel(){
        performSegue(withIdentifier: "newArtikel", sender: self)
    }
    
    
    // MARK: - FUNCTION
    
    func configKeywordView(){
        keywordView.layer.cornerRadius = keywordView.frame.height / 2
    }
    
    func dropDownHandler () {
        dropDown.anchorView = dropDownContainer
        dropDown.backgroundColor = UIColor(red: 2/255, green: 91/255, blue: 145/255, alpha: 1)
        dropDown.textColor = UIColor.white
        dropDown.dataSource = keywordArray
        dropDown.selectionBackgroundColor = UIColor.clear
        
        dropDownContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDropDown)))
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.keywordLabel.text = item
            self.filteredBerita.removeAll()
            if index != 0 {
                self.isFiltering = true
                
                self.filteredBerita = self.beritaArray.filter({ (berita) -> Bool in
                    return berita.kataKunci!.lowercased().contains(item.lowercased())
                })
                
            } else {
                self.isFiltering = false
            }
            
            self.sortArrayBerita()
            
            self.artikelTableView.reloadData()
            
        }
    }
    
    @objc func showDropDown() {
        dropDown.show()
    }
    
    func loadData() {
        
        kelompok = KelompokLite().getFiltered(key: KelompokLite().idKelompok_key, value: kelompokPref)[0]
        
        anggotaArray = AnggotaLite().getFiltered(key: AnggotaLite().idGrup, value: kelompokPref)
        
        beritaArray = BeritaLite().getFiltered(key: BeritaLite().idKelompok_key, value: kelompokPref)
        setJumlahBeritaLabel()
        loadKeyword()
        sortArrayBerita()
        artikelTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dropDown.selectRow(0)
        isFiltering = false
        keywordLabel.text = "KATA KUNCI ---"
        loadData()
        navigationViewHandler()
    }
    
    func setJumlahBeritaLabel () {
        
        var jumlahBerita = 0
        
        for berita in beritaArray {
            if berita.unpublished == nil || berita.unpublished!.isEmpty{
                jumlahBerita += 1
            }
        }
        
        jumlahBeritaLabel.text = "Daftar Berita (\(jumlahBerita))"
    }
    
    func loadKeyword () {
        
        keywordArray.removeAll()
        keywordArray.append("KATA KUNCI ---")
        
        for berita in beritaArray {
            if berita.unpublished == nil || berita.unpublished!.isEmpty {
                let kataKunciRaw = berita.kataKunci
                if let pisah = kataKunciRaw?.split(separator: " ") {
                    for kataKunciFix in pisah {
                        if !keywordArray.contains(String(kataKunciFix)) {
                            keywordArray.append(String(kataKunciFix))
                        }
                    }
                }
            }
            
        }
    }
    
    func navigationViewHandler(){
        
        let navBar = self.navigationController!.navigationBar
        
        let titleLabel : UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 120, height: navBar.frame.height*2/3))
            label.text = kelompok.nama
            label.font = label.font.withSize(18)
            label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
            label.textColor = UIColor.white
            return label
        }()
        
        let descLabel : UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: navBar.frame.height * 1.7/3, width: view.frame.width - 120, height: navBar.frame.height/3))
            label.text = "Klik disini untuk informasi grup"
            label.font = label.font.withSize(10)
            label.textColor = UIColor.white
            return label
        }()
        
        let viewContainer = UIView(frame: CGRect(x: 0, y: 0, width: navBar.frame.width, height: navBar.frame.height))
        viewContainer.addSubview(titleLabel)
        viewContainer.addSubview(descLabel)
        viewContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(grupInfo)))
        navigationItem.titleView = viewContainer
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            
            var text = ""
            for anggota in self.anggotaArray {
                text = "\(text)\(anggota.namaAnggota!), "
            }

            descLabel.text = String(String(text.dropLast()).dropLast())
            
        })
       
        // navigationItem.title = namaKelompok
    }
    
    func cekPeran () {
        for anggota in anggotaArray {
            if anggota.hpAnggota! == persHp {
                peran = Transformator.cekPeranAnggota(permission: anggota.permission!)
            }
        }
        
        if peran == PeranAnggota.ketua || peran == PeranAnggota.admin {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(toNewArtikel))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func sortArrayBerita(){
        
        beritaArray.sort { (berita1, berita2) -> Bool in
            let split1 = berita1.tanggal!.split(separator: "-")
            let tanggal1 = split1[0]
            let bulan1 = split1[1]
            let tahun1 = split1[2]
            let gabung1 = "\(tahun1)\(bulan1)\(tanggal1)"
            
            let split2 = berita2.tanggal!.split(separator: "-")
            let tanggal2 = split2[0]
            let bulan2 = split2[1]
            let tahun2 = split2[2]
            let gabung2 = "\(tahun2)\(bulan2)\(tanggal2)"
            
            return gabung2 < gabung1
            
        }
        
    }
    
}




