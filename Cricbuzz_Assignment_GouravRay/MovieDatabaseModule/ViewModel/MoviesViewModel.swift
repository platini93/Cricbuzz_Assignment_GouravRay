
import Foundation

protocol MoviesViewProtocol : AnyObject {
    func showAlert(message:String)
}

class Section {
    let title:String
    let options:[Any]
    var isOpened:Bool = false
    
    init(title: String, options: [Any], isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}


class MoviesViewModel {
        
    private var movieModel:MoviesModel = MoviesModel()
    
    var sections = [Section]()
    private var sectionNames:[String] = []
    private var sectionItems:[Any] = []
    
    var movieData:MoviesData = MoviesData() {
        didSet {
            self.prepareDataForView()
        }
    }
    
    var bindMoviesViewModelToController:(() -> ()) = {}
    
    private weak var view: MoviesViewProtocol?
    
    init(view: MoviesViewProtocol) {
        self.view = view
    }
    
    func prepareDataForView() {
        sectionNames = ["Year", "Genre", "Directors", "Actors", "All Movies"]
        
        let movies = movieData.movies
        
        var yearArray:[Int] = []
        movies.forEach { i in
            let year = Int(i.year) ?? 0
            if !yearArray.contains(year) {
                yearArray.append(year)
            }
        }
        yearArray.sort()
        
        var genreArray:[String] = []
        movies.forEach { i in
            let genreList = i.genre.components(separatedBy: ",")
            genreList.forEach { g in
                let genre = g.trimmingCharacters(in: .whitespaces)
                if !genreArray.contains(genre) {
                    genreArray.append(genre)
                }
            }
        }
        
        var directorArray:[String] = []
        movies.forEach { i in
            let dirList = i.director.components(separatedBy: ",")
            dirList.forEach { d in
                let dir = d.trimmingCharacters(in: .whitespaces)
                if !directorArray.contains(dir) && dir != "N/A" {
                    directorArray.append(dir)
                }
            }
        }
        
        var actorsArray:[String] = []
        movies.forEach { i in
            let actList = i.actors.components(separatedBy: ",")
            actList.forEach { a in
                let actor = a.trimmingCharacters(in: .whitespaces)
                if !actorsArray.contains(actor) && actor != "N/A" {
                    actorsArray.append(actor)
                }
            }
        }
        
        sectionItems = [yearArray, genreArray, directorArray, actorsArray, movies as Any]
        
        sectionNames.indices.forEach { i in
            sections.append(Section(title: sectionNames[i], options: sectionItems[i] as! [Any]))
        }
        
        self.bindMoviesViewModelToController()
    }
    
    
    func getMoviesData() {
        movieModel.fetchMoviesData(completion: {[weak self] movieData, error in
            if error != nil {
                self?.view?.showAlert(message: "Error fetching data!")
            } else if movieData != nil {
                self?.movieData = movieData ?? MoviesData()
            }
        })
    }
    
}
