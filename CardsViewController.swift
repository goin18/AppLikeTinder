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
        let user: User
    }
    
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMargin: CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    @IBOutlet weak var nahButton: UIButton!
    @IBOutlet weak var yeahButton: UIButton!
    
    var backCard:Card?
    var frontCard:Card?
    
    var users: [User]?
    
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
        
        nahButton.setImage(UIImage(named: "nah-button-pressed"), forState: UIControlState.Highlighted)
        yeahButton.setImage(UIImage(named: "yeah-button-pressed"), forState: UIControlState.Highlighted)
        
//        backCard = createCard(backCardTopMargin)
//        cardStackView.addSubview(backCard!.swipeView)
//        
//        frontCard = createCard(frontCardTopMargin)
//        cardStackView.addSubview(frontCard!.swipeView)
        
        fatchUnviewedUsers({
            retutnedUsers in
                self.users = retutnedUsers
            
                if let card = self.popCard() {
                    self.frontCard = card
                    self.cardStackView.addSubview(self.frontCard!.swipeView)
                }
            
                if let card = self.popCard() {
                    self.backCard = card
                    self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                    self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
                }
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nahButtonPressed(sender: UIButton) {
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Left)
        }
    }

    @IBAction func yeahButtonPressed(sender: UIButton) {
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Right)
        }
    }
    
    private func createCardFrame(topMargin:CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(user: User) -> Card {
        let cardView = CardView()
        
        cardView.name = user.name
        user.getPhoto({image in
            cardView.image = image
        })
        
        
        let swipeView = SwipeView(frame: createCardFrame(0))
        
        swipeView.delegate = self
        swipeView.innerView = cardView
        
        return Card(cardView: cardView, swipeView: swipeView, user: user)
    }
    
    private func popCard() -> Card? {
        if users != nil && users?.count > 0 {
            return createCard(users!.removeLast())
        }
        return nil
    }
    
    private func switchCards() {
        if let card = backCard {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.frontCard?.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
        }
        
        if let card = self.popCard() {
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        }
    }
    
    func goToProfile(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    //SwipeDelegate
    func swipeLeft(){
        println("Left")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveSkip(frontCard.user)
            switchCards()
        }
    }
    
    func swipeRight(){
        println("Right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveLike(frontCard.user)
            switchCards()
            
        }
    }
}
