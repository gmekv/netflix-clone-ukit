import Foundation


struct Constants {
    static let API_KEY = "f61129f19caf13455abeb5b2e752b991"
    static let baseURL = "https://api.themoviedb.org/3"
    static let YoutubeAPI_Key = "AIzaSyCt15LlBVKbbfmuhriW6G1lnDv--kwrFbA"
    static let YoutubeBaseURL = "https://www.googleapis.com/youtube/v3"
}

enum APIError: Error {
    case noDataAvailable
    case decodingError
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()

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
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/trending/all/day?api_key=\(Constants.API_KEY)"
        fetchData(from: urlString, completion: completion)
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = "\(Constants.baseURL)/search/movie?api_key=\(Constants.API_KEY)&query=\(query)"
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
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        print("[YouTube] raw query:", query)

        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("[YouTube] query encoding failed")
            return
        }

        print("[YouTube] encoded query:", query)

        let urlString = "\(Constants.YoutubeBaseURL)/search?part=snippet&q=\(query)&key=\(Constants.YoutubeAPI_Key)&type=video&videoEmbeddable=true&maxResults=5"
        print("[YouTube] request URL:", urlString)

        guard let url = URL(string: urlString) else {
            print("[YouTube] invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                print("[YouTube] request error:", error.localizedDescription)
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("[YouTube] status code:", httpResponse.statusCode)
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
            }

            guard let data = data else {
                print("[YouTube] no data")
                return
            }

            if let rawResponse = String(data: data, encoding: .utf8) {
                print("[YouTube] raw response preview:", rawResponse.prefix(500))
            }

            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                print("[YouTube] decoded items count:", results.items.count)
                guard let firstVideo = results.items.first(where: { $0.id.videoId != nil }) else {
                    print("[YouTube] no video items found after filtering")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                completion(.success(firstVideo))
            } catch {
                print("[YouTube] decode error:", error)
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }    
    }
