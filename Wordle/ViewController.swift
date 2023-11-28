//
//  ViewController.swift
//  Wordle
//
//  Created by Azoz Salah on 26/11/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var contentView = ContentView()
    
    var currentWord = [Character]()
    let letters: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var words = [String]()
    var currentSolution = ""
    var usedButtons = [UIButton]()
    var lives = 7
    
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WORDLE"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(playAgain))
        
        contentView.letterButtons.forEach { $0.addTarget(self, action: #selector(letterTapped), for: .touchUpInside) }
        
        settingUp()
                
    }
    
    func settingUp() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
                if let contents = try? String(contentsOf: url) {
                    self?.words = contents.components(separatedBy: "\n").filter { $0.count == 5 }
                    self?.words.shuffle()
                    self?.currentSolution = (self?.words.randomElement()?.uppercased())!
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            for i in 0..<(self?.letters.count)! {
                self?.contentView.letterButtons[i].setTitle(String((self?.letters[i])!), for: .normal)
            }
            
            guard let count = self?.currentSolution.count, count != 0 else { return }
            
            self?.currentWord = Array(repeating: Character("?"), count: count)
            
            self?.settingCurrentWordView()
        }
    }
    
    func settingCurrentWordView() {
        let size = 45
        for index in 0..<5 {
            let letterLabel = UILabel()
            letterLabel.text = ""
            letterLabel.font = .systemFont(ofSize: 36)
            letterLabel.textAlignment = .center
            letterLabel.layer.borderWidth = 1
            letterLabel.layer.borderColor = UIColor.lightGray.cgColor
            
            let frame = CGRect(x: (index * size), y: 0, width: size - 3, height: size - 3)
            letterLabel.frame = frame
            
            contentView.currentWordView.addSubview(letterLabel)
            contentView.currentWordLabels.append(letterLabel)
        }
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        usedButtons.append(sender)
        
        guard let buttonTitle = sender.titleLabel?.text  else { return }
        
        
        if currentSolution.contains(buttonTitle) {
            for (index, letter) in currentSolution.enumerated() {
                if letter == Character(buttonTitle) {
                    currentWord[index] = letter
                    UIView.animate(withDuration: 0.25) {
                        self.contentView.currentWordLabels[index].alpha = 0
                        //self.contentView.currentWordLabels[index].text = String(letter)
                    } completion: { _ in
                        self.contentView.currentWordLabels[index].text = String(letter)
                        self.contentView.currentWordLabels[index].alpha = 1
                    }
                }
            }
            
            if String(currentWord) == currentSolution {
                levelUp()
            }
            
        } else {
            wrongAnswer()
        }
        sender.isHidden = true
    }
    
    func wrongAnswer() {
        lives -= 1
        contentView.scoreLabels[lives].isHidden = true
        if lives != 0 {
            let ac = UIAlertController(title: "Wrong letter", message: "Remaining tries: \(lives)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }else {
            let ac = UIAlertController(title: "You lost", message: "The word was: \(currentSolution)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: playAgain))
            present(ac, animated: true)
        }
    }
    
    @objc func playAgain(_ action: UIAlertAction) {
        currentSolution = words.randomElement()?.uppercased() ?? ""
                
        currentWord = Array(repeating: Character("?"), count: 5)
        
        contentView.currentWordLabels.forEach { $0.text = "" }
        
        lives = 7
        
        for i in contentView.scoreLabels {
            i.isHidden = false
        }
        for i in usedButtons {
            i.isHidden = false
        }
    }
    
    func levelUp() {
        let ac = UIAlertController(title: "You won!", message: "Let's go to the next level!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: playAgain))
        present(ac, animated: true)
    }


}
