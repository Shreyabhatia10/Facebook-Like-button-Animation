//
//  ViewController.swift
//  Like_animation
//
//  Created by Shreya Bhatia on 09/04/19.
//  Copyright © 2019 Shreya Bhatia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let backgroundLabel: UILabel = {
        let backgroundLabel = UILabel()
        backgroundLabel.textAlignment = .center //For center alignment
        backgroundLabel.text = "Tap and hold anywhere..."
        backgroundLabel.textColor = .white
//        backgroundLabel.backgroundColor = .lightGray//If required
        backgroundLabel.font = UIFont(name: "Helvetica Neue", size: 30)
        
        //To display multiple lines in label
        backgroundLabel.numberOfLines = 0 //If you want to display only 2 lines replace 0(Zero) with 2.
        backgroundLabel.lineBreakMode = .byWordWrapping
        return backgroundLabel
    }()
    
    let iconContainerView: UIView = {
       let containerView = UIView()
        containerView.backgroundColor = .white
        
        let iconHeight: CGFloat = 38
        let padding: CGFloat = 4
        
        let images = [#imageLiteral(resourceName: "like"), #imageLiteral(resourceName: "in-love"), #imageLiteral(resourceName: "crying"), #imageLiteral(resourceName: "happy"), #imageLiteral(resourceName: "sad"), #imageLiteral(resourceName: "thinking")]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            
            // reuired for hit
            imageView.isUserInteractionEnabled = true
        
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        let numIcon = CGFloat(arrangedSubviews.count)
        let width = numIcon * iconHeight + (numIcon + 1) * padding
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height/2
        
        //shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackView.frame = containerView.frame
        return containerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        view.addSubview(backgroundLabel)
        backgroundLabel.frame = view.frame
        
        setupLongPressGesture()
    }
    
    fileprivate func setupLongPressGesture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:))))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            
            //clear animation
    
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                self.iconContainerView.transform = self.iconContainerView.transform.translatedBy(x: 0, y: 50)
                self.iconContainerView.alpha = 0
                
            }) { (_) in
                self.iconContainerView.removeFromSuperview()
            }
            
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
        
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconContainerView)
        
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconContainerView.frame.height / 2)
        
        let hitTestView = iconContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconContainerView)
        
        let pressedLocation = gesture.location(in: self.view)
        let centerX = (view.frame.width - iconContainerView.frame.width)/2
        let yLocation = pressedLocation.y - iconContainerView.frame.height
        
        //alpha
        iconContainerView.alpha = 0
        self.iconContainerView.transform = CGAffineTransform(translationX: centerX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.iconContainerView.alpha = 1
            self.iconContainerView.transform = CGAffineTransform(translationX: centerX, y: yLocation)
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

