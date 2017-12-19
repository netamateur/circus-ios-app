//
//  ViewController.swift
//  Circus-Imgs
//
//  Created by Samuel Fary on 21/8/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    var defaultConstraintValue: CGFloat = 0;
    var myComment:Comment?
    var author:String = "You"
    var card: Card?

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet var commentView: UITableView!
    @IBOutlet weak var commentsTextfield: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        defaultConstraintValue = bottomConstraint.constant;

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let _ = myComment
        {
            commentsTextfield.text = myComment!.text
            
        }
        //Model.get.fetchComments(card: card!)
        print("THE NUMBER OF COMMENTS")
        print(Model.get.commentsDB.count)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func post(_ sender: Any) {
        
        Model.get.saveComment(author_name: author, content: commentsTextfield.text!, nCard: card)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfSections(in tablView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.get.commentsDB.count
    }
    
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> UITableViewCell {
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsFD", for: indexPath) as! CommentsCell
        
        let displayCom = Model.get.getComment(indexPath)
        cell.commentBox?.text = displayCom.text
        cell.profileImg.image = UIImage(named: Model.get.users[2])
        
        
        return cell
    }
    
    // MARK: - Enable Swipe to Delete
    // System method that enables swipe to delete on a row in a tableview controller.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // System method that gets called when delete is selected
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        Model.get.deleteComment(indexPath)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.commentsTextfield = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.commentsTextfield = textField
    }
    
    //keyboard control
    func keyboardShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            print("keyboard height!! \(keyboardSize.height)");
            bottomConstraint.constant = keyboardSize.height + defaultConstraintValue + 44;
            UIView.animate(withDuration: 0.1)
            {
                self.view.layoutIfNeeded()
            }
            print("keyboard show!! \(bottomConstraint.constant)");
        }
        
        
       
    }
    
    func keyboardHide(notification: NSNotification)
    
    {
        bottomConstraint.constant = defaultConstraintValue;
        UIView.animate(withDuration: 0.1)
        {
            self.view.layoutIfNeeded()
        }
        print("keyboard hide!! \(bottomConstraint.constant)");
    }
    




}

