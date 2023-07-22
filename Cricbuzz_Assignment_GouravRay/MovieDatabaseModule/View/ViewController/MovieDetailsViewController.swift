//
//  MovieDetailsViewController.swift
//  Cricbuzz_Assignment_GouravRay
//
//  Created by Gourav Ray on 22/07/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movie:Movie = Movie()
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var castAndCrewLbl: UILabel!
    @IBOutlet weak var ratingsDropdown: DropDown!
    
    @IBOutlet weak var ratingValueOuterView: UIView!
    @IBOutlet weak var ratingValueView: UIView!
    @IBOutlet weak var ratingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingValueLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movie Details"
        plotTextView.flashScrollIndicators()
        posterImage.sd_setImage(with: URL(string: movie.poster), placeholderImage: UIImage(named: "placeholder"))
        titleLbl.text = movie.title
        releaseDateLbl.text = "Released: \(movie.released)"
        genreLbl.text = "Genre: \(movie.genre)"
        plotTextView.text = "Plot: \(movie.plot)"
        
        if UIScreen.main.bounds.size.height <= 667.0 {
            castAndCrewLbl.text = "Cast: \(movie.actors) \nDirectors: \(movie.director) \nWriters: \(movie.writer)"
        } else {
            castAndCrewLbl.text = "Cast: \(movie.actors) \n\nDirectors: \(movie.director) \n\nWriters: \(movie.writer)"
        }
        
        var optionArray:[String] = []
        var ratingValues:[String] = []
        
        for rating in movie.ratings {
            optionArray.append(rating.source)
            ratingValues.append(rating.value)
        }
        
        ratingsDropdown.optionArray = optionArray
        ratingsDropdown.isSearchEnable = false
        ratingsDropdown.checkMarkEnabled = false
        ratingsDropdown.selectedRowColor = UIColor.gray
        ratingsDropdown.arrowColor = .black
        ratingsDropdown.arrowSize = 15
        
        ratingsDropdown.text = "Select Source"
        ratingValueLbl.text = ""
        ratingWidthConstraint.constant = 0.0
        
        ratingsDropdown.didSelect{(selectedText , index ,id) in
            self.ratingsDropdown.text = "\(selectedText)"
            
            let width = self.ratingValueOuterView.frame.size.width
            let rawValue = ratingValues[index]
            
            if selectedText == "Internet Movie Database" {

                let value = Double(rawValue.components(separatedBy: "/")[0])
                let displayValue = (value ?? 0)/10.0 * Double(width)
                self.ratingWidthConstraint.constant = CGFloat(displayValue)
                self.ratingValueLbl.text = rawValue
                
            } else if selectedText == "Rotten Tomatoes" {
                
                let value = Double(rawValue.components(separatedBy: "%")[0])
                let displayValue = (value ?? 0)/100.0 * Double(width)
                self.ratingWidthConstraint.constant = CGFloat(displayValue)
                self.ratingValueLbl.text = rawValue
        
            } else if selectedText == "Metacritic" {
                
                let value = Double(rawValue.components(separatedBy: "/")[0])
                let displayValue = (value ?? 0)/100.0 * Double(width)
                self.ratingWidthConstraint.constant = CGFloat(displayValue)
                self.ratingValueLbl.text = rawValue
                
            }
        }
        
        ratingValueOuterView.layer.cornerRadius = ratingValueOuterView.frame.size.height/2
        ratingValueOuterView.clipsToBounds = true
        
    }
    
}
