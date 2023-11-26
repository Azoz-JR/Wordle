//
//  ViewController.swift
//  Wordle
//
//  Created by Azoz Salah on 26/11/2023.
//

import UIKit

class ViewController: UIViewController {

    var currentWordLabels = [UILabel]()
    var currentWordView: UIView!
    var currentWord = [Character]()
    var letterButtons = [UIButton]()
    let letters: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var words = [String]()
    var currentSolution = ""
    var usedButtons = [UIButton]()
    var scoreLabels = [UILabel]()
    var lives = 7
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground

        let scoreView = UIView()
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreView)
                
        currentWordView = UIView()
        currentWordView.translatesAutoresizingMaskIntoConstraints = false
        currentWordView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(currentWordView)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scoreView.heightAnchor.constraint(equalToConstant: 50),
            scoreView.widthAnchor.constraint(equalToConstant: 210),
            
            currentWordView.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 100),
            currentWordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentWordView.widthAnchor.constraint(equalToConstant: 225),
            

            buttonsView.widthAnchor.constraint(equalToConstant: 400),
            buttonsView.heightAnchor.constraint(equalToConstant: 300),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentWordView.bottomAnchor, constant: 100),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            
        ])
        
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
        
        let height = 75
        let width = 57
        
        for row in 0..<4 {
            for column in 0..<7 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("Z", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WORDLE"
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restart", style: .plain, target: self, action: #selector(playAgain))
        
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
                self?.letterButtons[i].setTitle(String((self?.letters[i])!), for: .normal)
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
            
            currentWordView.addSubview(letterLabel)
            currentWordLabels.append(letterLabel)
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
                        self.currentWordLabels[index].text = String(letter)
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
        scoreLabels[lives].isHidden = true
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
        
        currentWordLabels.forEach { $0.text = "" }
        
        lives = 7
        
        for i in scoreLabels {
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

