//
//  UIButton_extension.swift
//  Lesson8_drawing
//
//  Created by MacBook Air on 30.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

//this property will animated buttons tint color in highlighted state
class ToolsButton: UIButton {
	override open var isHighlighted: Bool {
		willSet {
			self.tintColor = (newValue) ? .systemRed : .darkGray
		}
	}
	
}


class BackgroundColorButton: UIButton {
	override open var isHighlighted: Bool {
		willSet {
			if newValue {
				self.layer.borderColor = UIColor.systemRed.cgColor
			} else {
				self.layer.borderColor = UIColor.black.cgColor
				
			}
		}
	}
	
}
