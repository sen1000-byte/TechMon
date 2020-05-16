//
//  BattleViewController.swift
//  TechMon
//
//  Created by Chihiro Nishiwaki on 2020/05/16.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    @IBOutlet var playerTPLable: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var player: Character!
    var enemy: Character!
    
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        
        
        playerNameLabel.text = player.name
        playerImageView.image = player.image
//        playerHPLabel.text = "\(playerHP) / 100"
//        playerMPLabel.text = "\(playerMP) / 20"
        
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
//        enemyHPLabel.text = "\(enemyHP) / 200"
//        enemyMPLabel.text = "\(enemyMP) / 35"
        
        updateUI()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
         playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
         playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
         playerTPLable.text = "\(player.currentTP) / \(player.maxTP)"
         
         enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
         enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
     }
     
     func judgeBattle() {
         if player.currentHP <= 0{
             finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
         }else if enemy.currentHP <= 0{
             finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
         }
     }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @objc func updateGame() {
        player.currentMP += 1
        if player.currentMP >= 20 {
            isPlayerAttackAvailable = true
            player.currentMP = 20
        }else {
            isPlayerAttackAvailable = false
        }
        
        enemy.currentMP += 1
        if enemy.currentMP >= 35 {
            enemyAttack()
            enemy.currentMP = 0
        }
        
//        playerMPLabel.text = "\(playerMP) / 20"
//        enemyMPLabel.text = "\(enemyMP) / 35"
        updateUI()
    }
    
    func enemyAttack() {
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= 20
        
//        playerHPLabel.text = "\(playerHP) / 100"
        
        updateUI()
        
 //       if playerHP <= 0{
 //           finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
 //       }
        judgeBattle()
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        } else {
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北..."
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func attackAction() {
        if isPlayerAttackAvailable{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemy.currentHP -= player.attackPoint
            
            player.currentTP += 10
            if player.currentTP >= player.maxTP {
                player.currentTP = player.maxTP
            }
            
            player.currentMP = 0
            
//            enemyHPLabel.text = "\(enemyHP) / 200"
//            playerMPLabel.text = "\(playerMP) / 20"
            
            updateUI()
            
 //           if enemyHP <= 0 {
 //               finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
//            }
            judgeBattle()
        }
    }
    
    @IBAction func tameruAction() {
        if isPlayerAttackAvailable{
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
        }
    }
    
    @IBAction func fireAction() {
        if isPlayerAttackAvailable && player.currentTP >= 40{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
            }
            player.currentMP = 0
            judgeBattle()
        }
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
