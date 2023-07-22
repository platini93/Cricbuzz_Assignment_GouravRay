//
//  FilteredMoviesListViewController.swift
//  Cricbuzz_Assignment_GouravRay
//
//  Created by Gourav Ray on 22/07/23.
//

import UIKit

class FilteredMoviesListViewController: UIViewController {

    var movies:[Movie] = []
    private var filteredMovies:[Movie] = []
    var searchTerm:String = ""
    
    @IBOutlet weak var movieTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Searched Movies"
        movieTable.delegate = self
        movieTable.dataSource = self
        movieTable.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        filteredMovies = movies.filter { $0.year.contains(searchTerm) || $0.actors.contains(searchTerm) || $0.director.contains(searchTerm) || $0.genre.contains(searchTerm)}
        
        for movie in filteredMovies {
            print(movie.title)
        }
        
        movieTable.reloadData()
    }

}

extension FilteredMoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let data = filteredMovies[indexPath.row]
        
        cell.thumbnail.sd_setImage(with: URL(string: data.poster), placeholderImage: UIImage(named: "placeholder"))
        cell.titleLbl.text = data.title
        cell.languageLbl.text = "Languages: \(data.language)"
        cell.yearLbl.text = "Year: \(data.year)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = filteredMovies[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.movie = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
