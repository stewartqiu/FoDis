//
//  AnggotaKelompok.swift
//  Project 1
//
//  Created by SchoolDroid on 12/18/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class AnggotaKelompok: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    @IBOutlet weak var anggotaKelompokTableView: UITableView!
    
    var kelompok = Kelompok()
    var anggotaArray = [Anggota]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        anggotaKelompokTableView.delegate = self
        anggotaKelompokTableView.dataSource = self
        anggotaKelompokTableView.allowsSelection = false
        anggotaKelompokTableView.tableFooterView = UIView(frame: .zero)
        
        navigationItem.title =  "Anggota " + kelompok.nama!
        
        loadAnggota()
        
        //print(kelompok.anggota!)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anggotaArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "anggotaKelompokCell") as! AnggotaKelompokCell
        cell.namaAnggotaLabel.text = anggotaArray[indexPath.row].namaAnggota
        return cell
    }
    
    func loadAnggota () {
        
        anggotaArray = AnggotaLite().getFiltered(key: AnggotaLite().idGrup, value: kelompok.id!)
        anggotaKelompokTableView.reloadData()
        
    }

}
