//
//  ViewLikeList.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 1/13/18.
//  Copyright © 2018 SchoolDroid. All rights reserved.
//

import UIKit

class ViewLikeList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var berita = Berita()
    var viewBerita = [ViewBerita]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewBerita.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "anggotaKelompokCell") as! AnggotaKelompokCell
        
        let viewAtIndex = viewBerita[indexPath.row]
        let anggotaAtIndex = AnggotaLite().getFiltered(key: AnggotaLite().hpAnggota, value: viewAtIndex.hpAnggota!)
        
        if anggotaAtIndex.count > 0 {
            let namaAnggota = anggotaAtIndex[0].namaAnggota!
            let fotoAnggota = anggotaAtIndex[0].pathFoto!
    
            cell.namaAnggotaLabel.text = namaAnggota
        
            if !anggotaAtIndex[0].pathFoto!.isEmpty && anggotaAtIndex[0].pathFoto! != "null" {
                cell.anggotaImage.kf.indicatorType = .activity
                cell.anggotaImage.kf.setImage(with: URL(string: fotoAnggota), placeholder: #imageLiteral(resourceName: "kontak"))
            }
        } else {
            cell.namaAnggotaLabel.text = viewAtIndex.hpAnggota!
            cell.anggotaImage.image = #imageLiteral(resourceName: "kontak")
        }
        
        cell.viewImage.isHidden = false
        
        if viewAtIndex.like == "T"{
            cell.likeImage.isHidden = false
        } else {
             cell.likeImage.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    
    
    //MARK:- FUNC
    
    func loadData(){
        
        viewBerita = ViewBeritaLite().getFiltered(key: ViewBeritaLite().idBerita_key, value: berita.idBerita!)
        tableView.reloadData()
        
    }

}
