//
//  TulisArtikel.swift
//  Project 1
//
//  Created by SchoolDroid on 12/8/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher
import SimpleImageViewer
import FileBrowser

class DetailArtikel: UIViewController, UIDocumentPickerDelegate, UITextViewDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ArtikelBaruDelegate{
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var judulLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var penulisTanggalLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var inputHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var beritaCollectionView: UICollectionView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var jlhViewLabel: UILabel!
    @IBOutlet weak var jlhLikeLabel: UILabel!
    @IBOutlet weak var viewLikeView: UIView!
    @IBOutlet weak var shareBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var hiddenImageView: UIImageView!
    @IBOutlet weak var editBeritaBtn: UIButton!
    @IBOutlet weak var logoPensil: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    var judulString = String()
    var keywordString = String()
    var tanggalString = String()
    var action = String()
    var isNew = false
    
    var currentBerita = Berita()
    let cellId = "IsiBeritaCell"
    var isiBeritaArray = [IsiBerita]()
    var kelompok = Kelompok()
    var isTest = true
    
    var isPublish = false
    
    var viewArray = [ViewBerita]()
    var myViewData = ViewBerita()
    
    var myPeran = ""
    
    var persHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)!
    
    var pickedIsiBerita = IsiBerita()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SettingLite().getFiltered(keyfile: SettingKey.isTest)! == "0" {
            isTest = false
        } else {
            isTest = true
        }
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        handleInputView()
        handleCollectionView()
        handleKeyboard()
        
        shareButton.layer.cornerRadius = shareButton.frame.height/2
        shareButton.addTarget(self, action: #selector(shareArtikel), for: UIControlEvents.touchUpInside)
        
        kelompok = KelompokLite().getFiltered(key: KelompokLite().idKelompok_key, value: UserDefaults.standard.string(forKey: "KelompokPref")!)[0]
        
        setCurrentArtikel()
        
        if isPublish {
            saveView()
        }
        
    }
    

    @IBAction func likeBtnAction(_ sender: Any) {
    }
    
    // MARK: - OVERRIDE
    // ************************************************************************
    
    override func viewDidAppear(_ animated: Bool) {
        setCurrentArtikel()
        handleKeyboard()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == inputTextView {
            if inputTextView.contentSize.height < inputHeightConstraint.constant {
                inputTextView.isScrollEnabled = false
            }
            else {
                inputTextView.isScrollEnabled = true
            }
        }
        return true
    }
    
    func getEdit(judul: String, keyword: String, tanggal: String) {
        currentBerita.judul = judul
        currentBerita.kataKunci = keyword
        currentBerita.tanggal = tanggal
        
        let _ = BeritaLite().simpanData(idBerita: currentBerita.idBerita!, idGrup: currentBerita.idGrup!, judul: currentBerita.judul!, kataKunci: currentBerita.kataKunci!, created: currentBerita.created!, createdBy: currentBerita.createdBy!, publish: currentBerita.publish!, published: currentBerita.published!, tanggal: currentBerita.tanggal!, totLike: currentBerita.totLike!, totView: currentBerita.totView!, unpublished: currentBerita.unpublished!)
        
        setCurrentArtikel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditArtikel" {
            let destination = segue.destination as! UINavigationController
            let controller = destination.topViewController as! ArtikelBaru
            controller.isEdit = true
            controller.judulToEdit = currentBerita.judul!
            controller.keywordToEdit = currentBerita.kataKunci!
            controller.tanggalToEdit = currentBerita.tanggal!
            controller.delegate = self
        }
        else if segue.identifier == "toViewLikeList" {
            let destination = segue.destination as! ViewLikeList
            destination.berita = currentBerita
        } else if segue.identifier == "toEditIsi" {
            let destination = segue.destination as! UINavigationController
            let target = destination.topViewController as! EditIsiBerita
            target.currentIsiBerita = pickedIsiBerita
        } else if segue.identifier == "toSharePopUp" {
            let destination = segue.destination as! SharePopUp
            destination.beritaToShare = self.currentBerita
            destination.isiBeritaToShare = self.isiBeritaArray
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isiBeritaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IsiBeritaCell
        
        let isiAtIndex = isiBeritaArray[indexPath.row]
        
        if isiAtIndex.fileUrl!.isEmpty && isiAtIndex.foto!.isEmpty{
            let text = isiAtIndex.berita!
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
            cell.textView.text = text
            cell.textView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            cell.messageImageView.isHidden = true
        } else {
            
            if !isiAtIndex.foto!.isEmpty {
                
                if isiAtIndex.fileUrl! == "kertaskerja.gambarsampel" {
                    cell.messageImageView.image = #imageLiteral(resourceName: "KertasKerja")
                    cell.controller = self
                }
                else {
                    let url = URL(string: isiAtIndex.fileUrl!)
                    let placeholder = UIImage(named: "image")
                    cell.messageImageView.kf.setImage(with: url, placeholder: placeholder, completionHandler: {
                        (image, error, cacheType, imageUrl) in
                        cell.controller = self
                    })
                    cell.messageImageView.kf.indicatorType = .activity
                }
              
                
                cell.messageImageView.isHidden = false
                cell.textView.isHidden = true
                cell.bubbleView.backgroundColor = UIColor.clear
                cell.bubbleWidthAnchor?.constant = UIScreen.main.bounds.width / 2
                
            } else {
                cell.messageImageView.isHidden = true
            }
            
        }
        
        if currentBerita.publish != "T" {
            cell.controller1 = self
            cell.isiBerita = isiAtIndex
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let isiAtIndex = isiBeritaArray[indexPath.row]
        
        let width = UIScreen.main.bounds.width
        var height = CGFloat()
        
         if isiAtIndex.fileUrl!.isEmpty {
            height = estimateFrameForText(isiAtIndex.berita!).height + 20
         } else {
            height = UIScreen.main.bounds.width / 2
        }
        
        return CGSize(width: width, height: height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageURL = info[UIImagePickerControllerImageURL] as! NSURL
        print(imageURL)
        dismiss(animated: true, completion: nil)
        newIsiBerita(berita: "", foto: "\(Transformator.getNow(format: "ddMMyyyyHHmmssSSSS")).jpg", fileUrl: String(describing: imageURL))
        loadIsiBerita()
        scrollPalingBawah()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Handler/Config
    // ************************************************************************
    
    func handleInputView() {
        
        inputTextView.delegate = self
        
        inputTextView.layer.cornerRadius = inputTextView.frame.height / 3
        inputTextView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        

        sendView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendAction)))
        
        attachmentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAttachmentAlert)))
        
    }
    
    func handleCollectionView() {
        beritaCollectionView.delegate = self
        beritaCollectionView.dataSource = self
        beritaCollectionView.alwaysBounceVertical = true
        beritaCollectionView.keyboardDismissMode = .interactive
        beritaCollectionView.register(IsiBeritaCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func handleKeyboard (){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardShow (notification : NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]! as! CGRect
            
            let isKeyboardShow = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            if isKeyboardShow {
                navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissKeyboard))
                self.bottomConstraint.constant = keyboardFrame.height
                self.view.layoutIfNeeded()
            }
            else {
                navigationItem.leftBarButtonItem = nil
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func handleNavigationItem () {
        
        let containerView : UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        var labelText = ""
        
        if currentBerita.publish! == "T" {
            labelText = "BATALKAN"
             containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(batalkan)))
        } else {
            labelText = "TERBITKAN"
            containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(terbitkan)))
        }
        
        let labelTerbit : UILabel = {
            let label = UILabel()
            label.text = labelText
            label.textAlignment = .center
            label.font = label.font.withSize(10)
            label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
            label.textColor = UIColor(red: 0, green: 60/255, blue: 143/255, alpha: 1)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 0.7).cgColor
            label.layer.borderWidth = 0.5
            return label
        }()
        
        containerView.addSubview(labelTerbit)
        containerView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        labelTerbit.widthAnchor.constraint(equalToConstant: 70).isActive = true
        labelTerbit.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 3).isActive = true
        labelTerbit.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -3).isActive = true
        labelTerbit.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -3).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containerView)
        
    }
   
    
    // MARK: - ACTION
    // **************************************************************

    
    @objc func sendAction(){
        let message = inputTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if message.count > 0 {
            newIsiBerita(berita: message, foto: "", fileUrl: "")
            resizeInputTextView()
            inputTextView.text = ""
            loadIsiBerita()
            scrollPalingBawah()
        }
    }
    
    @objc func addAttachmentAlert () {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionKamera = UIAlertAction(title: "Kamera", style: .default) { (_) in
            STool.openKamera(sender: self, editable: false)
        }
        let actionFoto = UIAlertAction(title: "Pilih Foto", style: .default) { (_) in
            STool.openPhotoLibrary(sender: self, editable: false)
        }
        
        let actionDok = UIAlertAction(title: "Dokumen", style: .default) { (_) in
            STool.openDocumentPicker(sender: self)
        }
        
        // let action3 = UIAlertAction(title: "Audio", style: .default, handler: nil)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //alert.addAction(actionKamera)
        alert.addAction(actionFoto)
        //alert.addAction(actionDok)
        //alert.addAction(action3)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func shareArtikel () {
        performSegue(withIdentifier: "toSharePopUp", sender: self)
    }
    
    @objc func dismissKeyboard () {
        inputTextView.resignFirstResponder()
    }
    
    
    @objc func terbitkan (){
        
        let alert = UIAlertController(title: "Publikasikan Berita", message: "Anda tidak dapat melakukan penambahan/mengubah Isi Berita setelah berita diterbitkan.\n\nApakah Anda Yakin?", preferredStyle: .alert)
        let actionTidak = UIAlertAction(title: "TIDAK", style: .cancel, handler: nil)
        let actionOk = UIAlertAction(title: "OK", style: .default) { (_) in
            
            let now = Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss")
            
            self.currentBerita.created = now
            self.currentBerita.publish = "T"
            self.currentBerita.published = now
            
            Simpan.beritaData(isTest: self.isTest, negaraKel: self.kelompok.negara!, provKel: self.kelompok.provinsi!, kotaKel: self.kelompok.kota!, idBerita: self.currentBerita.idBerita!, idGrup: self.currentBerita.idGrup!, judul: self.currentBerita.judul!, kataKunci: self.currentBerita.kataKunci!, created: self.currentBerita.created!, createdBy: self.currentBerita.createdBy!, publish: self.currentBerita.publish!, published: self.currentBerita.published!, tanggal: self.currentBerita.tanggal!, totLike: "0", totView: "0", unpublished: "")
            
            
            
            for isiBerita in self.isiBeritaArray {
                if isiBerita.foto != nil && !isiBerita.foto!.isEmpty && isiBerita.foto! != "null" && isiBerita.foto! != "nil"{
                    
                    let url = URL(string: isiBerita.fileUrl!)
                    self.hiddenImageView.kf.setImage(with: url)
                    
                    SimpanNet().uploadFotoIsiBerita(negaraKel: self.kelompok.negara!, provKel: self.kelompok.provinsi!, kotaKel: self.kelompok.kota!, idKelompok: self.currentBerita.idGrup!, namaFoto: isiBerita.foto!, image: self.hiddenImageView.image!, url: { (url) in
                        Simpan.isiBerita(isTest: self.isTest, negara: self.kelompok.negara!, prov: self.kelompok.provinsi!, kota: self.kelompok.kota!, idGrup: self.currentBerita.idGrup!, idBerita: isiBerita.idBerita!, idIsi: isiBerita.idIsi!, berita: isiBerita.berita!, fileUrl: url, foto: isiBerita.foto!)
                    })
                    
                } else {
                    Simpan.isiBerita(isTest: self.isTest, negara: self.kelompok.negara!, prov: self.kelompok.provinsi!, kota: self.kelompok.kota!, idGrup: self.currentBerita.idGrup!, idBerita: isiBerita.idBerita!, idIsi: isiBerita.idIsi!, berita: isiBerita.berita!, fileUrl: isiBerita.fileUrl!, foto: isiBerita.foto!)
                }
            }
            
            self.setCurrentArtikel()
            self.updateBeritaAkhir()
            self.updateStatistikGrupList()
            self.saveView()
            
        }
        alert.addAction(actionTidak); alert.addAction(actionOk)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func batalkan(){
        let alert = UIAlertController(title: "Pembatalan Publikasi", message: "Berita yang sudah dibatalkan, tidak dapat ditampilkan kembali.\n\nApakah Anda Yakin?", preferredStyle: .alert)
        let actionTidak = UIAlertAction(title: "TIDAK", style: .cancel, handler: nil)
        let actionOk = UIAlertAction(title: "OK", style: .default) { (_) in
            
            self.currentBerita.publish = "F"
            self.currentBerita.unpublished = Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss")
            
            Simpan.beritaData(isTest: self.isTest, negaraKel: self.kelompok.negara!, provKel: self.kelompok.provinsi!, kotaKel: self.kelompok.kota!, idBerita: self.currentBerita.idBerita!, idGrup: self.currentBerita.idGrup!, judul: self.currentBerita.judul!, kataKunci: self.currentBerita.kataKunci!, created: self.currentBerita.created!, createdBy: self.currentBerita.createdBy!, publish: self.currentBerita.publish!, published: self.currentBerita.published!, tanggal: self.currentBerita.tanggal!, totLike: self.currentBerita.totLike!, totView: self.currentBerita.totView!, unpublished: self.currentBerita.unpublished!)
            
            self.updateBeritaAkhir()
            self.updateStatistikGrupList()

            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(actionTidak); alert.addAction(actionOk)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func toViewLikeList (){
        performSegue(withIdentifier: "toViewLikeList", sender: self)
    }
    
    @objc func likeBerita (){
        myViewData.like = "T"
        myViewData.tglLike = Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss")
        Simpan.viewBerita(isTest: isTest, negaraKel: kelompok.negara!, provKel: kelompok.provinsi!, kotaKel: kelompok.kota!, idGrup: kelompok.id!, idBerita: myViewData.idBerita!, idView: myViewData.idView!, hpAnggota: myViewData.hpAnggota!, like: myViewData.like!, tglLike: myViewData.tglLike!, tglView: myViewData.tglView!)
        
        let currentTotLike = Int(currentBerita.totLike!)!
        currentBerita.totLike = String(currentTotLike + 1)
        
        Simpan.beritaData(isTest: isTest, negaraKel: kelompok.negara!, provKel: kelompok.provinsi!, kotaKel: kelompok.kota!, idBerita: currentBerita.idBerita!, idGrup: currentBerita.idGrup!, judul: currentBerita.judul!, kataKunci: currentBerita.kataKunci!, created: currentBerita.created!, createdBy: currentBerita.createdBy!, publish: currentBerita.publish!, published: currentBerita.published!, tanggal: currentBerita.tanggal!, totLike: currentBerita.totLike!, totView: currentBerita.totView!, unpublished: currentBerita.unpublished!)
        
        loadLikeViewData()
    }
    
    @objc func unlikeBerita(){
        
        myViewData.like = "F"
        myViewData.tglLike = ""
        Simpan.viewBerita(isTest: isTest, negaraKel: kelompok.negara!, provKel: kelompok.provinsi!, kotaKel: kelompok.kota!, idGrup: kelompok.id!, idBerita: myViewData.idBerita!, idView: myViewData.idView!, hpAnggota: myViewData.hpAnggota!, like: myViewData.like!, tglLike: myViewData.tglLike!, tglView: myViewData.tglView!)
        
        let currentTotLike = Int(currentBerita.totLike!)!
        currentBerita.totLike = String(currentTotLike - 1)
        
        Simpan.beritaData(isTest: isTest, negaraKel: kelompok.negara!, provKel: kelompok.provinsi!, kotaKel: kelompok.kota!, idBerita: currentBerita.idBerita!, idGrup: currentBerita.idGrup!, judul: currentBerita.judul!, kataKunci: currentBerita.kataKunci!, created: currentBerita.created!, createdBy: currentBerita.createdBy!, publish: currentBerita.publish!, published: currentBerita.published!, tanggal: currentBerita.tanggal!, totLike: currentBerita.totLike!, totView: currentBerita.totView!, unpublished: currentBerita.unpublished!)
        
        loadLikeViewData()
    }
    
    
    // MARK: - FUNCTION
    // **************************************************************
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: UIScreen.main.bounds.width - 46, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    func resizeInputTextView () {
        inputTextView.text = " "
        inputTextView.isScrollEnabled = false
    }

    
    func setCurrentArtikel() {
        let creatorId = currentBerita.createdBy!
        
        let anggota = AnggotaLite().getFiltered(key: AnggotaLite().hpAnggota, value: creatorId)
        
        var namaPembuat = ""
        
        if anggota.count > 0 {
            namaPembuat = anggota[0].namaAnggota!
        } else {
            namaPembuat = creatorId
        }
        
        judulLabel.text = currentBerita.judul!
        keywordLabel.text = currentBerita.kataKunci!
        penulisTanggalLabel.text = "\(creatorId) \(currentBerita.tanggal!)"
        jlhViewLabel.text = currentBerita.totView!
        jlhLikeLabel.text = currentBerita.totLike!
        
        if currentBerita.publish == "T" {
            isPublish = true
            editBeritaBtn.isHidden = true
            logoPensil.isHidden = true
            shareBtnHeight.constant = 25
            viewLikeView.isHidden = false
            viewLikeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toViewLikeList)))
            loadLikeViewData()
            inputContainerView.isHidden = true
            likeBtn.isHidden = false
        } else {
            isPublish = false
            shareBtnHeight.constant = 0
            viewLikeView.isHidden = true
            inputContainerView.isHidden = false
            likeBtn.isHidden = true
        }
        
        setPermission()
        loadIsiBerita()
    
    }
    
    func loadIsiBerita (){
        isiBeritaArray = IsiBeritaLite().getFiltered(key: IsiBeritaLite().idBerita_key, value: currentBerita.idBerita!)
        beritaCollectionView.reloadData()
    }
    
    func newIsiBerita (berita : String , foto : String , fileUrl : String) {
    
        let idBerita = currentBerita.idBerita!
        
        var urutTerbesar = 0
        
        for isiBerita in isiBeritaArray {
            
            let urut = Int(isiBerita.idIsi!.suffix(3))!
            
            if urut > urutTerbesar {
                urutTerbesar = urut
            }
            
        }
        
        let urut = "0000\(urutTerbesar+1)"
        let newIdIsi = idBerita + urut.suffix(3)
        
        print(newIdIsi)
        let _ = IsiBeritaLite().simpanData(idIsi: newIdIsi, idBerita: idBerita, berita: berita, foto: foto, fileUrl: fileUrl)
        
    }

    func zoomImageView(imageView: UIImageView) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageView
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        self.present(imageViewerController, animated: true)
    }
    
    
    
    func longPressBubble (isiBerita : IsiBerita) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let hapusAction = UIAlertAction(title: "Hapus", style: .default) { (_) in
            let _ = IsiBeritaLite().deleteData(idIsi: isiBerita.idIsi!)
            alert.dismiss(animated: true, completion: nil)
            self.loadIsiBerita()
        }
        let editAction = UIAlertAction(title: "Sunting", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            self.pickedIsiBerita = isiBerita
            self.showEditBerita()
        }
        alert.addAction(batalAction)
        alert.addAction(hapusAction)
        if isiBerita.fileUrl == nil || isiBerita.fileUrl == "" {
            alert.addAction(editAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showEditBerita () {
//        NotificationCenter.default.addObserver(forName: .SelesaiEdit, object: nil, queue: nil) { (_) in
//            self.loadIsiBerita()
//        }
        performSegue(withIdentifier: "toEditIsi", sender: self)
    }
    
    func saveView() {
        
        viewArray = ViewBeritaLite().getFiltered(key: ViewBeritaLite().idBerita_key, value: currentBerita.idBerita!)
        
        var isViewed = false
        var urutTerbesar = 0
    
        for view in viewArray {
            
            let urut = Int(view.idView!.suffix(4))!
            if urut > urutTerbesar {
                urutTerbesar = urut
            }
            
            if view.hpAnggota == persHp{
                isViewed = true
            }
        }
        
        if !isViewed {
            
            let urut = "0000\(urutTerbesar+1)"
            let idView = "\(currentBerita.idBerita!)\(urut.suffix(4))"
            
            Simpan.viewBerita(isTest: isTest, negaraKel: kelompok.negara!, provKel: kelompok.provinsi!, kotaKel: kelompok.kota!, idGrup: kelompok.id!, idBerita: currentBerita.idBerita!, idView: idView, hpAnggota: persHp, like: "F", tglLike: "", tglView: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
            
            let currentTotView = Int(currentBerita.totView!)!
            currentBerita.totView = String(currentTotView + 1)
            
            Simpan.beritaData(isTest: isTest, negaraKel: kelompok.negara!, provKel: kelompok.provinsi!, kotaKel: kelompok.kota!, idBerita: currentBerita.idBerita!, idGrup: kelompok.id!, judul: currentBerita.judul!, kataKunci: currentBerita.kataKunci!, created: currentBerita.created!, createdBy: currentBerita.createdBy!, publish: currentBerita.publish!, published: currentBerita.published!, tanggal: currentBerita.tanggal!, totLike: currentBerita.totLike!, totView: currentBerita.totView!, unpublished: currentBerita.unpublished!)
            
        }
        
        loadLikeViewData()
        
    }
    
    func loadLikeViewData() {
        
        viewArray = ViewBeritaLite().getFiltered(key: ViewBeritaLite().idBerita_key, value: currentBerita.idBerita!)
        
        let jumlahView = viewArray.count
        var jumlahLike = 0
        
        var isLiked = false
        
        for view in viewArray {
            if view.like == "T" {
                jumlahLike += 1
            }
            
            if view.hpAnggota == persHp{
                if view.like! == "T"{
                    isLiked = true
                } else {
                    isLiked = false
                }
                myViewData = view
            }
            
        }
        
        if isLiked{
            likeBtn.setImage(#imageLiteral(resourceName: "like_button"), for: .normal)
            likeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unlikeBerita)))
        } else {
            likeBtn.setImage(#imageLiteral(resourceName: "not_like_button"), for: .normal)
            likeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeBerita)))
        }
        
        jlhViewLabel.text = "\(jumlahView)"
        jlhLikeLabel.text = "\(jumlahLike)"
        
    }
    
    func updateBeritaAkhir() {
        
        let beritaArray = BeritaLite().getFiltered(key: BeritaLite().idKelompok_key, value: kelompok.id!)
        
        var lastPublishedBerita = ""
        
        for berita in beritaArray {
            if berita.publish == "T" {
                lastPublishedBerita = berita.idBerita!
            }
        }
        
        Simpan.updateBeritaAkhir(isTest: isTest, negara: kelompok.negara!, prov: kelompok.provinsi!, kota: kelompok.kota!, idGrup: kelompok.id!, idBerita: lastPublishedBerita)
        
    }
    
    func updateStatistikGrupList(){
        let beritaArray = BeritaLite().getFiltered(key: BeritaLite().idKelompok_key, value: kelompok.id!)
        var jumlahBerita = 0
        for berita in beritaArray {
            if berita.publish == "T" {
                jumlahBerita += 1
            }
        }
        SimpanNet().statistikGrupList(negara: self.kelompok.negara!, prov: self.kelompok.provinsi!, kota: self.kelompok.kota!, idGrup: self.kelompok.id!, namaGrup: self.kelompok.nama!, jumlahAnggota: self.kelompok.jumlahAnggota!, jumlahBerita: "\(jumlahBerita)")
    }
    
    func setPermission(){
        if myPeran == PeranAnggota.ketua {
            handleNavigationItem()
        } else if myPeran == PeranAnggota.admin && currentBerita.createdBy == persHp {
            handleNavigationItem()
        }
    }
    
    func scrollPalingBawah () {
        if isiBeritaArray.count > 0 {
            let indexPath = IndexPath(item: self.isiBeritaArray.count - 1, section: 0)
            beritaCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}
