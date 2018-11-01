//
//  ViewController.swift
//  CustomCamera
//
//  Created by ViXette on 01/11/2018.
//

import UIKit
import AVFoundation

///
class ViewController: UIViewController {
	
	var captureSession = AVCaptureSession()
	
	var backCamera: AVCaptureDevice?
	
	var frontCamera: AVCaptureDevice?
	
	var currentCamera: AVCaptureDevice?
	
	var photoOutput: AVCapturePhotoOutput?
	
	var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
	
	var image: UIImage?
	
	///
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupCaptureSession()
		
		setupDevice()
		
		setupInputOutput()
		
		setupPreviewLayer()
		
		startRunningCapureSession()
	}
	
	///
	private func setupCaptureSession () {
		captureSession.sessionPreset = .photo
	}
	
	///
	private func setupDevice () {
		let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
		
		for device in deviceDiscoverySession.devices {
			if device.position == AVCaptureDevice.Position.back {
				backCamera = device
			} else if device.position == AVCaptureDevice.Position.front {
				frontCamera = device
			}
			
			currentCamera = backCamera
		}
	}
	
	///
	private func setupInputOutput () {
		do {
			let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
			captureSession.addInput(captureDeviceInput)
			
			photoOutput = AVCapturePhotoOutput()
			photoOutput?.setPreparedPhotoSettingsArray(
				[AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
				completionHandler: nil
			)
			
			captureSession.addOutput(photoOutput!)
		} catch {
			print("📌 \(error.localizedDescription)")
		}
	}
	
	///
	private func setupPreviewLayer () {
		cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		cameraPreviewLayer?.videoGravity = .resizeAspectFill
		cameraPreviewLayer?.connection?.videoOrientation = .portrait
		cameraPreviewLayer?.frame = self.view.frame
		
		self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
	}
	
	///
	private func startRunningCapureSession () {
		captureSession.startRunning()
	}
	
	///
	@IBAction func cameraTapped (_ sender: UIButton) {
		let settings = AVCapturePhotoSettings()
		photoOutput?.capturePhoto(with: settings, delegate: self)
		//
	}
	
	///
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destVC = segue.destination as? PreviewViewController {
			destVC.image = image
		}
	}
	
}

// MARK: - AVCapturePhotoCaptureDelegate
extension ViewController: AVCapturePhotoCaptureDelegate {
	
	///
	func photoOutput (_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		if let imageData = photo.fileDataRepresentation() {
			image = UIImage(data: imageData)
			
			performSegue(withIdentifier: "showPhotoSegue", sender: nil)
		}
	}
	
}
