
import Foundation

protocol MoviesViewProtocol : AnyObject {
    func showAlert(message:String)
}

class MoviesViewModel {
        
    private var movieModel:MoviesModel = MoviesModel()
    
    var movieData:MoviesData = MoviesData() {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    
    var bindMoviesViewModelToController:(() -> ()) = {}
    
    private weak var view: MoviesViewProtocol?
    
    init(view: MoviesViewProtocol) {
        self.view = view
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
