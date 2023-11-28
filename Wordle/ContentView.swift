//
//  ContentView.swift
//  Wordle
//
//  Created by Azoz Salah on 28/11/2023.
//

import UIKit

class ContentView: UIView {

    var currentWordLabels = [UILabel]()
    var currentWordView: UIView!
    var letterButtons = [UIButton]()
    var scoreLabels = [UILabel]()
    var scoreView: UIView!
    var buttonsView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        createSubViews()
    }
    
    func createSubViews() {
        backgroundColor = UIColor.secondarySystemBackground
        
        scoreView = UIView()
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scoreView)
        
        scoreView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scoreView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        scoreView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        scoreView.widthAnchor.constraint(equalToConstant: 210).isActive = true
        
        
        currentWordView = UIView()
        currentWordView.translatesAutoresizingMaskIntoConstraints = false
        currentWordView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        addSubview(currentWordView)
        
        currentWordView.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 100).isActive = true
        currentWordView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        currentWordView.widthAnchor.constraint(equalToConstant: 225).isActive = true
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsView)
        
        
        buttonsView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        buttonsView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        buttonsView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonsView.topAnchor.constraint(equalTo: currentWordView.bottomAnchor, constant: 100).isActive = true
        buttonsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        
        
        createScoreLabel()
        
        createLetterButtons()
    }
    
    func createScoreLabel() {
        let scoreWidth = 30
        let scoreHeight = 50
        
        for column in 0..<7 {
            let scoreLabel = UILabel()
            scoreLabel.font = UIFont.systemFont(ofSize: 20)
            scoreLabel.text = "❤️"
            
            let frame = CGRect(x: column * scoreWidth, y: 0, width: scoreWidth - 3, height: scoreHeight)
            scoreLabel.frame = frame
            
            scoreView.addSubview(scoreLabel)
            scoreLabels.append(scoreLabel)
        }
    }
    
    func createLetterButtons() {
        let height = 75
        let width = 57
        
        for row in 0..<4 {
            for column in 0..<7 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("Z", for: .normal)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                let frame = CGRect(x: (column * width), y: (row * height), width: width - 3, height: height - 3)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        letterButtons[21].removeFromSuperview()
        letterButtons[27].removeFromSuperview()
        letterButtons.remove(at: 21)
    }

}
