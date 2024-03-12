//
//  ViewController.swift
//  UIKitSpotlight
//
//  Created by Victor Hong on 2023-08-08.
//

import SwiftUI
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "I'm a test label"
        
        
        
        self.view.addSubview(label)
    }

    func addSwiftUIView(view: UIView) {
        
        view
        
        // 1
            let vc = UIHostingController(rootView: SwiftUIView())

            let swiftuiView = vc.view!
            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
            
            // 2
            // Add the view controller to the destination view controller.
            addChild(vc)
            view.addSubview(swiftuiView)
            
            // 3
            // Create and activate the constraints for the swiftui's view.
            NSLayoutConstraint.activate([
                swiftuiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                swiftuiView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
            
            // 4
            // Notify the child view controller that the move is complete.
            vc.didMove(toParent: self)
    }
}

struct RepresentedLabeView: UIViewRepresentable {
    typealias UIViewType = UILabel
      
        func makeUIView(context: Context) -> UILabel {
            let view = UILabel()

            // Do some configurations here if needed.
            return view
        }
        
        func updateUIView(_ uiView: UILabel, context: Context) {
            // Updates the state of the specified view controller with new information from SwiftUI.
        }
}
