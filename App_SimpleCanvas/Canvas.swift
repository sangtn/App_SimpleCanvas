//
//  Canvas.swift
//  Lesson8_drawing
//
//  Created by MacBook Air on 29.03.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class Canvas: UIView {

    private var lines = [Line]()
	private var lineWidth: CGFloat = 2.0
	private var lineColor: CGColor = UIColor.black.cgColor
    
	//drawing lines from point to point
    override func draw(_ rect: CGRect) {
		super.draw(rect)
        
		guard let context = UIGraphicsGetCurrentContext() else { return }
		context.setLineCap(.round)
		lines.forEach { (line) in
			context.setLineWidth(line.width)
			context.setStrokeColor(line.color)
			for (i,p) in line.points.enumerated() {
				
				if i == 0 {
					context.move(to: p)
				} else {
					context.addLine(to: p)
				}
			}
			context.strokePath()
		}
		
    }
    
	//append new first line to the array of lines, if user touch the screen
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		lines.append(Line(color: lineColor, width: lineWidth, points: [CGPoint]()))
	}
	
	//adding lines one by one to the array of model if user moves along the screen
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let point = touches.first?.location(in: self) else { return }
		guard var lastLine = lines.popLast() else { return }
		lastLine.points.append(point)
		lines.append(lastLine)
		setNeedsDisplay()
	}
	
	public func setLineColor(color: UIColor) {
		lineColor = color.cgColor
	}
	
	public func setLineWidth(width: CGFloat) {
		lineWidth = width
	}
	
	public func undo() {
		let _ = lines.popLast()
		setNeedsDisplay()
	}
	
	public func deleteAllLines() {
		lines.removeAll()
		setNeedsDisplay()
	}
	
	public func getImage() -> UIImage {
		if #available(iOS 10.0, *) {
			let renderer = UIGraphicsImageRenderer(bounds: bounds)
			return renderer.image { context in
				layer.render(in: context.cgContext)
			}
		} else {
			UIGraphicsBeginImageContext(frame.size)
			self.layer.render(in: UIGraphicsGetCurrentContext()!)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return UIImage(cgImage: image!.cgImage!)
		}
	}
	
}
