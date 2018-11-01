//
//  PreviewViewController.swift
//  CustomCamera
//
//  Created by ViXette on 01/11/2018.
//

import UIKit

class PreviewViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	
	var image: UIImage?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.image = image
	}

	///
	@IBAction func cancelTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	///
	@IBAction func saveTapped(_ sender: UIButton) {
		guard let image = image else {
			return
		}
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
		
		dismiss(animated: true, completion: nil)
	}
	
}
