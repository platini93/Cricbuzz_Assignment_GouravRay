//
//  MoviesSearchViewController.swift
//  Cricbuzz_Assignment_GouravRay
//
//  Created by Gourav Ray on 21/07/23.
//

import UIKit
import SDWebImage

class MoviesSearchViewController: UIViewController, MoviesViewProtocol {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesTableView: UITableView!
    
    private var moviesViewModel:MoviesViewModel?
    private var sections = [Section]()
    private var searching = false
    private var searchedMovies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movie Database"
        searchBar.delegate = self
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.register(UINib(nibName: "SectionHeaderTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeaderTableCell")
        moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
                
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {

             clearButton.addTarget(self, action: #selector(self.clearSearch), for: .touchUpInside)
        }
        
        moviesViewModel = MoviesViewModel(view: self)
        moviesViewModel?.bindMoviesViewModelToController = {
            self.updateUI()
        }
        moviesViewModel?.getMoviesData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func clearSearch() {
        searching = false
        searchBar.text = ""
        moviesTableView.reloadData()
        view.endEditing(true)
    }
    
    func updateUI() {
        sections = moviesViewModel?.sections ?? []
        moviesTableView.reloadData()
    }
    
    //MARK: MoviesViewProtocol methods
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MoviesSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if searching {
            return 1
        }
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedMovies.count
        }
        
        let section = sections[section]
        
        if section.isOpened {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        if searching {
            let data = searchedMovies[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
            cell.thumbnail.sd_setImage(with: URL(string: data.poster), placeholderImage: UIImage(named: "placeholder"))
            cell.titleLbl.text = data.title
            cell.yearLbl.text = "Year: \(data.year)"
            cell.languageLbl.text = "Language: \(data.language)"
            return cell
        }
        
        if indexPath.section == 4 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableCell", for: indexPath) as! SectionHeaderTableCell
                cell.titleLabel.text = sections[indexPath.section].title
                cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
                cell.arrowImage.isHidden = false
                if sections[indexPath.section].isOpened {
                    cell.arrowImage.image = UIImage(named: "downArrow")
                } else {
                    cell.arrowImage.image = UIImage(named: "rightArrow")
                }
                return cell
            }
            
            let data = (sections[indexPath.section].options[indexPath.row - 1] as! Movie)
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
            cell.thumbnail.sd_setImage(with: URL(string: data.poster), placeholderImage: UIImage(named: "placeholder"))
            cell.titleLbl.text = data.title
            cell.yearLbl.text = "Year: \(data.year)"
            cell.languageLbl.text = "Language: \(data.language)"
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderTableCell", for: indexPath) as! SectionHeaderTableCell
            
            if indexPath.row == 0 {
                cell.titleLabel.text = sections[indexPath.section].title
                cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
                if sections[indexPath.section].isOpened {
                    cell.arrowImage.image = UIImage(named: "downArrow")
                } else {
                    cell.arrowImage.image = UIImage(named: "rightArrow")
                }
                cell.arrowImage.isHidden = false
            } else {
                cell.arrowImage.isHidden = true
                if indexPath.section == 0 {
                    cell.titleLabel.text = "\(sections[indexPath.section].options[indexPath.row - 1])"
                } else {
                    cell.titleLabel.text = (sections[indexPath.section].options[indexPath.row - 1]) as? String
                }
                cell.titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if searching {
            return 100.0
        }
        
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                return 60.0
            } else {
                return 100.0
            }
        } else {
            if indexPath.row == 0 {
                return 60.0
            } else {
                return 40.0
            }
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.flashScrollIndicators()
        
        if searching {
            // navigate to movie detail screen here
            let data = searchedMovies[indexPath.row]
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            vc.movie = data
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if indexPath.section == 4 {
            if indexPath.row == 0 {
                sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
                tableView.reloadSections([indexPath.section], with: .fade)
            } else {
                // navigate to movie detail screen here
                let data = (sections[indexPath.section].options[indexPath.row - 1] as! Movie)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                vc.movie = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if indexPath.row == 0 {
                sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
                tableView.reloadSections([indexPath.section], with: .fade)
            } else {
                // navigate to movie list screen here
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilteredMoviesListViewController") as! FilteredMoviesListViewController
                if indexPath.section == 0 {
                    vc.searchTerm = "\(sections[indexPath.section].options[indexPath.row - 1])"
                } else {
                    vc.searchTerm = (sections[indexPath.section].options[indexPath.row - 1]) as? String ?? ""
                }
                vc.movies = moviesViewModel?.movieData.movies ?? []
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}

extension MoviesSearchViewController:UISearchBarDelegate, UITextFieldDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searching = false
            for section in sections {
                section.isOpened = false
            }
            moviesTableView.reloadData()
            return
        }
        
        let movies = moviesViewModel?.movieData.movies
        searchedMovies = movies?.filter { $0.title.lowercased().contains(searchText.lowercased()) || $0.genre.lowercased().contains(searchText.lowercased()) || $0.actors.lowercased().contains(searchText.lowercased()) || $0.director.lowercased().contains(searchText.lowercased()) } ?? []
        searching = true
        moviesTableView.reloadData()
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.searchTextField.text == "" {
            searching = false
            searchBar.text = ""
            moviesTableView.reloadData()
            view.endEditing(true)
        }
        searchBar.resignFirstResponder()
    }
}
