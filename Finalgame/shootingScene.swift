//
//  shootingScene.swift
//  Finalgame
//
//  Created by harpanth kaur on 2021-02-23.
//

import Foundation
import SpriteKit
import CoreMotion
import GameplayKit
enum collidertype:UInt32 {
    case Player = 1
    case enemy = 2
    case bullet = 4
}
class shootingScene: SKScene,SKPhysicsContactDelegate {
   var starfield:SKEmitterNode!
    var bg:SKSpriteNode!
    var player:SKSpriteNode!
   var gameover = false
    var scoreLabel:SKLabelNode!
    var life_0: SKSpriteNode!
        var life_1: SKSpriteNode!
         var life_2: SKSpriteNode!
    var point:Int = 3
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer:Timer!
    
    var possibleAliens = ["alien1", "alien2", "alien3"]
    

    
   let motionManger = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
  
    
    override func didMove(to view: SKView) {
      //  self.view?.backgroundColor = .black
  /*  bg = SKSpriteNode(imageNamed: "bg")
        bg.position = CGPoint(x:self.size.width/2 ,y:self.size.height/2)
        bg.size.width = self.frame.width
       
     
     bg.zPosition = -2
        self.addChild(bg)*/
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        player = SKSpriteNode(imageNamed: "Spaceship")
        player.size = CGSize(width: 80, height: 80);
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size);
        player.physicsBody!.isDynamic = false
        player.physicsBody!.contactTestBitMask = collidertype.enemy.rawValue
        player.physicsBody!.categoryBitMask = collidertype.Player.rawValue
        player.physicsBody!.collisionBitMask = collidertype.Player.rawValue
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
                self.addChild(player)
        
       
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 60, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 26
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        life_0 = SKSpriteNode(imageNamed: "life1")
        life_0.size = CGSize(width: 20, height: 20)
        life_1 = SKSpriteNode(imageNamed: "life2")
        life_1.size = CGSize(width: 20, height: 20)
        life_2 = SKSpriteNode(imageNamed: "life3")
        life_2.size = CGSize(width: 20, height: 20)
        life_0.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.size.height - 60)
        life_1.position = CGPoint(x: self.frame.maxX - 30, y: self.frame.size.height - 60)
        life_2.position = CGPoint(x: self.frame.maxX - 10, y: self.frame.size.height - 60)
        self.addChild(life_0)
        self.addChild(life_1)
        self.addChild(life_2)
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        
        motionManger.accelerometerUpdateInterval = 0.2
        motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
        
        
        }
        
    }
    
    
    
    
      @objc  func addAlien () {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        alien.size = CGSize(width: 50, height: 50);
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        
        
        alien.physicsBody?.categoryBitMask = collidertype.enemy.rawValue
        alien.physicsBody?.contactTestBitMask = collidertype.bullet.rawValue
        alien.physicsBody?.collisionBitMask = 0
        alien.physicsBody?.affectedByGravity = false
        alien.physicsBody?.isDynamic = true;
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
        
    
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    
    func fireTorpedo() {
        //self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = collidertype.bullet.rawValue
        torpedoNode.physicsBody?.contactTestBitMask = collidertype.enemy.rawValue
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.affectedByGravity = false
        torpedoNode.physicsBody?.isDynamic = false
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 0.3
        
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
        
        
        
        
    }
   
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody:SKPhysicsBody = contact.bodyA
        let secondBody:SKPhysicsBody = contact.bodyB
        
      
        
        if (firstBody.categoryBitMask == collidertype.enemy.rawValue) && (secondBody.categoryBitMask == collidertype.bullet.rawValue)||(firstBody.categoryBitMask == collidertype.bullet.rawValue) && (secondBody.categoryBitMask == collidertype.enemy.rawValue){
           torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
        
        else if (firstBody.categoryBitMask == collidertype.enemy.rawValue) && (secondBody.categoryBitMask == collidertype.Player.rawValue)||(firstBody.categoryBitMask == collidertype.Player.rawValue) && (secondBody.categoryBitMask == collidertype.enemy.rawValue){
           aliencollidewithpalyer()
        }
        
    }
    
    func aliencollidewithpalyer()
    {
    
            if (point==3){
                            
                           
                                life_0.removeFromParent()
                        
                               point -= 1
                           }
                        else if (point==2){
                                       
                           // let img = childNode(withName: "life2") as? SKSpriteNode
                                           
                                           life_1.removeFromParent()
                                   
                                    point -= 1
                                      }
                        else if (point==1){
                                       
                            //let img = childNode(withName: "life1") as? SKSpriteNode
                                           
                                           life_2.removeFromParent()
                            point -= 1
                        }
          
             else if (point==0)
             {
                            func displaygameover(){
                                
                                UserDefaults.standard.set(score, forKey: "recentscore")
                                if score > UserDefaults.standard.integer(forKey: "highscore"){
                                    UserDefaults.standard.set(score, forKey: "highscore")
                                       
                                }
                             //   torpedoNode.removeFromParent()
                          //  playerNode.removeFromParent()
                            self.view!.presentScene(EndScene())
                            }
                displaygameover()
                        }
            
           // print(point)
           
          }
    
    func torpedoDidCollideWithcoin (torpedoNode:SKSpriteNode, coinNode:SKSpriteNode) {
    
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = coinNode.position
      addChild(explosion)
        
       // run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        coinNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 1
        
        
    }
    
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode) {
    
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
      addChild(explosion)
        
       // run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 2
        
        
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        }else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
    }
    
  
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch: AnyObject in touches{
        let location = touch.location(in: self)
        player.position.x = location.x
        
        
    }
   }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
     
        }
       

