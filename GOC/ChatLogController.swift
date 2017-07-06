//
//  ChatLogController.swift
//  GOC
//
//  Created by Avnish Kumar on 03/07/17.
//  Copyright © 2017 SapeanIT. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ChatLogController: UICollectionViewController,UITextFieldDelegate ,UICollectionViewDelegateFlowLayout{
    let cellid = "cellId"
    
    var user:User?
    {
       didSet
       {
        self.navigationItem.title=user?.name
        self.observeMessages()
        }
        
    }
    lazy var inputTextField : UITextField = {
        
        let textField = UITextField ()
        
        
        textField.translatesAutoresizingMaskIntoConstraints=false
        textField.backgroundColor = UIColor.clear
        textField.placeholder="enter message"
        textField.delegate=self
        return textField

        
    }()
   lazy var inputContainerView : UIView = {
        
        let containerView = UIView()
        
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor=UIColor.white
    
  // self.inputTextField.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)

    
    containerView.addSubview(self.inputTextField)
    
    self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive=true
    self.inputTextField.bottomAnchor.constraint(equalTo: (containerView.bottomAnchor)).isActive=true
    self.inputTextField.widthAnchor.constraint(equalToConstant: 180).isActive=true
    self.inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive=true
    
        let sendButton = UIButton(type: .system)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints=false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
    
        sendButton.rightAnchor.constraint(equalTo:(containerView.rightAnchor), constant: -8).isActive=true
        sendButton.centerYAnchor.constraint(equalTo: (containerView.centerYAnchor)).isActive=true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive=true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
    
    

    
    

    
        let sepratorLine = UIView ()
        containerView.addSubview(sepratorLine)
        sepratorLine.translatesAutoresizingMaskIntoConstraints=false
        sepratorLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        sepratorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive=true
        sepratorLine.topAnchor.constraint(equalTo: (containerView.topAnchor)).isActive=true
        sepratorLine.widthAnchor.constraint(equalToConstant: containerView.frame.size.width).isActive=true
        sepratorLine.heightAnchor.constraint(equalToConstant: 1).isActive=true
        

        return containerView
        
    }()
    
    override var inputAccessoryView: UIView?{
        get{
            return inputContainerView
            
        }
        
    }
    override var canBecomeFirstResponder: Bool { return true }
    
    func setupKeyboardObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlleKeyboardShowNotification(notification: )), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlleKeyboardHideNotification(notification: )), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handlleKeyboardShowNotification(notification:Notification)
    {
        
        
    }
    
    func handlleKeyboardHideNotification(notification:Notification)
    {
        
        
        
    }

    override func viewDidLoad() {
        
        super .viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)

        collectionView?.backgroundColor=UIColor.white
        collectionView?.alwaysBounceVertical=true
        //setupInputContaoner()
        collectionView?.keyboardDismissMode = .interactive
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(handleHide))
        collectionView?.register(ChatMessagesCell.self, forCellWithReuseIdentifier: cellid)
        
        
    }
    func handleHide() {
          self.view?.endEditing(true)
    }
    func setupInputContaoner()  {
        let containerView = UIView()
        
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints=false
        
        collectionView?.addSubview(containerView)
        //add constaints
        containerView.leftAnchor.constraint(equalTo:(view.leftAnchor)).isActive=true
        containerView.bottomAnchor.constraint(equalTo: (view.bottomAnchor)).isActive=true
        containerView.widthAnchor.constraint(equalTo: (view.widthAnchor)).isActive=true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        
      
        
        let sendButton = UIButton(type: .system)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints=false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo:(containerView.rightAnchor), constant: -8).isActive=true
        sendButton.centerYAnchor.constraint(equalTo: (containerView.centerYAnchor)).isActive=true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive=true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        
       
        
        let sepratorLine = UIView ()
        view.addSubview(sepratorLine)
        sepratorLine.translatesAutoresizingMaskIntoConstraints=false
        sepratorLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        sepratorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive=true
        sepratorLine.bottomAnchor.constraint(equalTo: (containerView.topAnchor)).isActive=true
        sepratorLine.widthAnchor.constraint(equalToConstant: 300).isActive=true
        sepratorLine.heightAnchor.constraint(equalToConstant: 1).isActive=true
        

        
    }
    
    func handleSend (){
        print(inputTextField.text!)
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef=ref.childByAutoId()
        let toID = user!.uid!
        let fromUId = FIRAuth.auth()!.currentUser!.uid
        let timestamp :Int  =  Int(Date.timeIntervalSinceReferenceDate)
        let values = ["text": inputTextField.text!,"toUid":toID,
                      "fromUid":fromUId,
                      "timestamp":timestamp] as [String : Any]
       // childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error ?? "")
            }
        }
        self.inputTextField.text=nil
        
        
        let childUserMesaageRef = FIRDatabase.database().reference().child("user-messages").child(fromUId)
        let messageID = childRef.key
        childUserMesaageRef.updateChildValues([messageID:1])
        
        let childRecipientMesaageRef = FIRDatabase.database().reference().child("user-messages").child(toID)
        childRecipientMesaageRef.updateChildValues([messageID:1])
        
        
    }
    
    var messages = [Message]()
    func observeMessages(){
        
      guard  let uid = FIRAuth.auth()?.currentUser?.uid else {
            return;
        }
        
    let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageRef = FIRDatabase.database().reference().child("messages").child(snapshot.key)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard  let dictionary = snapshot.value as? [String:AnyObject] else{
                    return;
                }
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                print(message.text!)
                
                print(message.recipientUid() ?? "")
                print(self.user?.uid ?? "")

             if message.recipientUid() == self.user?.uid {
                
                    
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView?.reloadData()
                    }

                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.collectionView?.endEditing(true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as? ChatMessagesCell
        let message = messages[indexPath.item]
        cell?.textfield.text=message.text
        
//        cell?.backgroundColor = UIColor.blue
        cell?.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width+40

      setupCell(cell: cell!, message: message)
        
        return cell!
    }
    func setupCell(cell: ChatMessagesCell,message :Message)
    {
        if let profileImageUrl = user?.profileImageUrl {
        cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        
        if message.fromUid != FIRAuth.auth()?.currentUser?.uid {
            
            
          cell.bubbleRightAnchor?.isActive = false
            cell.profileImageView.isHidden=false
            cell.bubbleLeftAnchor?.isActive = true
            cell.bubbleView.backgroundColor = UIColor(r:240, g:240, b:240)
            cell.textfield.textColor=UIColor.black
            
        }else{
           cell.profileImageView.isHidden=true
            cell.bubbleView.backgroundColor = UIColor(r: 0, g: 137, b: 240)
            cell.textfield.textColor=UIColor.white
                        cell.bubbleRightAnchor?.isActive = true
                        cell.bubbleLeftAnchor?.isActive = false
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       var height : CGFloat = 80
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height+20
        }

        return CGSize(width: self.view.frame.size.width, height: height)
    }
    private func estimateFrameForText(text:String)->CGRect {
        let size = CGSize(width: self.view.frame.size.width-120, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        //print(NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)], context: nil))
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)], context: nil)
    }
//    override func collectionView(_ collectionView: UICollectionView,
//                                 layout collectionViewLayout: UICollectionViewLayout,
//                                 sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        return CGSize(width: self.view.frame.size.width, height: 80)
//    }
    
    
}
