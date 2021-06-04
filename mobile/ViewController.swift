//
//  ViewController.swift
//  Laba
//
//  Created by razur on 03.06.2021.
//

import UIKit

class ViewController: UIViewController {

    var text: String!
    var image: UIImage!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoView.image = image
        self.textView.text = text
    }
}
