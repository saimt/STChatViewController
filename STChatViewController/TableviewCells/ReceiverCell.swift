//
//  ReceiverCell.swift
//  STChatViewController
//
//  Created by Creatrixe on 30/03/2019.
//  Copyright © 2019 Creatrixe. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var lblMessageTime: UILabel!
    
    var bubbleColor: UIColor = .white {
        didSet {
            setupBubble()
        }
    }
    
    var bubbleCornerRadius: CGFloat = 22 {
        didSet {
            setupBubble()
        }
    }
    
    var bubbleBorderWidth: CGFloat = 1 {
        didSet {
            setupBubble()
        }
    }
    
    var bubbleBorderColor: UIColor = .lightGray {
        didSet {
            setupBubble()
        }
    }
    
    var bubbleTextColor: UIColor = .black {
        didSet {
            setupBubble()
        }
    }
    
    var textInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet {
            setupBubble()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBubble()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setupBubble(){
        imgBackground.backgroundColor = bubbleColor
        txtMessage.textContainerInset = textInsets
        txtMessage.textColor = bubbleTextColor
        imgBackground.layer.cornerRadius = bubbleCornerRadius
        imgBackground.layer.borderColor = bubbleBorderColor.cgColor
        imgBackground.layer.borderWidth = bubbleBorderWidth
        self.imgBackground.clipsToBounds = true
    }
    
    func clearCellData()  {
        self.txtMessage.text = nil
        self.txtMessage.isHidden = false
        self.imgBackground.image = nil
    }
}

