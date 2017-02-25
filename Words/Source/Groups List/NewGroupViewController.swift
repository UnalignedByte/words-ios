//
//  NewGroupViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 09/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class NewGroupViewController: UIViewController
{
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var addGroupButton: UIButton!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 8.0
        NotificationCenter.default.addObserver(self, selector: #selector(nameFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.nameField)
    }


    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.nameField.becomeFirstResponder()
    }


    @IBAction func doneButtonPressed(sender: UIButton)
    {
        self.nameField.resignFirstResponder()

        let selectedRow = self.languagePicker.selectedRow(inComponent: 0)
        let languageCode = Language.languages[selectedRow].code
        let group = WordsDataSource.sharedInstance.newGroup(forLanguageCode: languageCode)
        group.name = nameField.text

        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func cancelButtonPressed(sender: UIButton)
    {
        self.nameField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }


    func nameFieldChanged(notification: Notification)
    {
        let noSpacesName = self.nameField.text?.replacingOccurrences(of: " ", with: "")

        self.addGroupButton.isEnabled = noSpacesName!.characters.count > 0
    }
}


extension NewGroupViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Language.languages.count
    }
}


extension NewGroupViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let languageCode = Language.languages[row].code
        return NSLocalizedString(languageCode, comment: "")
    }
}
