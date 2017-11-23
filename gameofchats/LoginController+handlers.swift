

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Регистрация
    
    func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        // создаем юзера
        FIRAuth.auth()?.createUser(withEmail: email,
                                   password: password,
                                   completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error!)
                return
            }
            
              // Successfully authenticated user
            
            guard let uid = user?.uid else {
                return
            }

            // Загружаем фото юзера в хранилище
            
            // взяли идентифкатор
            let imageName = UUID().uuidString
            
            // взяли нод под этим идентикатором + .jpg
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            // ужали размер картинки
            if let profileImage = self.profileImageView.image,
                let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
                 //  if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                
                // загрузили в хранилище
                storageRef.put(uploadData, metadata: nil,
                               completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    // нам вернулась ссылка на картинку
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        // собрали свойства юзера в словарь
                        let values = ["name": name,
                                      "email": email,
                                      "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    func registerUserIntoDatabaseWithUID(_ uid: String,
                                         values: [String: AnyObject]) {
        
        // сохраняем данные юзера в бд
        let ref = FIRDatabase.database().reference()
        
        // взяли реф на нод юзера
        let usersReference = ref.child("users").child(uid)
        
        // обновили свойства юзера
        usersReference.updateChildValues(values,
                                         withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            
            // self.messagesController?.fetchUserAndSetupNavBarTitle()
            // self.messagesController?.navigationItem.title = values["name"] as? String
            
            // собрали юзера из пришедших свойств
            let user = User(dictionary: values)
            
            // передали юзера в основной контролер
            self.messagesController?.setupNavBarWithUser(user)
            
            // убрали логин контролер
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    //MARK: - UIImagePickerControllerDelegate
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}









