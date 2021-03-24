//
//  ChatViewController.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/20/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import ChameleonFramework
import Snail

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var messageArray: [Message] = [Message] ()
    var sendMessageButton = PillButton(text: "Send",
                                       color: .black,
                                       textColor: .white,
                                       radius: 15,
                                       hasBorder: true,
                                       hasShadow: false,
                                       borderWidth: 1,
                                       borderColor: .white)
    var messageTextfield = UITextField()
    var messageTableView = UITableView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Chat Room"

        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        messageTextfield.tintColor = .black
        messageTextfield.delegate = self
        messageTextfield.textColor = .black
        messageTextfield.placeholder = "Send a Message"
        messageTextfield.borderStyle = .roundedRect
        messageTextfield.clearButtonMode = .whileEditing
        messageTextfield.delegate = self
        messageTextfield.autocorrectionType = .no
        messageTextfield.keyboardType = .default
        messageTextfield.returnKeyType = .done
        messageTextfield.autocapitalizationType = .none

        view.addSubview(messageTextfield) { make in
            make.left.equalTo(view.safeArea).inset(12)
            make.right.equalTo(view.safeArea).inset(72)
            make.bottom.equalTo(view.safeArea)
        }

        let sendButton = sendMessageButton
        sendButton.isUserInteractionEnabled = true
        sendButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        view.addSubview(sendButton) { make in
            make.left.equalTo(messageTextfield.snp.right).offset(4)
            make.centerY.equalTo(messageTextfield.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(64)
        }

        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.backgroundColor = .white
        messageTableView.separatorStyle = .none
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
        messageTableView.register(cell: CustomeMessageCell.self)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        view.addSubview(messageTableView) { make in
            make.top.equalTo(view.safeArea)
            make.bottom.equalTo(messageTextfield.snp.top)
            make.left.right.equalTo(view.safeArea)
        }

        setupBindings()
        retrieveMessages()
//        textFieldDidBeginEditing(messageTextfield)
//        textFieldDidEndEditing(messageTextfield)
        tableViewTapped()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }

    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CustomeMessageCell.identifier, for: indexPath) as! CustomeMessageCell

        cell.messageBody.text =
            messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "avatar-icon")

        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            //Messages we sent

            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatPowderBlueColorDark()
        }
        else {
            cell.avatarImageView.backgroundColor = UIColor.flatMagenta()
            cell.messageBackground.backgroundColor = UIColor.flatBlueColorDark()
        }

        return cell
    }

    func setupBindings() {
        sendMessageButton.tap.subscribe(onNext: { [weak self] in
            self?.buttonPressed()
        }).add(to: disposer)
    }

    func buttonPressed() {
        let messagesDB = Database.database().reference().child("Messages")

        let messageDictionary = ["Sender": Auth.auth().currentUser?.email,"MessageBody": self.messageTextfield.text!]

        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in

            if error != nil{
                print(error as Any)
            }else{
                print("Message Sent!")

                self.messageTextfield.isEnabled = true
                self.sendMessageButton.isEnabled = true
                self.messageTextfield.text = ""

            }
        }
    }

    func retrieveMessages(){
        let messsageDB = Database.database().reference().child("Messages")

        messsageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>

            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!

            let message = Message()
            message.messageBody = text
            message.sender = sender

            self.messageArray.append(message)
            self.messageTableView.reloadData()

        }
    }

//    func textFieldDidBeginEditing() {
//        self.messageTextfield = textField
//        messageTextfield.frame.size.height = 308
//
//    }
//
//    //TODO: Declare textFieldDidEndEditing here:
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.messageTextfield.text = nil
//        messageTextfield.frame.size.height = 50
//
//    }
}

