//
//  Helper.swift
//  App_SimpleCanvas
//
//  Created by MacBook Air on 01.06.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

struct Helper {
	
	static func addSubviews(to superview: UIView, subviews: [UIView]) {
		for view in subviews {
			superview.addSubview(view)
		}
	}
	
	static func tamicOff(forSubviews subviews: [UIView]) {
		for view in subviews {
			view.translatesAutoresizingMaskIntoConstraints = false
		}
	}
	
	
	
}
