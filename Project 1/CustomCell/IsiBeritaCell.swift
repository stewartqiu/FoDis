//
//  IsiBeritaCell.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 12/21/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class IsiBeritaCell: UICollectionViewCell {
    
    static let exText = "SAMPLE TEXT"
    
    var controller: DetailArtikel?
    var controller1: DetailArtikel?
    var isiBerita: IsiBerita?
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.text = IsiBeritaCell.exText
        tv.isSelectable = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = true
        tv.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressBubble(longGesture:))))
        return tv
    }()
    
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomTap)))
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressBubble(longGesture:))))
        //imageView.backgroundColor = UIColor.darkGray
        return imageView
    }()
    
    
    let fileView : UIView = {
       
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        return containerView
    }()
    
    let iconFile : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "txt")
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    } ()
    
    let labelFile : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.font = label.font.withSize(15)
        label.text = "Judul file.txt"
        return label
    }()
    
    let downloadImage : UIImageView = {
        let downloadImage = UIImageView()
        downloadImage.translatesAutoresizingMaskIntoConstraints = false
        downloadImage.layer.masksToBounds = true
        downloadImage.image = #imageLiteral(resourceName: "download_black")
        downloadImage.backgroundColor = UIColor.clear
        downloadImage.contentMode = .scaleAspectFit
        downloadImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        downloadImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return downloadImage
    }()
    
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
      
        
        addSubview(bubbleView)
        addSubview(textView)
        
       // addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -15)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15)
        bubbleViewLeftAnchor?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //ios 9 constraints
        //x,y,w,h
        //        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        //        textView.widthAnchor.constraintEqualToConstant(200).active = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
        addSubview(fileView)
        
        fileView.addSubview(iconFile)
        fileView.addSubview(labelFile)
        fileView.addSubview(downloadImage)
        
        iconFile.leftAnchor.constraint(equalTo: fileView.leftAnchor, constant: 10).isActive = true
        iconFile.centerYAnchor.constraint(equalTo: fileView.centerYAnchor).isActive = true
        
        downloadImage.centerYAnchor.constraint(equalTo: fileView.centerYAnchor).isActive = true
        downloadImage.rightAnchor.constraint(equalTo: fileView.rightAnchor, constant: -10).isActive = true
        
        labelFile.topAnchor.constraint(equalTo: fileView.topAnchor, constant: 10).isActive = true
        labelFile.bottomAnchor.constraint(equalTo: fileView.bottomAnchor, constant: -10).isActive = true
        labelFile.rightAnchor.constraint(equalTo: downloadImage.leftAnchor, constant: -10).isActive = true
        labelFile.leftAnchor.constraint(equalTo: iconFile.rightAnchor, constant: 10).isActive = true
        
        
        fileView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        fileView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        fileView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        fileView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    @objc func zoomTap (tapgesture: UITapGestureRecognizer) {
        controller?.zoomImageView(imageView: messageImageView)
    }
    
    @objc func longPressBubble (longGesture: UILongPressGestureRecognizer) {
        if longGesture.state == .began{
            controller1?.longPressBubble(isiBerita: isiBerita!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
