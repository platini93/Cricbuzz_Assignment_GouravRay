import Foundation

class MoviesData {
    var movies:[Movie] = []
}

class Movie {
    var title:String = ""
    var year:String = ""
    var rated:String = ""
    var released:String = ""
    var runtime:String = ""
    var genre:String = ""
    var director:String = ""
    var writer:String = ""
    var actors:String = ""
    var plot:String = ""
    var language:String = ""
    var country:String = ""
    var awards:String = ""
    var poster:String = ""
    var ratings:[Rating] = []
    var metascore:String = ""
    var imdbRating:String = ""
    var imdbVotes:String = ""
    var imdbID:String = ""
    var type:String = ""
    var dvd:String = ""
    var boxOffice:String = ""
    var production:String = ""
    var website:String = ""
    var response:String = ""
}

class Rating {
    var source:String = ""
    var value:String = ""
}



class MoviesModel {
    
    func fetchMoviesData(completion: @escaping (_ allData:MoviesData?, _ error:Error?) -> Void) {
        
        let movieData:MoviesData = MoviesData()
        
        do {
           if let bundlePath = Bundle.main.path(forResource: "movies", ofType: "json"),
           let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
              if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [[String: Any]] {
                  
                  for movie in json {
                      let type = movie["Type"] as? String ?? ""
                      if type != "movie" {
                          continue
                      }
                      
                      let title = movie["Title"] as? String ?? ""
                      let year = movie["Year"] as? String ?? ""
                      let rated = movie["Rated"] as? String ?? ""
                      let released = movie["Released"] as? String ?? ""
                      let runtime = movie["Runtime"] as? String ?? ""
                      let genre = movie["Genre"] as? String ?? ""
                      let director = movie["Director"] as? String ?? ""
                      let writer = movie["Writer"] as? String ?? ""
                      let actors = movie["Actors"] as? String ?? ""
                      let plot = movie["Plot"] as? String ?? ""
                      let language = movie["Language"] as? String ?? ""
                      let country = movie["Country"] as? String ?? ""
                      let awards = movie["Awards"] as? String ?? ""
                      let poster = movie["Poster"] as? String ?? ""
                      var ratings:[Rating] = []
                      let metascore = movie["Metascore"] as? String ?? ""
                      let imdbRating = movie["imdbRating"] as? String ?? ""
                      let imdbVotes = movie["imdbVotes"] as? String ?? ""
                      let imdbID = movie["imdbID"] as? String ?? ""
                      let dvd = movie["DVD"] as? String ?? ""
                      let boxOffice = movie["BoxOffice"] as? String ?? ""
                      let production = movie["Production"] as? String ?? ""
                      let website = movie["Website"] as? String ?? ""
                      let response = movie["Response"] as? String ?? ""
                      
                      for rat in movie["Ratings"] as? [[String:Any]] ?? [] {
                          var rating:Rating = Rating()
                          rating.source = rat["Source"] as? String ?? ""
                          rating.value = rat["Value"] as? String ?? ""
                          ratings.append(rating)
                      }
                      
                      var movie = Movie()
                      movie.title = title
                      movie.year = year
                      movie.rated = rated
                      movie.released = released
                      movie.runtime = runtime
                      movie.genre = genre
                      movie.director = director
                      movie.writer = writer
                      movie.actors = actors
                      movie.plot = plot
                      movie.language = language
                      movie.country = country
                      movie.awards = awards
                      movie.poster = poster
                      movie.ratings = ratings
                      movie.metascore = metascore
                      movie.imdbRating = imdbRating
                      movie.imdbVotes = imdbVotes
                      movie.imdbID = imdbID
                      movie.type = type
                      movie.dvd = dvd
                      movie.boxOffice = boxOffice
                      movie.production = production
                      movie.website = website
                      movie.response = response
                      
                      movieData.movies.append(movie)
                  }
                  
              } else {
                 print("error serializing json!")
              }
           }
          completion(movieData,nil)
           
        } catch {
           print(error)
           completion(nil, error)
        }
    }
}
