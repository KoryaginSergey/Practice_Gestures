//
//  ViewController.swift
//  Practice_Gestures
//
//  Created by Admin on 07.07.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var redView: UIView!
    
    @IBOutlet weak var centreXConstraint: NSLayoutConstraint!
    @IBOutlet weak var centreYConstraint: NSLayoutConstraint!
    
    let panGestureRecognizer = UIPanGestureRecognizer()
    let pinchGestureRecognizer = UIPinchGestureRecognizer()
    let rotationGestureRecognizer = UIRotationGestureRecognizer()
    let tapGestureRecognizer = UITapGestureRecognizer()
    var panGestureAnchorPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        redView.addGestureRecognizer(panGestureRecognizer)
        
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture(_:)))
        redView.addGestureRecognizer(pinchGestureRecognizer)
        
        rotationGestureRecognizer.addTarget(self, action: #selector(handleRotationGesture(_:)))
        redView.addGestureRecognizer(rotationGestureRecognizer)
        
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture(_:)))
        redView.addGestureRecognizer(tapGestureRecognizer)
        
        pinchGestureRecognizer.delegate = self
        rotationGestureRecognizer.delegate = self
        panGestureRecognizer.delegate = self
        tapGestureRecognizer.delegate = self
    }
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            panGestureAnchorPoint = gestureRecognizer.location(in: view)
        case .changed:
            guard let panGestureAnchorPoint = panGestureAnchorPoint else {return}
            let gesturePoint = gestureRecognizer.location(in: view)
            
            centreXConstraint.constant += gesturePoint.x - panGestureAnchorPoint.x
            centreYConstraint.constant += gesturePoint.y - panGestureAnchorPoint.y
            
            self.panGestureAnchorPoint = gesturePoint
            
        case .cancelled, .ended:
            panGestureAnchorPoint = nil
        case .failed, .possible:
            break
        default:
            break
        }
    }
    
    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .changed, .began:
            redView.transform = CGAffineTransform.identity.scaledBy(x: gestureRecognizer.scale,
                                                                    y: gestureRecognizer.scale)
        default:
            break
        }
    }
    
    @objc func handleRotationGesture(_ gestureRecognizer: UIRotationGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .changed, .began:
            redView.transform = CGAffineTransform.identity.rotated(by: gestureRecognizer.rotation)
        default:
            break
        }
    }
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        redView.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1),
                                          blue: .random(in: 0...1), alpha: 1.0)
        
        centreXConstraint.constant = 0
        centreYConstraint.constant = 0
        redView.transform = .identity
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        let simultaneousRecognizers = [rotationGestureRecognizer, pinchGestureRecognizer,
                                       panGestureRecognizer, tapGestureRecognizer]
        return simultaneousRecognizers.contains(gestureRecognizer) &&
               simultaneousRecognizers.contains(otherGestureRecognizer)
    }
}
