//
//  NoteViewController.swift
//  vmpendischukPW4
//
//  Created by Vladislav on 21.10.2021.
//

import UIKit

// Note creation view controller.
class NoteViewController: UIViewController {
    // Note's title text field.
    @IBOutlet weak var titleTextField: UITextField!
    // Note's description text field.
    @IBOutlet weak var textView: UITextView!
    // Output (note list presenting) view controller.
    var outputVC: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navbar setup.
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapSaveNote(button:))
        )
    }
    
    @objc
    // On done button tap.
    func didTapSaveNote(button: UIBarButtonItem) {
        let title = titleTextField.text ?? ""
        let descriptionText = textView.text ?? ""
        
        if !title.isEmpty {
            // Creating the Note object from context.
            let newNote = Note(context: outputVC.context)
            
            newNote.title = title
            newNote.descriptionText = descriptionText
            newNote.creationDate = Date()
            
            // Saving the changes.
            outputVC.saveChanges()
        }
        
        // Dismissinng the view controller.
        self.navigationController?.popViewController(animated: true)
    }
}
