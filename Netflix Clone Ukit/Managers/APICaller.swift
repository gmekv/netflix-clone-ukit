import Foundation


struct Constants {
    static let API_KEY = "f61129f19caf13455abeb5b2e752b991"
    static let baseURL = "https://api.themoviedb.org/3"
}

enum APIError: Error {
    case noDataAvailable
    case decodingError
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/trending/all/day?api_key=\(Constants.API_KEY)"
        fetchData(from: urlString, completion: completion)
    }

    func fetchData(from urlString: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.failedToGetData))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }

            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }

        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let urlString = "\(Constants.baseURL)/trending/all/day?api_key=\(Constants.API_KEY)&query=\(query)"
        fetchData(from: urlString, completion: completion)
    }

    func getTrendingTVs(completion: @escaping (Result<[Title], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/trending/tv/day?api_key=\(Constants.API_KEY)"
        fetchData(from: urlString, completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/upcoming?api_key=\(Constants.API_KEY)"
        fetchData(from: urlString, completion: completion)
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        fetchData(from: urlString, completion: completion)
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        fetchData(from: urlString, completion: completion)
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        fetchData(from: urlString, completion: completion)
    }
}
