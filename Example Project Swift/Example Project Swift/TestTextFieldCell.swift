//
//  TestTextFieldCell.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit

class TestTextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    static let identifier: String = "TestTextFieldCell"
    
    var valueDidChange: ((String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.addTarget(self, action: #selector(textFieldValueDidChange(_:)), for: .editingChanged)
        self.textField.becomeFirstResponder()
    }
    
    func textFieldValueDidChange(_ sender: Any) {
        self.valueDidChange?(self.textField?.text)
    }
}
