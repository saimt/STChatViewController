//
//  ChatViewController.swift
//  STChatViewController
//
//  Created by Creatrixe on 30/03/2019.
//  Copyright © 2019 Creatrixe. All rights reserved.
//

import UIKit

class InstagramChatViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var btnPickImage: UIButton!
    @IBOutlet weak var messageTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwMessageTextView: UIView!
    @IBOutlet weak var vwMessageTextViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageTextView()
        addObservers()
        initView()
        
        STMessage.loadDummyMessages()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollToBottom()
    }
    
    //MARK:- Functions
    func configureMessageTextView(){
        messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 50)
        messageTextView.layer.cornerRadius = 20.0
        messageTextView.layer.borderColor = UIColor.black.cgColor
        messageTextView.layer.borderWidth = 1.0
        messageTextView.clipsToBounds = true
        messageTextView.delegate = self
        messageTextView.setPlaceholder(placeholder: "Type message...")
        messageTextView.tintColor = UIColor.black
        textViewDidChange(messageTextView)
        
        btnPickImage.isHidden = false
        btnSendMessage.isHidden = true
    }
    
    func initView(){
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(rowTapped(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func rowTapped(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = chatTableView.indexPathForRow(at: touchPoint) {
                print("Tapped ",indexPath.row)
//                STMessage.dummyMessages[indexPath.row].message
                // your code here, get the row for the indexPath or do whatever you want
            }
        }
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(notification: NSNotification) {
        if let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            vwMessageTextViewBottomConstraint.constant = height
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc func hideKeyboard(notification: NSNotification) {
        if let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            //let height = frame.cgRectValue.height
            vwMessageTextViewBottomConstraint.constant = CGFloat(0)
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func scrollToBottom(){
        if STMessage.dummyMessages.count > 0
        {
            self.chatTableView.scrollToRow(at: IndexPath.init(row: STMessage.dummyMessages.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    //MARK:- Actions
    @IBAction func btnSendMessageAction(_ sender: UIButton) {
        if messageTextView.text != ""{
            STMessage.dummyMessages.append(STMessage(sender: "2", time: 12312, message: messageTextView.text, picture: nil))
            chatTableView.reloadData()
            messageTextView.text = ""
            textViewDidChange(messageTextView)
            scrollToBottom()
        }
    }
    
    @IBAction func btnPickImageAction(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { (image) in
            STMessage.dummyMessages.append(STMessage(sender: "2", time: 1232, message: "", messageType: "image", picture: image))
            self.chatTableView.reloadData()
            self.scrollToBottom()
        }
    }
    
}

extension InstagramChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STMessage.dummyMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if STMessage.dummyMessages[indexPath.row].sender == "1"{
            if STMessage.dummyMessages[indexPath.row].messageType == "text"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
                cell.clearCellData()
                cell.imgUser.image = #imageLiteral(resourceName: "ic_user.png")
                cell.txtMessage.text = STMessage.dummyMessages[indexPath.row].message
                cell.lblMessageTime.text = "\(STMessage.dummyMessages[indexPath.row].time!)"
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImageCell") as! ReceiverImageCell
                cell.clearCellData()
                cell.imgUser.image = #imageLiteral(resourceName: "ic_user.png")
                cell.imgBackground.image = STMessage.dummyMessages[indexPath.row].picture
                cell.lblMessageTime.text = "\(STMessage.dummyMessages[indexPath.row].time!)"
                return cell
            }
        }
        else{
            if STMessage.dummyMessages[indexPath.row].messageType == "text"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
                cell.clearCellData()
                cell.lblMessageTime.text = "\(STMessage.dummyMessages[indexPath.row].time!)"
                cell.txtMessage.text = STMessage.dummyMessages[indexPath.row].message
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell") as! SenderImageCell
                cell.clearCellData()
                cell.lblMessageTime.text = "\(STMessage.dummyMessages[indexPath.row].time!)"
                cell.imgBackground.image = STMessage.dummyMessages[indexPath.row].picture
                return cell
            }
            
        }
    }
}

extension InstagramChatViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        if textView.text.isEmpty{
            btnPickImage.isHidden = false
            btnSendMessage.isHidden = true
        }
        else{
            btnPickImage.isHidden = true
            btnSendMessage.isHidden = false
        }
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height < 40 {
            textView.isScrollEnabled = false
            messageTextViewHeightConstraint.constant = 40
        } else if newSize.height > 140 {
            textView.isScrollEnabled = true
            messageTextViewHeightConstraint.constant = 140
            //scrollToBottom()
        } else {
            textView.isScrollEnabled = false
            messageTextViewHeightConstraint.constant = newSize.height
            //scrollToBottom()
        }
        //scrollToBottom()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.scrollToBottom()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            lblPlaceholder.isHidden = false
//        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
}

extension InstagramChatViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < 0{
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
}
