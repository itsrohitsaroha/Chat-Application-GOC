
import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "images")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
    }
    
  var messages = [Message]()
    var messageDictionary = [String:AnyObject]()

    
    func observeUserMessages()  {
        
      
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("user-messages").child(userID!)

        ref.observe(.childAdded, with: { (snapshot) in
            //print(snapshot.key)
             self.getMessageForSpecificUser(oppositionUserID: snapshot.key)
        }, withCancel: nil)
      
    }
    
    
    
    private func getMessageForSpecificUser (oppositionUserID:String)
   {
     let userID = FIRAuth.auth()?.currentUser?.uid
    
    
    FIRDatabase.database().reference().child("user-messages").child(userID!).child(oppositionUserID).observe(.childAdded, with: { (snapshot) in
        print(snapshot.key)
        
        
        let messageInfoRef = FIRDatabase.database().reference().child("messages").child(snapshot.key)
        messageInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // print(snapshot2)
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                let reciepientID:String?
                
                reciepientID = message.recipientUid()
                
                self.messageDictionary[reciepientID!] = message
                
                
                
                self.messages = Array(self.messageDictionary.values) as! [Message]
                
                self.filterAndReloadData()
                
                
                
            }
            
            
            
            
        }, withCancel: nil)
        
    }, withCancel: nil)
    
    
    
    }
    var timer :Timer?

    private func filterAndReloadData(){
        self.timer?.invalidate()
        self.timer  = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: false)
        

    }
    
    
   func handleTimer()
   {
    print("tesssst")
    self.messages.sort(by: { (message1, message2) -> Bool in
        return (message1.timestamp?.intValue)!>(message2.timestamp?.intValue)!
    })

    DispatchQueue.main.async(execute: {
        self.tableView.reloadData()
        
        
    })
    }
    
    func getAllUserMessages()
    {
        
        print("CllaedAgain")
        let ref = FIRDatabase.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                
                if let toUid = message.toUid
                {
                    
                    if toUid != FIRAuth.auth()?.currentUser?.uid
                    {
                        self.messageDictionary[toUid] = message

                    }
                    
                }
                
                self.messages = Array(self.messageDictionary.values) as! [Message]
                
                self.messages.sort(by: { (message1, message2) -> Bool in
                    return (message1.timestamp?.intValue)!>(message2.timestamp?.intValue)!
                })
                //self.messages.append(message)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
            
        }, withCancel: nil)
    }
    func handleNewMessage() {
       
        let newMessageController = NewMessageController()
        newMessageController.messagesController=self;
        // newMessageController.messagesController=self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
              //  let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        
        messages.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleView = UIView()
        
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        
       // self.navigationItem.titleView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    func showChatControllerWithUser(user:User) {
        
        let chatVC = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.user = user
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  self.messages.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        
        
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let message = messages[indexPath.row]
        
        let userid = message.recipientUid()
        
        let ref = FIRDatabase.database().reference().child("users").child(userid!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard  let dictionary = snapshot.value else{
                return
            }
            let user = User()
            user.uid=snapshot.key
            user.setValuesForKeys(dictionary as! [String : Any])
            self.showChatControllerWithUser(user: user )
        }, withCancel: nil)
        
        
       
        
    }
    
    
    
    
    
    
    
}
