//
//  ViewController.swift
//  Lesson8_drawing
//
//  Created by MacBook Air on 29.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {

	let canvas = Canvas()
	let colorsView = UIView()
	let toolsView = UIView()
	lazy var redButton = configuratingButton(with: .red)
	lazy var blueButton = configuratingButton(with: .blue)
	lazy var greenButton = configuratingButton(with: .green)
	lazy var yellowButton = configuratingButton(with: .yellow)
	lazy var lightGrayButton = configuratingButton(with: .lightGray)
	lazy var darkGrayButton = configuratingButton(with: .darkGray)
	lazy var pinkButton = configuratingButton(with: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
	lazy var blackButton = configuratingButton(with: .black)
	lazy var whiteButton = configuratingButton(with: .white)
	lazy var cyanButton = configuratingButton(with: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
	lazy var colorButtons = [redButton, greenButton, blueButton, yellowButton, cyanButton, pinkButton, lightGrayButton, darkGrayButton, blackButton, whiteButton]
	var lastChoosenButtonColor = UIButton()
	var lastChoosenLineWidth: Float = 2.0
	var colorButtonsStackView = UIStackView()
	let lineWidthSlider: UISlider = {
		let slider = UISlider()
		slider.layer.cornerRadius = 5
		slider.layer.borderWidth = 1.0
		slider.backgroundColor = #colorLiteral(red: 0.9136064404, green: 0.9136064404, blue: 0.9136064404, alpha: 1)
		slider.layer.borderColor = UIColor.darkGray.cgColor
		slider.minimumValue = 1.0
		slider.maximumValue = 15.0
		slider.minimumTrackTintColor = UIColor.black
		slider.tintColor = .black
		slider.minimumValueImage = UIImage(systemName: "smallcircle.fill.circle")
		slider.maximumValueImage = UIImage(systemName: "largecircle.fill.circle")
		slider.addTarget(self, action: #selector(sliderWidthValueChanged(_:)), for: .valueChanged)
		return slider
	}()
	let pencilButton: UIButton = {
		let button = UIButton(type: .custom)
		let image = UIImage(systemName: "pencil")
		button.tintColor = .systemRed
		button.isSelected = true
		button.setBackgroundImage(image, for: .normal)
		button.setBackgroundImage(image, for: .selected)
		button.addTarget(self, action: #selector(drawOrEraseButtonsTapped), for: .touchUpInside)
		return button
	}()
	let eraseButton: UIButton = {
		let button = UIButton(type: .custom)
		let image = UIImage(systemName: "bandage")
		button.tintColor = .darkGray
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(drawOrEraseButtonsTapped), for: .touchUpInside)
		return button
	}()
	let lineWidthButton: ToolsButton = {
		let button = ToolsButton(type: .system)
		let image = UIImage(systemName: "scribble")
		button.tintColor = .darkGray
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(lineWidthButtonTapped), for: .touchUpInside)
		return button
	}()
	let undoButton: ToolsButton = {
		let button = ToolsButton(type: .system)
		let image = UIImage(systemName: "arrowshape.turn.up.left.circle")
		button.tintColor = .darkGray
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
		return button
	}()
	let clearButton: ToolsButton = {
		let button = ToolsButton(type: .system)
		let image = UIImage(systemName: "doc")
		button.tintColor = .darkGray
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
		return button
	}()
	let shareButton: ToolsButton = {
		let button = ToolsButton(type: .system)
		let image = UIImage(systemName: "square.and.arrow.up")
		button.tintColor = .darkGray
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
		return button
	}()
	let changeBackgroundButton: ToolsButton = {
		let button = ToolsButton(type: .system)
		let image = UIImage(systemName: "gear")
		button.tintColor = .darkGray
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(bgColorChooseButtonTapped(_:)), for: .touchUpInside)
		return button
	}()
	let closeColorsViewButton: ToolsButton = {
		let button = ToolsButton(type: .system)
		let image = UIImage(systemName: "chevron.compact.down")
		button.backgroundColor = #colorLiteral(red: 0.9136064404, green: 0.9136064404, blue: 0.9136064404, alpha: 1)
		button.layer.cornerRadius = 5
		button.layer.borderWidth = 1.5
		button.layer.borderColor = UIColor.darkGray.cgColor
		button.tintColor = .darkGray
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(closeColorsViewButtonTapped(_:)), for: .touchUpInside)
		return button
	}()
	let closeToolsViewButton: ToolsButton = {
		let button = ToolsButton(type: .system)
		let image = UIImage(systemName: "chevron.compact.left")
		button.backgroundColor = #colorLiteral(red: 0.9136064404, green: 0.9136064404, blue: 0.9136064404, alpha: 1)
		button.layer.cornerRadius = 5
		button.layer.borderWidth = 1.5
		button.layer.borderColor = UIColor.darkGray.cgColor
		button.tintColor = .darkGray
		button.setBackgroundImage(image, for: .normal)
		button.addTarget(self, action: #selector(closeToolsViewButtonTapped(_:)), for: .touchUpInside)
		return button
	}()
	lazy var toolsButtonsArray = [pencilButton, eraseButton, lineWidthButton, undoButton, clearButton, shareButton, changeBackgroundButton]
	var toolsButtonsStackView = UIStackView()
	let backgroundColorsChooseView = SetBackgroundColorsView(textFont: UIFont.systemFont(ofSize: 17, weight: .medium), button1Color: #colorLiteral(red: 0.6964710762, green: 0.5762614058, blue: 1, alpha: 1), button2Color: #colorLiteral(red: 0.5945423615, green: 0.9970377582, blue: 1, alpha: 1), button3Color: #colorLiteral(red: 0.6286100223, green: 1, blue: 0.647058962, alpha: 1), button4Color: #colorLiteral(red: 0.9367815348, green: 1, blue: 0.5735278212, alpha: 1), button5Color: #colorLiteral(red: 1, green: 0.8438047002, blue: 0.6586926848, alpha: 1), button6Color: #colorLiteral(red: 1, green: 0.5961626766, blue: 0.5962358176, alpha: 1), button7Color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), button8Color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
	var lineWidthSliderHidden = true
	var bgColorChooseViewHidden = true
	var colorsViewShown = true
	var toolsViewShown = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		canvas.frame = view.frame
		view = canvas
		canvas.backgroundColor = .white
		setupLayouts()
		configuratingControlsTargets()
		setupGesture()
	}
	
	override func viewDidLayoutSubviews() {
		self.lineWidthSlider.frame.origin.x -= (205 + toolsView.frame.width)
		self.backgroundColorsChooseView.frame.origin.x -= (205 + self.toolsView.frame.width)
		self.closeToolsViewButton.frame.origin.x += 20
	}
	
}

//MARK: - creating buttons targets
extension DrawingViewController {
	
	fileprivate func configuratingControlsTargets() {
		backgroundColorsChooseView.buttonColor1.addTarget(self, action: #selector(bgColorChosen(_:)), for: .touchUpInside)
		backgroundColorsChooseView.buttonColor2.addTarget(self, action: #selector(bgColorChosen(_:)), for: .touchUpInside)
		backgroundColorsChooseView.buttonColor3.addTarget(self, action: #selector(bgColorChosen(_:)), for: .touchUpInside)
		backgroundColorsChooseView.buttonColor4.addTarget(self, action: #selector(bgColorChosen(_:)), for: .touchUpInside)
		backgroundColorsChooseView.buttonColor5.addTarget(self, action: #selector(bgColorChosen(_:)), for: .touchUpInside)
		backgroundColorsChooseView.buttonColor6.addTarget(self, action: #selector(bgColorChosen(_:)), for: .touchUpInside)
		backgroundColorsChooseView.buttonColor7.addTarget(self, action: #selector(bgColorChosen(_:)), for: .touchUpInside)
		backgroundColorsChooseView.buttonColor8.addTarget(self, action: #selector(bgColorChosen(_:)), for: .touchUpInside)
	}
}

//MARK: - custom methods for VC
extension DrawingViewController: UIGestureRecognizerDelegate {
	
	fileprivate func setupLayouts() {
		
		toolsButtonsStackView = UIStackView(arrangedSubviews: [pencilButton, eraseButton, lineWidthButton, undoButton ,clearButton, changeBackgroundButton, shareButton])
		colorButtonsStackView = UIStackView(arrangedSubviews: [redButton, greenButton, blueButton, yellowButton, cyanButton, pinkButton, lightGrayButton, darkGrayButton, blackButton, whiteButton])
		toolsButtonsStackView.axis = .vertical
		toolsButtonsStackView.distribution = .equalSpacing
		colorButtonsStackView.distribution = .equalSpacing
		colorsView.backgroundColor = #colorLiteral(red: 0.9136064404, green: 0.9136064404, blue: 0.9136064404, alpha: 1)
		colorsView.layer.borderWidth = 1.5
		colorsView.layer.borderColor = UIColor.darkGray.cgColor
		colorsView.layer.cornerRadius = 15
		toolsView.backgroundColor = #colorLiteral(red: 0.9136064404, green: 0.9136064404, blue: 0.9136064404, alpha: 1)
		toolsView.layer.borderWidth = 1.5
		toolsView.layer.borderColor = UIColor.darkGray.cgColor
		toolsView.layer.cornerRadius = 15
		lineWidthSlider.value = 2.0
		lastChoosenButtonColor = blackButton
		toolsView.addSubview(toolsButtonsStackView)
		colorsView.addSubview(colorButtonsStackView)

		Helper.addSubviews(to: view, subviews: [closeColorsViewButton, lineWidthSlider, backgroundColorsChooseView, closeToolsViewButton, colorsView, toolsView])
		Helper.tamicOff(forSubviews: [closeToolsViewButton, closeColorsViewButton, backgroundColorsChooseView, lineWidthSlider, toolsButtonsStackView, colorButtonsStackView, colorsView, toolsView])
		
		//colors view constraints
		NSLayoutConstraint.activate([
			colorsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
			colorsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
			colorsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
			colorsView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
		])
		
		//tools view constraints
		NSLayoutConstraint.activate([
			toolsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -30),
			toolsView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
			toolsView.heightAnchor.constraint(equalToConstant: 430),
			toolsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
		])
		
		//colors stack view constraints
		NSLayoutConstraint.activate([
			colorButtonsStackView.leadingAnchor.constraint(equalTo: colorsView.leadingAnchor, constant: 10),
			colorButtonsStackView.bottomAnchor.constraint(equalTo: colorsView.topAnchor, constant: 40),
			colorButtonsStackView.trailingAnchor.constraint(equalTo: colorsView.trailingAnchor, constant: -10),
			colorButtonsStackView.topAnchor.constraint(equalTo: colorsView.topAnchor, constant: 10)
		])
		
		//tools stack view constraints
		NSLayoutConstraint.activate([
			toolsButtonsStackView.topAnchor.constraint(equalTo: toolsView.topAnchor, constant: 15),
			toolsButtonsStackView.bottomAnchor.constraint(equalTo: toolsView.bottomAnchor, constant: -15),
			toolsButtonsStackView.leadingAnchor.constraint(equalTo: toolsView.trailingAnchor, constant: -50),
			toolsButtonsStackView.trailingAnchor.constraint(equalTo: toolsView.trailingAnchor, constant: -10)
		])
		
		colorButtonsStackView.layoutIfNeeded()
		toolsButtonsStackView.layoutIfNeeded()
		setButtonsCornerRadius(buttons: [redButton, greenButton, blueButton, yellowButton, cyanButton, pinkButton, lightGrayButton, darkGrayButton, blackButton, whiteButton])
		
		//tools buttons size constraints
		NSLayoutConstraint.activate([
			undoButton.heightAnchor.constraint(equalToConstant: toolsButtonsStackView.frame.width),
			clearButton.heightAnchor.constraint(equalToConstant: toolsButtonsStackView.frame.width),
			shareButton.heightAnchor.constraint(equalToConstant: toolsButtonsStackView.frame.width),
			eraseButton.heightAnchor.constraint(equalToConstant: toolsButtonsStackView.frame.width),
			changeBackgroundButton.heightAnchor.constraint(equalToConstant: toolsButtonsStackView.frame.width),
			pencilButton.heightAnchor.constraint(equalToConstant: toolsButtonsStackView.frame.width),
			lineWidthButton.heightAnchor.constraint(equalToConstant: toolsButtonsStackView.frame.width)
		])
		
		toolsView.layoutIfNeeded()
		//calculating distance between top of stack view and element middle of Y axis by number
		let toolsElementHeight = Int(toolsView.frame.height) / toolsButtonsArray.count
		let topConstantToElement = {(number: Int) -> CGFloat in
			let dimension = ((number - 1) * toolsElementHeight + toolsElementHeight / 2)
			return CGFloat(dimension)
		}
		
		//line width slider activate
		NSLayoutConstraint.activate([
			lineWidthSlider.leadingAnchor.constraint(equalTo: toolsView.trailingAnchor, constant: 4),
			lineWidthSlider.trailingAnchor.constraint(equalTo: toolsView.trailingAnchor, constant: 200),
			lineWidthSlider.heightAnchor.constraint(equalToConstant: 42),
			lineWidthSlider.centerYAnchor.constraint(equalTo: toolsView.topAnchor, constant: topConstantToElement(3))
		])
		
		//background colors view
		NSLayoutConstraint.activate([
			backgroundColorsChooseView.leadingAnchor.constraint(equalTo: toolsView.trailingAnchor, constant: 2),
			backgroundColorsChooseView.trailingAnchor.constraint(equalTo: toolsView.trailingAnchor, constant: 200),
			backgroundColorsChooseView.centerYAnchor.constraint(equalTo: toolsView.topAnchor, constant: topConstantToElement(6)),
			backgroundColorsChooseView.heightAnchor.constraint(equalToConstant: CGFloat(Float(toolsElementHeight) * 2.8))
		])
		
		//constraints for close button for pen colors choose view
		NSLayoutConstraint.activate([
			closeColorsViewButton.bottomAnchor.constraint(equalTo: colorsView.topAnchor, constant: 5),
			closeColorsViewButton.widthAnchor.constraint(equalToConstant: 45),
			closeColorsViewButton.heightAnchor.constraint(equalToConstant: 45),
			closeColorsViewButton.trailingAnchor.constraint(equalTo: colorsView.trailingAnchor, constant: -23)
		])
		
		//constraints for close tools view button
		NSLayoutConstraint.activate([
			closeToolsViewButton.bottomAnchor.constraint(equalTo: toolsView.topAnchor, constant: 1),
			closeToolsViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
			closeToolsViewButton.widthAnchor.constraint(equalToConstant: 40),
			closeToolsViewButton.heightAnchor.constraint(equalToConstant: 40)
		])
		
	}
	
	fileprivate func setupGesture() {
		let gesture = UITapGestureRecognizer(target: self, action: #selector(closeToolBars))
		gesture.delegate = self
		view.addGestureRecognizer(gesture)
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return touch.view == self.view
	}
	
	fileprivate func configuratingButton(with color: UIColor) -> UIButton {
		let button = UIButton(type: .system)
		button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		button.backgroundColor = color
		button.tintColor = .clear
		button.layer.borderWidth = 1.7
		if color == UIColor.black {
			button.isSelected = true
			button.layer.borderColor = UIColor.link.cgColor
		}
		button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
		return button
	}
	
	fileprivate func setButtonsCornerRadius(buttons: [UIButton]) {
		for button in buttons {
			button.layer.cornerRadius = colorButtonsStackView.frame.height / 2
		}
	}
	
	fileprivate func setColorsToCanvasBG() {
		lineWidthSlider.minimumTrackTintColor = canvas.backgroundColor
		lineWidthSlider.tintColor = canvas.backgroundColor
		canvas.setLineColor(color: canvas.backgroundColor!)
	}
	
	fileprivate func unselectAllPenColorButtons() {
		colorButtons.forEach { (button) in
			button.isSelected = false
			button.layer.borderColor = UIColor.black.cgColor
		}
	}
}



//MARK: - custom selectors for VC
extension DrawingViewController {
	
	@objc fileprivate func shareButtonTapped(_ sender: ToolsButton) {
		
		canvas.subviews.forEach { (view) in
			view.isHidden = true
		}
		let image = canvas.getImage()
		let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		shareVC.excludedActivityTypes = []
		shareVC.popoverPresentationController?.permittedArrowDirections = .any
		shareVC.popoverPresentationController?.sourceView = self.view
		self.present(shareVC, animated: true) {
			self.canvas.subviews.forEach { (view) in
				view.isHidden = false
			}
		}
	}
	
	//animation to close tools bar
	@objc fileprivate func closeToolsViewButtonTapped(_ sender: ToolsButton) {
		closeToolBars()
		closeToolsViewButton.isEnabled = false
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.67, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			if self.toolsViewShown {
				self.toolsView.frame.origin.x -= 60
				self.closeToolsViewButton.frame.origin.x -= 20
				self.closeToolsViewButton.setBackgroundImage(UIImage(systemName: "chevron.compact.right"), for: .normal)
			} else {
				self.toolsView.frame.origin.x += 60
				self.closeToolsViewButton.frame.origin.x += 20
				self.closeToolsViewButton.setBackgroundImage(UIImage(systemName: "chevron.compact.left"), for: .normal)
			}
		}) { (_) in
			self.toolsViewShown.toggle()
			self.closeToolsViewButton.isEnabled = true
		}
	}
	
	//animation to close colors bar
	@objc fileprivate func closeColorsViewButtonTapped(_ sender: ToolsButton) {
		closeColorsViewButton.isEnabled = false
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.67, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			if self.colorsViewShown {
				self.colorsView.frame.origin.y += 70
				self.closeColorsViewButton.frame.origin.y += 70
				self.closeColorsViewButton.setBackgroundImage(UIImage(systemName: "chevron.compact.up"), for: .normal)
			} else {
				self.colorsView.frame.origin.y -= 70
				self.closeColorsViewButton.frame.origin.y -= 70
				self.closeColorsViewButton.setBackgroundImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
			}
		}) { (_) in
			self.colorsViewShown.toggle()
			self.closeColorsViewButton.isEnabled = true
		}
	}
	
	@objc fileprivate func sliderWidthValueChanged(_ sender: UISlider) {
		canvas.setLineWidth(width: CGFloat(sender.value))
		if pencilButton.isSelected {
			lastChoosenLineWidth = sender.value
		}
	}
	
	@objc fileprivate func lineWidthButtonTapped() {
		lineWidthButton.isEnabled = false
		self.lineWidthSliderHidden.toggle()
		UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.77, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			if self.lineWidthSliderHidden {
				self.lineWidthSlider.frame.origin.x -= (205 + self.toolsView.frame.width)
			} else {
				self.lineWidthSlider.frame.origin.x += (205 + self.toolsView.frame.width)
			}
		}) { (_) in
			self.lineWidthButton.isEnabled = true
		}
	}
	
	//handle of properties if erase or pencil is selected
	@objc fileprivate func drawOrEraseButtonsTapped(_ sender: UIButton) {
		if sender == pencilButton {
			pencilButton.isSelected = true
			eraseButton.isSelected = false
			pencilButton.tintColor = .systemRed
			eraseButton.tintColor = .darkGray
			colorButtonTapped(lastChoosenButtonColor)
			lineWidthSlider.value = lastChoosenLineWidth
			canvas.setLineWidth(width: CGFloat(lastChoosenLineWidth))
		} else if sender == eraseButton {
			pencilButton.isSelected = false
			eraseButton.isSelected = true
			eraseButton.tintColor = .systemRed
			pencilButton.tintColor = .darkGray
			lineWidthSlider.value = 12.5
			canvas.setLineWidth(width: 12.5)
			unselectAllPenColorButtons()
			setColorsToCanvasBG()
		}
	}
	
	@objc fileprivate func bgColorChooseButtonTapped(_ sender: ToolsButton) {
		changeBackgroundButton.isEnabled = false
		self.bgColorChooseViewHidden.toggle()
		UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.77, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
			if self.bgColorChooseViewHidden {
				self.backgroundColorsChooseView.frame.origin.x -= (205 + self.toolsView.frame.width)
			} else {
				self.backgroundColorsChooseView.frame.origin.x += (205 + self.toolsView.frame.width)
			}
		}) { (_) in
			self.changeBackgroundButton.isEnabled = true
		}
	}
	
	@objc fileprivate func bgColorChosen(_ sender: UIButton) {
		canvas.backgroundColor = sender.backgroundColor
		setNeedsStatusBarAppearanceUpdate()
		setColorsToCanvasBG()
	}
	
	
	@objc fileprivate func colorButtonTapped(_ sender: UIButton) {
		if pencilButton.isSelected {	//If choosen colored for pencil work
			sender.isSelected = true
			colorButtons.forEach { (button) in
				if button != sender {
					button.isSelected = false
				}
				if button.isSelected {
					button.layer.borderColor = UIColor.link.cgColor
				} else {
					button.layer.borderColor = UIColor.black.cgColor
				}
			}
			lineWidthSlider.minimumTrackTintColor = sender.backgroundColor
			lineWidthSlider.tintColor = sender.backgroundColor
			canvas.setLineColor(color: sender.backgroundColor!)
			lastChoosenButtonColor = sender
		}
		//nothing to do if choosen eraser
	}
	
	//handle undo button
	@objc fileprivate func undoButtonTapped() {
		canvas.undo()
	}
	
	@objc fileprivate func clearButtonTapped() {
		let alert = UIAlertController(title: "Clearing canvas", message: "Are you sure?", preferredStyle: .actionSheet)
		let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
			self.canvas.deleteAllLines()
		}
		let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
		alert.addAction(yesAction)
		alert.addAction(noAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc private func closeToolBars() {
		if !lineWidthSliderHidden {
			lineWidthButtonTapped()
		}
		if !bgColorChooseViewHidden {
			bgColorChooseButtonTapped(changeBackgroundButton)
		}
	}
}


extension DrawingViewController {
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if canvas.backgroundColor == UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1){
			return .lightContent
		} else {
			return .darkContent
		}
	}
}
