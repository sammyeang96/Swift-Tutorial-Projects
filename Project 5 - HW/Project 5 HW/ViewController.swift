//
//  ViewController.swift
//  Project 5 HW
//
//  Created by Sammy Eang on 1/26/18.
//  Copyright © 2018 Sammy Eang. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(startGame))
        
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            loadDefaultWords()
        }
        if allWords == [""] {
            loadDefaultWords()
        }
        
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        startGame()
        
    }

    @objc func startGame() {
        title = allWords[0]
        usedWords.removeAll(keepingCapacity: true)
        allWords.remove(at: 0)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Probably gonna need to know for senior project
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        
        /*let errorTitle: String
        let errorMessage: String*/
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    showErrorMessage(error: 1)
                    /*errorTitle = "Word not recognised"
                    errorMessage = "(Brooklyn Accent) You didn't put nothin' in! It's eitha blank, too short, or not a real worrrrrrrd! FUGGEDABOUTIT!!!!!!!"*/
                }
            } else {
                showErrorMessage(error: 2)
                /*errorTitle = "Word used already"
                errorMessage = "Be more original!"*/
            }
        } else {
            showErrorMessage(error: 3)
            /*errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'!"*/
        }
        
        /*let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)*/
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()
        
        for letter in word {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        //return !usedWords.contains(word)
        if usedWords.contains(word) {
            return false
        } else if word == title{
            return false
        } else {
        return true
        }
    }
    
    func isReal(word: String) -> Bool {
        
        if word.count < 4 {
            return false
        } else if word == "" {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(error: Int) {
        
        let errorTitle: String
        let errorMessage: String
        
        switch error {
        case 1:
            errorTitle = "Word not recognised"
            errorMessage = "(Brooklyn Accent) You didn't put nothin' in! It's eitha blank, too short, or not a real worrrrrrrd! FUGGEDABOUTIT!!!!!!!"
        case 2:
            errorTitle = "Word used already (maybe in the title ya goofball)"
            errorMessage = "Be more original!"
        case 3:
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
        default:
            errorTitle = "Boiiiii, I gotsa message for yas"
            errorMessage = "Ya done goofed ya fuckin retard"
        }
    
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func loadDefaultWords() {
        allWords = ["PopeyesChicken","Chicken","Popeyes"]
    }

}

