/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Photos
import Firebase
import UserNotifications
import FirebaseInstanceID
import Messages
import JSQMessagesViewController


final class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
    private let imageURLNotSetKey = "NOTSET"
    
    var channelRef: DatabaseReference?
    
    
    private lazy var messageRef = DatabaseReference()
    //  private lazy var messageRef: DatabaseReference = self.channelRef!.child("9815606593+98156")
//    https://rahhal-d258a.firebaseio.com/
//    gs://chatchat-rw-cf107.appspot.com
    fileprivate lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://rahhal-d258a.firebaseio.com/")
    private lazy var userIsTypingRef: DatabaseReference = self.channelRef!.child("typingIndicator").child(self.senderId)
    private lazy var usersTypingQuery: DatabaseQuery = self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    
    
    private lazy var userIsActiveRef: DatabaseReference = self.channelRef!.child("activeUser").child(self.senderId)
    private lazy var usersActiveQuery: DatabaseQuery = self.channelRef!.child("activeUser").queryOrderedByValue().queryEqual(toValue: true)
    
    private var isMyPatnerActive = false
    
    private var newMessageRefHandle: DatabaseHandle?
    private var updatedMessageRefHandle: DatabaseHandle?
    
    private var messages: [JSQMessage] = []
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    var chatType = String()
    var myUserId = String()
    var patnerId = String()
    
    private var localTyping = false
    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let channelName = channel?.name
        
        patnerId = channel?.panterId as! String
        
        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        myUserId = dictUserInfo["id"] as! String
        
        
        updateMsgsReadStatus(id: myUserId)
        
        messageRef = self.channelRef!.child(channelName!)
        
        self.senderId = Auth.auth().currentUser?.uid
        observeMessages()
        self.navigationController?.navigationBar.isHidden = false
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userIsActiveRef.setValue(true)
        observeActivePatnerUser()
        observeTyping()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        userIsActiveRef.setValue(false)
        userIsTypingRef.setValue(false)
    }
    
    
    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    
    func updateMsgsReadStatus(id: String) -> Void {
        
        let channelId = channel?.id as! String
        
        let ref = Database.database().reference().child("\(chatType)/\(channelId)")
        
        var unreadMsgStatus = "0"
        
        if id == myUserId {
            
            unreadMsgStatus = "0"
        }
        if id != myUserId {
            
            if isMyPatnerActive {
                
                unreadMsgStatus = "0"
            }
            else {
                
                unreadMsgStatus = "1"
            }
        }
        ref.updateChildValues([
            "unread\(id)": unreadMsgStatus
            ])
    }
    
    
    // MARK: Collection view data source (and related) methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId { // 1
            cell.textView?.textColor = UIColor.white // 2
        } else {
            cell.textView?.textColor = UIColor.black // 3
        }
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        switch message.senderId {
        case senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    
    
    // MARK: Firebase related methods
    
    private func observeMessages() {
        
        //userPhone
        //ReceiverPhone
        /*
        let currentUserPhone = UserDefaults.standard.value(forKey: "userPhone") as! String
        
        let ReceiverPhone = UserDefaults.standard.value(forKey: "ReceiverPhone") as! String
        
        let Uniquename = String(format: "%@+%@", currentUserPhone,ReceiverPhone)
        */
        let channelName = channel?.name
        
        messageRef = channelRef!.child(channelName!)
        
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else if let id = messageData["senderId"] as String!, let photoURL = messageData["photoURL"] as String! {
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
                    self.addPhotoMessage(withId: id, key: snapshot.key, mediaItem: mediaItem)
                    
                    if photoURL.hasPrefix("gs://") {
                        self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                    }
                }
            } else {
                print("Error! Could not decode message data")
            }
        })
        
        // We can also use the observer method to listen for
        // changes to existing messages.
        // We use this to be notified when a photo has been stored
        // to the Firebase Storage, so we can update the message data
        updatedMessageRefHandle = messageRef.observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let photoURL = messageData["photoURL"] as String! {
                // The photo has been updated.
                if let mediaItem = self.photoMessageMap[key] {
                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key)
                }
            }
        })
    }
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        let storageRef = Storage.storage().reference(forURL: photoURL)
        //    storageRef.data(withMaxSize: INT64_MAX){ (data, error) in
        //      if let error = error {
        //        print("Error downloading image data: \(error)")
        //        return
        //      }
        //
        //      storageRef.metadata(completion: { (metadata, metadataErr) in
        //        if let error = metadataErr {
        //          print("Error downloading metadata: \(error)")
        //          return
        //        }
        //
        //        if (metadata?.contentType == "image/gif") {
        //          mediaItem.image = UIImage.gifWithData(data!)
        //        } else {
        //          mediaItem.image = UIImage.init(data: data!)
        //        }
        //        self.collectionView.reloadData()
        //
        //        guard key != nil else {
        //          return
        //        }
        //        self.photoMessageMap.removeValue(forKey: key!)
        //      })
        //    }
    }
    
    private func observeTyping() {
        
        let typingIndicatorRef = channelRef!.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
        
        usersTypingQuery.observe(.value) { (data: DataSnapshot) in
            
            // You're the only typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
    }
    
    
    private func observeActivePatnerUser() {
        
        let activeIndicatorRef = channelRef!.child("activeUser")
        userIsActiveRef = activeIndicatorRef.child(senderId)
        userIsActiveRef.onDisconnectRemoveValue()
        usersActiveQuery = activeIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
        
        usersActiveQuery.observe(.value) { (data: DataSnapshot) in
            
            
            print(data)
            // You're the only typing, don't show the indicator
            if data.childrenCount == 1 {
                return
            }
            
            for child in data.children {
                
                let snap = child as! DataSnapshot
                
                print(snap)
                
                if snap.key != self.senderId {
                    
                    self.isMyPatnerActive = snap.value as! Bool
                }
                
                
                print(self.isMyPatnerActive)
                
            }
            
            // Are there others typing?
//            self.showTypingIndicator = data.childrenCount > 0
//            self.scrollToBottom(animated: true)
        }
    }
    
    
    
    func apicall(text:String,groupname:String) -> Void {
        
        var request = URLRequest(url:NSURL(string: "https://fcm.googleapis.com/fcm/send")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAf4CJkPw:APA91bGKlsIgBKGDbDparcyLBFe20tl25crTQX6kQRHuweto4gI85ikusAZQj7D8VRI-qkjXJhLVquPjd1zpKWdS5b8NAH52BJAEYu-jP-4ESsqcJBX_oTquBglDzHXosHKZNLQGLxQS", forHTTPHeaderField: "Authorization")
        
        let title = [ "title":groupname, "text":text, "click_action":"OPEN_ACTIVITY_1"]
        
        let data = [ "keyname":"fsasaf"]
        
        let st = InstanceID.instanceID().token()
        
        let arr : Array = ["eD-baau2Ur0:APA91bGrtsw5rLxjuCDkKOTDcywxJpra78RTWw_ZHXYBGQrNudIeVFiMnn9Yg8XQ0nFF4vDf1cblUqdqymR3uWICxtvWYh8QEYxcPSIsOSjS7nKaq3mu3VWu2PDXpWGK8B8XNptJVeou","eqkh9Vp4SEk:APA91bGO_zSb_6bBuSufedbVP9JDbWLe9kU_OWgYq95vZJMEDhYkfzrReR_KuWgsNJcNNvHllKe1V87gN4mnYYv9SXF4Z-1lfKzmcigZ71d4mgFvvkM34L0X725pjmHm42hxKXP5N2UP"]
        //
        //let json = ["data": data ,"notification": title ,"to":"/topics/swift_fans"] as [String : Any]
        
        let json = ["data": data ,"notification": title ,"registration_ids": arr] as [String : Any]
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                
                
                request.httpBody = JSONString.data(using: .utf8)
            }
            
        } catch {
            
            print(error.localizedDescription)
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            do {
                let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                print(responseDict)
                
            } catch let error as NSError {
                
                
            }
            
        }
        task.resume()
        
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // 1
        // self.apicall(text: text, groupname: (channel?.name)!)
        
        let itemRef = messageRef.childByAutoId()
        
        // 2
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        
        //FIRMessaging.messaging.sendMessage(message: message, to: , withMessageID, timeToLive)
        // 3
        
        itemRef.setValue(messageItem)
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        
        isTyping = false
        
        self.updateMsgsReadStatus(id: patnerId)
        
    }
    
    func sendPhotoMessage() -> String? {
        let itemRef = messageRef.childByAutoId()
        
        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "senderId": senderId!,
            ]
        
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        return itemRef.key
    }
    
    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
    
    // MARK: UI and User Interaction
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    
    // MARK: UITextViewDelegate methods
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        // 1
        if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            // Handle picking a Photo from the Photo Library
            // 2
            let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
            let asset = assets.firstObject
            
            // 3
            if let key = sendPhotoMessage() {
                // 4
                asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                    let imageFileURL = contentEditingInput?.fullSizeImageURL
                    
                    // 5
                    let path = "\(String(describing: Auth.auth().currentUser?.uid))/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
                    
                    // 6
                    self.storageRef.child(path).putFile(from: imageFileURL!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading photo: \(error.localizedDescription)")
                            return
                        }
                        // 7
                        self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                    }
                })
            }
        } else {
            // Handle picking a Photo from the Camera - TODO
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
