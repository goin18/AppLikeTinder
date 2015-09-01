//
//  CardsViewController.swift
//  AppLikeTinder
//
//  Created by Marko Budal on 30/08/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, SwipeViewDelegate {

    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
    }
    
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMargin: CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    
    var backCard:Card?
    var frontCard:Card?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToProfile:")
        
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardStackView.backgroundColor = UIColor.clearColor()
        
        backCard = createCard(backCardTopMargin)
        cardStackView.addSubview(backCard!.swipeView)
        
        frontCard = createCard(frontCardTopMargin)
        cardStackView.addSubview(frontCard!.swipeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createCardFrame(topMargin:CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(topMargin: CGFloat) -> Card {
        let cardView = CardView()
        let swipeView = SwipeView(frame: createCardFrame(topMargin))
        
        swipeView.delegate = self
        swipeView.innerView = cardView
        
        return Card(cardView: cardView, swipeView: swipeView)
    }
    
    func goToProfile(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    //SwipeDelegate
    func swipeLeft(){
        println("Left")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }
    
    func swipeRight(){
        println("Right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
        }
    }
}
