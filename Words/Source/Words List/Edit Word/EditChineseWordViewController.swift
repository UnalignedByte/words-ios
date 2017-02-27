//
//  EditChineseWordViewController.swift
//  Words
//
//  Created by Rafal Grodzinski on 26/02/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


class EditChineseWordViewController: EditWordViewController
{
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var wordField: UITextField!
    @IBOutlet fileprivate weak var pinyinField: UITextField!
    @IBOutlet fileprivate weak var translationField: UITextField!

    fileprivate var toneOneButton: UIButton!
    fileprivate var toneTwoButton: UIButton!
    fileprivate var toneThreeButton: UIButton!
    fileprivate var toneFourButton: UIButton!
    fileprivate var toneFiveButton: UIButton!

    fileprivate var isWordFieldValid = false {
        didSet {
            valuesChanged()
        }
    }
    fileprivate var isPinyinFieldValid = false {
        didSet {
            valuesChanged()
        }
    }
    fileprivate var isTranslationFieldValid = false {
        didSet {
            valuesChanged()
        }
    }


    // MARK: - Initialization
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(wordFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.wordField)
        NotificationCenter.default.addObserver(self, selector: #selector(pinyinFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.pinyinField)
        NotificationCenter.default.addObserver(self, selector: #selector(translationFieldChanged(notification:)),
                                               name: Notification.Name.UITextFieldTextDidChange, object: self.translationField)

        setupTextAccessoryView()
        setupToneButtons(forCharacter: nil)
    }


    fileprivate func setupTextAccessoryView()
    {
        let backgroundColor = UIColor(colorLiteralRed: 202.0/255.0, green: 205.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        let buttonColor = UIColor(colorLiteralRed: 179.0/255.0, green: 186.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        let pressedButtonColor = UIColor(colorLiteralRed: 232.0/255.0, green: 234.0/255.0, blue: 237.0/255.0, alpha: 1.0)

        let width = Double(UIScreen.main.bounds.width)
        let height = 36.0

        // Accessory View
        let accessoryView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        accessoryView.backgroundColor = backgroundColor

        // Buttons Stack
        let toneButtonsStack = UIStackView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        toneButtonsStack.distribution = .fillEqually
        toneButtonsStack.spacing = 1.0
        accessoryView.addSubview(toneButtonsStack)

        // ¯
        toneOneButton = UIButton(type: .system)
        toneOneButton.setTitle("¯", for: .normal)
        toneOneButton.setTitleColor(UIColor.white, for: .normal)
        toneOneButton.setTitleColor(UIColor.black, for: .highlighted)
        toneOneButton.setNormalBackgroundColor(buttonColor)
        toneOneButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneOneButton.addTarget(self, action: #selector(toneOneButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneOneButton, at: 0)

        // ´
        toneTwoButton = UIButton(type: .system)
        toneTwoButton.setTitle("´", for: .normal)
        toneTwoButton.setTitleColor(UIColor.white, for: .normal)
        toneTwoButton.setTitleColor(UIColor.black, for: .highlighted)
        toneTwoButton.setNormalBackgroundColor(buttonColor)
        toneTwoButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneTwoButton.addTarget(self, action: #selector(toneTwoButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneTwoButton, at: 1)

        // `
        toneThreeButton = UIButton(type: .system)
        toneThreeButton.setTitle("`", for: .normal)
        toneThreeButton.setTitleColor(UIColor.white, for: .normal)
        toneThreeButton.setTitleColor(UIColor.black, for: .highlighted)
        toneThreeButton.setNormalBackgroundColor(buttonColor)
        toneThreeButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneThreeButton.addTarget(self, action: #selector(toneThreeButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneThreeButton, at: 2)

        // ˇ
        toneFourButton = UIButton(type: .system)
        toneFourButton.setTitle("ˇ", for: .normal)
        toneFourButton.setTitleColor(UIColor.white, for: .normal)
        toneFourButton.setTitleColor(UIColor.black, for: .highlighted)
        toneFourButton.setNormalBackgroundColor(buttonColor)
        toneFourButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneFourButton.addTarget(self, action: #selector(toneFourButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneFourButton, at: 3)

        //  ̌̈
        toneFiveButton = UIButton(type: .system)
        toneFiveButton.setTitle(" ̌̈", for: .normal)
        toneFiveButton.setTitleColor(UIColor.white, for: .normal)
        toneFiveButton.setTitleColor(UIColor.black, for: .highlighted)
        toneFiveButton.setNormalBackgroundColor(buttonColor)
        toneFiveButton.setHighlightedBackgroundColor(pressedButtonColor)
        toneFiveButton.addTarget(self, action: #selector(toneFiveButtonPressed(sender:)), for: .touchUpInside)
        toneButtonsStack.insertArrangedSubview(toneFiveButton, at: 4)

        pinyinField.inputAccessoryView = accessoryView
    }


    fileprivate func setupToneButtons(forCharacter character: Character?)
    {
        if let character = character {
            pinyinField.inputAccessoryView?.isHidden = false

            toneOneButton.setTitle("\(character)\u{0304}", for: .normal)
            toneTwoButton.setTitle("\(character)\u{0341}", for: .normal)
            toneThreeButton.setTitle("\(character)\u{0340}", for: .normal)
            toneFourButton.setTitle("\(character)\u{030c}", for: .normal)
            toneFiveButton.setTitle("\(character)\u{030c}\u{0308}", for: .normal)
        } else {
            pinyinField.inputAccessoryView?.isHidden = true
        }
    }


    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }


    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        wordField.becomeFirstResponder()
    }


    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        wordField.resignFirstResponder()
        pinyinField.resignFirstResponder()
        translationField.resignFirstResponder()
    }


    // MARK: - Private functions
    @objc fileprivate func wordFieldChanged(notification: Notification)
    {
        let noSpacesWord = self.wordField.text?.replacingOccurrences(of: " ", with: "")
        isWordFieldValid = noSpacesWord!.characters.count > 0
    }


    @objc fileprivate func pinyinFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.pinyinField.text?.replacingOccurrences(of: " ", with: "")
        isPinyinFieldValid = noSpacesTransaltion!.characters.count > 0
    }


    @objc fileprivate func translationFieldChanged(notification: Notification)
    {
        let noSpacesTransaltion = self.translationField.text?.replacingOccurrences(of: " ", with: "")
        isTranslationFieldValid = noSpacesTransaltion!.characters.count > 0
    }


    fileprivate func valuesChanged()
    {
        if let callback = valuesChangedCallback {
            callback(isWordFieldValid && isPinyinFieldValid && isTranslationFieldValid)
        }
    }


    // MARK: - Actions
    func toneOneButtonPressed(sender: UIButton)
    {
        //let cursorOffset = pinyinField.offset(from: pinyinField.beginningOfDocument, to: pinyinField.selectedTextRange!.start)
        //pinyinField.text?.characters.

        pinyinField.text?.append("\u{0304}")
        setupToneButtons(forCharacter: nil)
    }


    func toneTwoButtonPressed(sender: UIButton)
    {
        pinyinField.text?.append("\u{0341}")
        setupToneButtons(forCharacter: nil)
    }


    func toneThreeButtonPressed(sender: UIButton)
    {
        pinyinField.text?.append("\u{0340}")
        setupToneButtons(forCharacter: nil)
    }


    func toneFourButtonPressed(sender: UIButton)
    {
        pinyinField.text?.append("\u{030c}")
        setupToneButtons(forCharacter: nil)
    }


    func toneFiveButtonPressed(sender: UIButton)
    {
        pinyinField.text?.append("\u{030c}\u{0308}")
        setupToneButtons(forCharacter: nil)
    }


    // MARK: - Public functions
    override func createWord(forGroup group: Group)
    {
        let word = WordsDataSource.sharedInstance.newWord(forGroup: group) as? ChineseWord
        guard word != nil  else {
            fatalError("Couldn't create an instance of ChineseWord")
        }

        word!.word = wordField.text!
        word!.pinyin = pinyinField.text!
        word!.translation = translationField.text!
    }
}


extension EditChineseWordViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == wordField {
            pinyinField.becomeFirstResponder()
        } else if textField == pinyinField {
            translationField.becomeFirstResponder()
        } else {
            wordField.becomeFirstResponder()
        }

        return true
    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let character = string.characters.last {
            setupToneButtons(forCharacter: character)
        } else {
            setupToneButtons(forCharacter: nil)
        }
        
        return true
    }
}
