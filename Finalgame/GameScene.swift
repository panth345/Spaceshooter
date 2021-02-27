//
//  GameScene.swift
//  Finalgame
//
//  Created by harpanth kaur on 2021-02-23.
//

import Foundation
import SpriteKit
import UIKit
protocol TransitionDelegate: SKSceneDelegate {
    func showAlert(title:String,message:String)
    func handleLoginBtn(username:String,password:String)
    func handleFacebookBtn()
    func handleTwitterBtn()
}
class GameScene: SKScene,UITextFieldDelegate {
    var usernameTextField:UITextField!
    var passwordTextField:UITextField!
    var loginBtn:SKShapeNode!
    var facebookBtn:SKShapeNode!
    var twitterBtn:SKShapeNode!
    override func didMove(to view: SKView) {
        //bg
        let bg = SKSpriteNode(imageNamed: "apple-wallpaper")
        addChild(bg)
        bg.position = CGPoint(x:self.size.width/2,y:self.size.height/2)
        //title
        let title = SKLabelNode.init(fontNamed: "AppleSDGothicNeo-Bold")
        title.text = "Shooting game"; title.fontSize = 25
        title.fontColor = .orange
        addChild(title)
        title.zPosition = 1
        title.position = CGPoint(x:self.size.width/2,y:self.size.height-80)
        //textfields
        guard let view = self.view else { return }
        let originX = (view.frame.size.width - view.frame.size.width/1.5)/2
        usernameTextField = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5, width: view.frame.size.width/1.5, height: 30))
        customize(textField: usernameTextField, placeholder: "Enter your username")
        view.addSubview(usernameTextField)
        usernameTextField.addTarget(self, action:#selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        passwordTextField = UITextField(frame: CGRect.init(x: originX, y: view.frame.size.height/4.5+60, width: view.frame.size.width/1.5, height: 30))
        customize(textField: passwordTextField, placeholder: "Enter your password", isSecureTextEntry:true)
        view.addSubview(passwordTextField)
        //buttons
        //let myBlue = SKColor(colorLiteral, Red: 59/255, green: 89/255, blue: 153/255, alpha: 1)
        loginBtn = getButton(frame: CGRect(x:self.size.width/4,y:self.size.height/2,width:self.size.width/2,height:30),fillColor:SKColor.blue,title:"Login",logo:nil,name:"loginBtn")
        addChild(loginBtn)
        loginBtn.zPosition = 1
        let label = SKLabelNode.init(fontNamed: "AppleSDGothicNeo-Regular")
        label.text = "or connect with"; label.fontSize = 15
        label.fontColor = .white
        addChild(label)
        label.zPosition = 1
        label.position = CGPoint(x:self.size.width/2,y:self.size.height/2-30)
        let logoFb = SKSpriteNode.init(imageNamed: "facebook-icon")
        logoFb.size = CGSize(width: 40, height: 40)
        logoFb.setScale(0.5)
        facebookBtn = getButton(frame: CGRect(x:self.size.width/4,y:self.size.height/2-80,width:self.size.width/4.5,height:30),fillColor:SKColor.blue,logo:logoFb,name:"facebookBtn")
        addChild(facebookBtn)
        facebookBtn.zPosition = 1
      //  let myCyan = SKColor(colorLiteralRed: 85/255, green: 172/255, blue: 239/255, alpha: 1)
        let logoTw = SKSpriteNode.init(imageNamed: "twitter-icon")
        logoTw.setScale(0.5)
        logoTw.size = CGSize(width: 20, height: 20)
        twitterBtn = getButton(frame: CGRect(x:self.size.width/2,y:self.size.height/2-80,width:self.size.width/4.5,height:30),fillColor:SKColor.blue,logo:logoTw,name:"twitterBtn")
        addChild(twitterBtn)
        twitterBtn.zPosition = 1
    }
    func customize(textField:UITextField, placeholder:String , isSecureTextEntry:Bool = false) {
        let paddingView = UIView(frame:CGRect(x:0,y: 0,width: 10,height: 30))
        textField.leftView = paddingView
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.leftViewMode = UITextField.ViewMode.always
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4.0
        textField.textColor = .white
        textField.isSecureTextEntry = isSecureTextEntry
        textField.delegate = self
    }
    func getButton(frame:CGRect,fillColor:SKColor,title:String = "",logo:SKSpriteNode!,name:String)->SKShapeNode {
        let btn = SKShapeNode(rect: frame, cornerRadius: 10)
        btn.fillColor = fillColor
        btn.strokeColor = fillColor
        if let l = logo {
            btn.addChild(l)
            l.zPosition = 2
            l.position = CGPoint(x:frame.origin.x+(frame.size.width/2),y:frame.origin.y+(frame.size.height/2))
            l.name = name
        }
        if !title.isEmpty {
            let label = SKLabelNode.init(fontNamed: "AppleSDGothicNeo-Regular")
            label.text = title; label.fontSize = 15
            label.fontColor = .white
            btn.addChild(label)
            label.zPosition = 3
            label.position = CGPoint(x:frame.origin.x+(frame.size.width/2),y:frame.origin.y+(frame.size.height/4))
            label.name = name
        }
        btn.name = name
        return btn
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name {
            switch name {
                case "loginBtn":
                    self.run(SKAction.wait(forDuration: 0.1),completion:{[unowned self] in
                        guard let delegate = self.delegate else { return }
                        (delegate as! TransitionDelegate).handleLoginBtn(username:self.usernameTextField.text!,password: self.passwordTextField.text!)
                                let gamescene = shootingScene(size: view!.bounds.size)
                                view?.presentScene(gamescene)
                        usernameTextField.removeFromSuperview()
                        passwordTextField.removeFromSuperview()
                    })
                case "facebookBtn":
                    self.run(SKAction.wait(forDuration: 0.1),completion:{[unowned self] in
                        guard let delegate = self.delegate else { return }
                        (delegate as! TransitionDelegate).handleFacebookBtn()
                    })
                case "twitterBtn":
                    self.run(SKAction.wait(forDuration: 0.1),completion:{[unowned self] in
                        guard let delegate = self.delegate else { return }
                        (delegate as! TransitionDelegate).handleTwitterBtn()
                    })
                default:break
            }
        }
    }
    @objc func textFieldDidChange(textField: UITextField) {
        //print("everytime you type something this is fired..")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField { // validate email syntax
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: textField.text)
            let title = "Alert title"
            let message = result ? "This is a correct email" : "Wrong email syntax"
            if !result {
                self.run(SKAction.wait(forDuration: 0.01),completion:{[unowned self] in
                    guard let delegate = self.delegate else { return }
                    (delegate as! TransitionDelegate).showAlert(title:title,message: message)
                })
            }
        }
    }
    deinit {
        print("\n THE SCENE \((type(of: self))) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
}
