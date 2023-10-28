//
//  Movie.swift
//  ios101-lab6-flix
//

import Foundation

struct MovieFeed: Decodable {
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let title: String
    let overview: String
    let posterPath: String? // Path used to create a URL to fetch the poster image

    // MARK: Additional properties for detail view
    let backdropPath: String? // Path used to create a URL to fetch the backdrop image
    let voteAverage: Double?
    let releaseDate: Date?

    // MARK: ID property to use when saving movie
    let id: Int

    // MARK: Custom coding keys
    // Allows us to map the property keys returned from the API that use underscores (i.e. `poster_path`)
    // to a more "swifty" lowerCamelCase naming (i.e. `posterPath` and `backdropPath`)
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case id
    }
    
}

extension Movie{
    static var favoritesKey: String {
        return "Favorites"
    }
    
    static func save(_ movies: [Movie], forKey key: String) {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        let encodedData = try! JSONEncoder().encode(movies)
        // 3.
        defaults.set(encodedData, forKey: key)
    }
    
    static func getMovies(forKey key: String) -> [Movie] {
        // 1.
        let defaults = UserDefaults.standard
        // 2.
        if let data = defaults.data(forKey: key) {
            // 3.
            let decodedMovies = try! JSONDecoder().decode([Movie].self, from: data)
            // 4.
            return decodedMovies
        } else {
            // 5.
            return []
        }
    }
    
    func addToFavorites() {
        // 1.
        var favoriteMovies = Movie.getMovies(forKey: Movie.favoritesKey)
        // 2.
        favoriteMovies.append(self)
        // 3.
        Movie.save(favoriteMovies, forKey: Movie.favoritesKey)
    }

    func removeFromFavorites() {
        // 1.
        var favoriteMovies = Movie.getMovies(forKey: Movie.favoritesKey)
        // 2.
        favoriteMovies.removeAll { movie in
            // 3.
            return self == movie
        }
        // 4.
        Movie.save(favoriteMovies, forKey: Movie.favoritesKey)
    }
}




