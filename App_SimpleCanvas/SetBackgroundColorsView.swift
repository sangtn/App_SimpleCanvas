//
//  SetBackgroundColorsView.swift
//  Lesson8_drawing
//
//  Created by MacBook Air on 31.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

//MARK: configurating buttons for background colors

class SetBackgroundColorsView: UIView {
	
	lazy var buttonColor1 = configColorButton()
	lazy var buttonColor2 = configColorButton()
	lazy var buttonColor3 = configColorButton()
	lazy var buttonColor4 = configColorButton()
	lazy var buttonColor5 = configColorButton()
	lazy var buttonColor6 = configColorButton()
	lazy var buttonColor7 = configColorButton()
	lazy var buttonColor8 = configColorButton()

	init(textFont: UIFont, button1Color: UIColor, button2Color: UIColor, button3Color: UIColor, button4Color: UIColor, button5Color: UIColor, button6Color: UIColor, button7Color: UIColor, button8Color: UIColor) {
		super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
		
		let label = UILabel()
		label.text = "Background color"
		label.textColor = .black
		label.font = textFont
		label.textAlignment = .center
		self.backgroundColor = #colorLiteral(red: 0.9136064404, green: 0.9136064404, blue: 0.9136064404, alpha: 1)
		self.layer.cornerRadius = 13
		self.layer.borderColor = UIColor.darkGray.cgColor
		self.layer.borderWidth = 1.5
		self.buttonColor1.backgroundColor = button1Color
		self.buttonColor2.backgroundColor = button2Color
		self.buttonColor3.backgroundColor = button3Color
		self.buttonColor4.backgroundColor = button4Color
		self.buttonColor5.backgroundColor = button5Color
		self.buttonColor6.backgroundColor = button6Color
		self.buttonColor7.backgroundColor = button7Color
		self.buttonColor8.backgroundColor = button8Color
		let firstColorsStackView = UIStackView(arrangedSubviews: [buttonColor1, buttonColor2, buttonColor3, buttonColor4])
		let secondColorsStackView = UIStackView(arrangedSubviews: [buttonColor5, buttonColor6, buttonColor7, buttonColor8])
		
		firstColorsStackView.distribution = .equalSpacing
		secondColorsStackView.distribution = .equalSpacing

		Helper.addSubviews(to: self, subviews: [label, firstColorsStackView, secondColorsStackView])
		Helper.tamicOff(forSubviews: [label, firstColorsStackView, secondColorsStackView])
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			label.leadingAnchor.constraint(equalTo: leadingAnchor),
			label.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
		
		NSLayoutConstraint.activate([
			firstColorsStackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
			firstColorsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			firstColorsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
		])
		
		NSLayoutConstraint.activate([
			secondColorsStackView.topAnchor.constraint(equalTo: firstColorsStackView.bottomAnchor, constant: 20),
			secondColorsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			secondColorsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
			secondColorsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
		])
		
		firstColorsStackView.layoutIfNeeded()
		secondColorsStackView.layoutIfNeeded()
		
		setupCornerRadius(forButtons: [buttonColor1, buttonColor2, buttonColor3, buttonColor4], value: firstColorsStackView.frame.height / 2)
		setupCornerRadius(forButtons: [buttonColor5, buttonColor6, buttonColor7, buttonColor8], value: secondColorsStackView.frame.height / 2)
		
	}
	
	private func setupCornerRadius(forButtons buttons: [UIButton], value: CGFloat) {
		for button in buttons {
			button.layer.cornerRadius = value
		}
	}
	
	
	private func configColorButton() -> UIButton {
		let button = BackgroundColorButton(type: .system)
		button.tintColor = .clear
		button.layer.borderWidth = 1.5
		return button
	}

	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
