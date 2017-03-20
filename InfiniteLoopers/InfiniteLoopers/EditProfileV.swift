//
//  EditProfileV.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 3/18/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional
import Kingfisher
import Swarkn

class EditProfileV: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var disposeBag = DisposeBag()
    var model:EditProfileVMProtocol!

    @IBOutlet weak var changePictureButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    var saveButton:UIBarButtonItem!
    var genderPicker:UIPickerView!
    var imagePicker:UIImagePickerController!
    
    
    convenience init(model:EditProfileVMProtocol){
        self.init(nibName: nil, bundle: nil)
        self.model = model
        self.title = NSLocalizedString("edit_profile", comment: "edit_profile")
    }
    
}

// MARK: - UIViewController 

extension EditProfileV{
    override func viewDidLoad() {
        super.viewDidLoad()

        model.profilePictureUrl.asDriver()
            .drive(onNext:{ [unowned self] avatar in
            self.profilePicture.setAvatarImage(urlString: avatar)
        }).addDisposableTo(disposeBag)
        
        model.name.asDriver()
            .filter {$0 != nil}
            .map {$0?.capitalized }
            .drive(nameTF.rx.text)
            .addDisposableTo(disposeBag)
        
        model.gender.asDriver()
            .drive(genderTF.rx.text)
            .addDisposableTo(disposeBag)
        
        model.phone.asDriver()
            .drive(phoneTF.rx.text)
            .addDisposableTo(disposeBag)
        
        setupSaveButton()
        setupChangePictureButton()
        setGenderPicker()
    }
    
    func setupChangePictureButton(){
        profilePicture.setAvatarImage(urlString: AppManager.shared.userLogged.value?.avatar)
        profilePicture.setBorderAndRadius(color: UIColor.mainDarkGrey.cgColor, width: 0.5, cornerRadius: 5)
        changePictureButton.setBackgroundImage(UIImage(color: UIColor(rgbValue: 0x000000, alpha: 0.3)), for: .highlighted)
        changePictureButton.rx.tap.observeOn(MainScheduler.instance).bindNext {[unowned self] in
            self.showPictureSourceSelector()
            }.addDisposableTo(disposeBag)
    }
    
    func setupSaveButton(){
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        navigationItem.rightBarButtonItem = saveButton
        saveButton.rx.tap.observeOn(MainScheduler.instance).bindNext { [weak self] in
            guard let `self` = self else {
                return
            }
            let image = self.profilePicture.kf.webURL == nil ? self.profilePicture.image : nil
            let gender = self.model.genders[self.genderPicker.selectedRow(inComponent: 0)].rawValue
            self.model.updateProfile(name: self.nameTF.text, gender: gender, phone: self.phoneTF.text, image: image){_, error in
                if let error = error{
                    print(error)
                    return
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
        }.addDisposableTo(disposeBag)
        
        Observable.combineLatest(phoneTF.rx.text.map{phone in Validation.Phone.isPhoneValid(withNumber: phone!, countryCode: "es") || phone!.isEmpty}, nameTF.rx.text.map{
            name in name!.characters.count > 2 }, resultSelector:
            {
                !$0 || !$1
        }).distinctUntilChanged().bindNext { [unowned self] in
            self.navigationItem.rightBarButtonItem = $0 ? nil : self.saveButton
        }.addDisposableTo(disposeBag)
    }
    
    func showImagePicker(sourceType:UIImagePickerControllerSourceType){
        imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
//        imagePicker.modalPresentationStyle = .popover
//        if(IS_IPAD){
//            imagePicker.popoverPresentationController?.sourceView = self.view
//        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func showPictureSourceSelector(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: NSLocalizedString("camera", comment: "camera"), style: .default){[unowned self] _ in
            self.showImagePicker(sourceType: .camera)
        }
        
        let gallery = UIAlertAction(title: NSLocalizedString("photo_gallery", comment: "photo_gallery"), style: .default){[unowned self] _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){[unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(camera)
        actionSheet.addAction(gallery)
        actionSheet.addAction(cancelAction)
        
        if(IS_IPAD){
            actionSheet.modalPresentationStyle = .popover
            actionSheet.popoverPresentationController?.sourceView = self.view
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.changePictureButton.frame.origin.x, y: self.changePictureButton.frame.origin.x, width: self.changePictureButton.frame.width, height: self.changePictureButton.frame.height + (self.changePictureButton.frame.height / 2))
            actionSheet.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}


// MARK: - UIImagePickerControllerDelegate

extension EditProfileV{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profilePicture.kf.setImage(with: nil)
        self.profilePicture.image = chosenImage


        
        //model.uploadPicture(withData: UIImageJPEGRepresentation(chosenImage, 0.75)!)
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - GenderPicker, UIPickerViewDelegate, UIPickerViewDataSource

extension EditProfileV{
    func setGenderPicker(){
        genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTF.inputView = genderPicker
        genderTF.inputAccessoryView = doneAccesoryView(textField: genderTF)
        genderTF.reloadInputViews()
        
        genderPicker
            .rx
            .itemSelected
            .observeOn(MainScheduler.instance)
            .map{self.model.genders[$0.0].commonDescription}
            .bindTo(genderTF.rx.text).addDisposableTo(disposeBag)
    }
    
    func doneAccesoryView(textField:UITextField) -> UIView{
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.mainRed
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        doneButton.rx.tap.observeOn(MainScheduler.instance).bindNext {
            textField.resignFirstResponder()
            }.addDisposableTo(disposeBag)
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.model.genders.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.model.genders[row].commonDescription
    }
}
