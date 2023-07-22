//
//  MovieDetailsViewController.swift
//  Cricbuzz_Assignment_GouravRay
//
//  Created by Gourav Ray on 22/07/23.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movie:Movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Details"
        
        print("Movie : \(movie.title)")
    }
    
}
