//
//  ViewController.swift
//  project5
//
//  Created by Tamim Khan on 8/2/23.
//

import UIKit

class ViewController: UITableViewController {
    var allWord = [String]()
    var useWord = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAns))
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "NEW GAME", style: .plain, target: self, action: #selector(startGame))
        
        
        
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsUrl){
                allWord = startWords.components(separatedBy: "\n")
            }
        }
        if allWord.isEmpty{
            allWord = ["silkworm"]
        }
        startGame()
    }
  @objc func startGame(){
        title = allWord.randomElement()
        useWord.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useWord.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath)
        cell.textLabel?.text = useWord[indexPath.row]
        return cell
        
    }
    @objc func promptForAns(){
        let ac = UIAlertController(title: "ENTER ANS", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        
        let submitAction = UIAlertAction(title: "submit", style: .default){
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answare: String){
        let lowerAns = answare.lowercased()
        
        let errorTitle: String
        let errorMassage: String
        
        
        if isPossible(word: lowerAns){
            if isOriginal(word: lowerAns){
                if isReal(word: lowerAns){
                    useWord.insert(lowerAns, at: 0)
                    
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                    
                }else{
                    errorTitle = "Oops!"
                    errorMassage = "you can't use this word or word should be more then 3 letters"
                }
            }else{
                errorTitle = "Oops!"
                errorMassage = "you can't repeat same word"
            }
        }else{
            errorTitle = "Oops!"
            errorMassage = "this is not a word"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMassage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool{
        guard word != title  else {return false}
        return !useWord.contains(word)
        
    }
    func isReal(word: String) -> Bool {
        guard word.count > 3 else {return false}
        
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange.location == NSNotFound
            
        }
    
    
    
}
