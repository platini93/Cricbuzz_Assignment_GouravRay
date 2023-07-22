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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Details"
        plotTextView.flashScrollIndicators()
        posterImage.sd_setImage(with: URL(string: movie.poster), placeholderImage: UIImage(named: "placeholder"))
        titleLbl.text = movie.title
        releaseDateLbl.text = "Released: \(movie.released)"
        genreLbl.text = "Genre: \(movie.genre)"
        plotTextView.text = "Plot: \(movie.plot)"
        castAndCrewLbl.text = "Cast: \(movie.actors) \n\nDirectors: \(movie.director) \n\nWriters: \(movie.writer)"
    }
    
}
