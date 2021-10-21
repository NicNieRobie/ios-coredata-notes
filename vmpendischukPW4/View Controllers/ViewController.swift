//
//  ViewController.swift
//  vmpendischukPW4
//
//  Created by Vladislav on 21.10.2021.
//

import UIKit
import CoreData

// MARK: Class definition
// Main view controller.
class ViewController: UIViewController {
    // Collection view that presents the notes.
    @IBOutlet weak var notesCollectionView: UICollectionView!
    // Label being displayed when the collection is empty.
    @IBOutlet weak var emptyCollectionLabel: UILabel!
    
    // Notes data list.
    var notes: [Note] = [] {
        didSet {
            emptyCollectionLabel.isHidden = notes.count != 0
            notesCollectionView.reloadData()
        }
    }
    
    // Data context.
    let context: NSManagedObjectContext = {
        // Container init.
        let container = NSPersistentContainer(name: "CoreDataNotes")
        
        // Trying to load the stores.
        container.loadPersistentStores{_, error in
            if let error = error {
                fatalError("Container loading failed")
            }
        }
        
        return container.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loading the stored data.
        loadData()
        
        // Navbar setup.
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createNote)
        )
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Collection view layout setup.
        notesCollectionView.contentInset = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        notesCollectionView.collectionViewLayout = AutoInvalidatingLayout()
    }
    
    // Loads the data from context.
    func loadData() {
        if let notes = try? context.fetch(Note.fetchRequest()) as [Note] {
            // If notes are fetched successfully.
            self.notes = notes.sorted(by: {
                $0.creationDate.compare($1.creationDate) == .orderedDescending
            })
        } else {
            // If notes fetch request was failed.
            self.notes = []
        }
    }
    
    // Saves the changes to data context.
    func saveChanges() {
        if context.hasChanges {
            // Saving the changes.
            try? context.save()
        }
        
        // Reloading data with fetch request.
        if let notes = try? context.fetch(Note.fetchRequest()) as [Note] {
            self.notes = notes
        } else {
            self.notes = []
        }
    }
    
    @objc
    // On plus (create note) button tap.
    func createNote(_ sender: Any) {
        // Getting the NoteViewController instance.
        guard let vc = storyboard?.instantiateViewController(identifier: "NoteViewController") as? NoteViewController else {
            return
        }
        
        vc.outputVC = self

        // Displaying the note view controller.
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Class extensions
// View controller extension for the notes collection view.
extension ViewController: UICollectionViewDataSource {
    // Number of items in collection view section getter.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    // Collection view cell for given index path getter.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
        
        // Filling cell with note data.
        let note = notes[indexPath.item]
        cell.titleLabel.text = note.title
        cell.descriptionLabel.text = note.descriptionText
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        cell.dateLabel.text = dateFormatter.string(from: note.creationDate)
        
        return cell
    }
}

// View controller extension for the notes collection view.
extension ViewController: UICollectionViewDelegate {
    // On collection view cell hold context menu configuration getter.
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = "\(indexPath.item)" as NSString
        
        // Context menu init and return.
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: .none) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: UIMenuElement.Attributes.destructive) { value in
                self.context.delete(self.notes[indexPath.item])
                self.saveChanges()
            }
            
            return UIMenu(title: "", image: nil, children: [deleteAction])
        }
    }
}
