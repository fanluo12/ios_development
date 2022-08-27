//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let tweetCount = 100
    
    let sentimentClassifier = SentimentClassifier()
    
    
    let swifter = Swifter(consumerKey: "pwnkZYGNnNXXBMGNTdMR72eff", consumerSecret: "SyHvIvRXHnaQlae1N1ptJZZ4ouQ2VFq5nO8BhWUu9iobL4DFh9")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
        
    }
    
    func fetchTweets() {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { (results, metadata) in
                var tweets = [SentimentClassifierInput]()
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = SentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                self.makePrediction(with: tweets)
            } failure: { (error) in
                print("There was an error with the Twitter API request, \(error)")
            }
        }
    }
    
    func makePrediction(with tweets: [SentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            for pred in predictions {
                let sentiment = pred.label
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            updateUI(with: sentimentScore)
        } catch {
            print("There was an error with making a prediction, \(error)")
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😆"
            self.backgroundView.backgroundColor = #colorLiteral(red: 0.4632546862, green: 1, blue: 0.1701869755, alpha: 1)
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😃"
            self.backgroundView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
            self.backgroundView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
            self.backgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😟"
            self.backgroundView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
            self.backgroundView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        } else {
            self.sentimentLabel.text = "🤮"
            self.backgroundView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        }
    }
    
}

