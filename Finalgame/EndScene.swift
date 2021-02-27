//
//  EndScene.swift
//  Finalgame
//
//  Created by harpanth kaur on 2021-02-23.
//

import Foundation
import SpriteKit
import UIKit

class EndScene: SKScene,UITextFieldDelegate
{
    var bg = SKEmitterNode()
    var scorelabel:UITextField!
    var playlabel:UITextField!
    var highscr:UITextField!
    var gameover:UITextField!
    
    override func didMove(to view: SKView) {
    
        scene?.backgroundColor = UIColor.black
        bg = SKEmitterNode(fileNamed: "endgame")!
       bg.position = CGPoint(x: 0, y: 1472)
        bg.advanceSimulationTime(10)
        self.addChild(bg)
               logo()
        labels()
        
    }
    
    func logo(){
        let addlogo = SKSpriteNode(imageNamed: "gamelogo")
        addlogo.size = CGSize(width: frame.size.width / 2, height: frame.size.width / 4)
        addlogo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height / 4)
        addChild(addlogo)
           //labels()
    }
    func labels()
    {
        gameover = UITextField(frame: CGRect(x: self.frame.width/2 + 100 ,  y: self.frame.height/2 + 10, width: 320, height: 40))
        gameover.text = "Game Over"
        
        gameover.textColor = UIColor.white
     
        gameover.font = UIFont.init(name: "Chalkduster", size: 20)
        view?.addSubview(gameover)
        
        highscr = UITextField(frame: CGRect(x: self.frame.width/2 + 50,  y: self.frame.height/2 + 300, width: 320, height: 40))
        highscr.text = "Highscore: " + "\(UserDefaults.standard.integer(forKey: "highscore"))"
        highscr.textColor = UIColor.white
        highscr.font = UIFont.init(name: "AvenirNext-Bold", size: 20)
        view?.addSubview(highscr)
        
        playlabel = UITextField(frame: CGRect(x: self.frame.width/2 + 50,  y: self.frame.height/2 + 250, width: 320, height: 40))
        playlabel.text = "Tap at logo to Restart"
        playlabel.textColor = UIColor.white
        playlabel.font = UIFont.init(name: "Chalkduster", size: 20)
        view?.addSubview(playlabel)
        
         scorelabel = UITextField(frame: CGRect(x: self.frame.width/2 + 50,  y: self.frame.height/2 + 350, width: 320, height: 40))
        scorelabel.text = "Recent score: " + "\(UserDefaults.standard.integer(forKey: "recentscore"))"
        scorelabel.textColor = UIColor.white
        scorelabel.font = UIFont.init(name: "AvenirNext-Bold", size: 20)
        view?.addSubview(scorelabel)
        
      
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gamescene =  shootingScene(size: view!.bounds.size)
        highscr.removeFromSuperview();
        scorelabel.removeFromSuperview();
        playlabel.removeFromSuperview();
        gameover.removeFromSuperview();
        view!.presentScene(gamescene)
    }
    
  
    }
