//
//  ChatMessagesCell.swift
//  GOC
//
//  Created by Avnish Kumar on 04/07/17.
//  Copyright © 2017 SapeanIT. All rights reserved.
//

import UIKit

class ChatMessagesCell: UICollectionViewCell {


    let textfield : UITextView = {
        let textField = UITextView()
        
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.backgroundColor=UIColor.clear
textField.isUserInteractionEnabled=false
        textField.translatesAutoresizingMaskIntoConstraints=false
       return textField
        
    }()
    let bubbleView : UIView={
        let bv = UIView()
        bv.backgroundColor=UIColor(r: 0, g: 137, b: 240)
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds=true
        
        bv.translatesAutoresizingMaskIntoConstraints=false
        return bv
    }()
    
    let profileImageView : UIImageView={
        let bv = UIImageView()
      //  bv.backgroundColor=UIColor(r: 0, g: 137, b: 240)
        
        //bv.image=UIImage(named: "")
        bv.contentMode = .scaleAspectFill
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds=true
        bv.clipsToBounds = true
        bv.translatesAutoresizingMaskIntoConstraints=false
        return bv
    }()
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleRightAnchor : NSLayoutConstraint?
    var bubbleLeftAnchor : NSLayoutConstraint?


  override init(frame:CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.white
     self.addSubview(profileImageView)
    self.addSubview(bubbleView)
    self.addSubview(textfield)
   
    
    
    profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true

    
   bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
    bubbleRightAnchor?.isActive = true
    bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
  bubbleLeftAnchor =  bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: +8)
    bubbleLeftAnchor?.isActive = false

    bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
    bubbleWidthAnchor?.isActive = true
    bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    
    textfield.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
    textfield.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
    //textfield.widthAnchor.constraint(equalToConstant: 200).isActive = true
    textfield.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive=true
    textfield.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
    //textfield.heightAnchor.constraint(equalToConstant: 80).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
