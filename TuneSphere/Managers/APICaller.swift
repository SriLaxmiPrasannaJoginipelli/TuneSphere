//
//  APICaller.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//

import Foundation

final class APICaller{
    
    static public let shared = APICaller()
    
    private init(){
        
    }
    
    struct Constants{
        static let baseAPIUrl = "https://api.spotify.com/v1"
    }
    enum APIError:Error{
        case failedToGetData
    }
    public func getCurrentUserProfile(completion: @escaping(Result<UserProfile,Error>)->Void){
        createRequest(with: URL(string: Constants.baseAPIUrl + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    
                    completion(.success(result))
                    print("result:\(result)")
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    enum httpMethod : String{
        case GET
        case POST
        
    }
    
    private func createRequest(with url:URL?,type:httpMethod,completion:@escaping(URLRequest)->Void) {
        AuthManager.shared.validToken { token in
            guard let apiUrl = url else{
                return
            }
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
            
        }
        
        
    }
    
    public func getNewReleases(completion:@escaping((Result<NewReleasesResponse,Error>))->Void){
        
        createRequest(with: URL(string: Constants.baseAPIUrl + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    //print("result is:\(result)")
                    completion(.success(result))
                }
                catch{
                    print("error:\(error)")
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
        
    }
    
    public func getAlbumTracks(albumID: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIUrl + "/albums/\(albumID)/tracks"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    //JSONDecoder().decode(AlbumTracksResponse.self, from: data)
                   // completion(.success(result.items))
                    
                    print("getAlbumTracks : \(result)")
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //Mark:-featured-playlists deprecated
    
    //    public func getFeaturedPlayList(completion:@escaping((Result<String,Error>))->Void){
    //        createRequest(with: URL(string: Constants.baseAPIUrl + "/browse/featured-playlists?limit=2"), type: .GET) { request in
    //            let task = URLSession.shared.dataTask(with: request) { data, _, error in
    //                guard let data = data, error == nil else{
    //                    completion(.failure(APIError.failedToGetData))
    //                    return
    //                }
    //                do{
    //
    //                    //completion(
    //                }catch{
    //                    completion(.failure(error))
    //                }
    //            }
    //            task.resume()
    //        }
    //    }
    //Mark:-featured-Genre Recommendations deprecated
    
    //    public func getGenreRecommendations(completion:@escaping((Result<String,Error>))->Void){
    //
    //        createRequest(with: URL(string: Constants.baseAPIUrl + "/recommendations/available-genre-seeds"), type: .GET) { request in
    //            let task = URLSession.shared.dataTask(with: request) { data, _, error in
    //                guard let data = data, error == nil else{
    //                    completion(.failure(APIError.failedToGetData))
    //                    return
    //                }
    //
    //                do{
    //                    let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    //                    //JSONDecoder().decode(NewReleasesResponse.self, from: data)
    //                    print("result is:\(result)")
    //                    //completion(.success(result))
    //                }
    //                catch{
    //                    print("error:\(error)")
    //                    completion(.failure(error))
    //                }
    //
    //            }
    //            task.resume()
    //        }
    //
    //    }
    
    
    public func getBrowseCategories(completion:@escaping(Result<SpotifyCategoriesResponse,Error>)->Void){
        
        createRequest(with: URL(string: Constants.baseAPIUrl + "/browse/categories"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(SpotifyCategoriesResponse.self, from: data)
                    //print("browse catrgories result is:\(result)")
                    completion(.success(result))
                }
                catch{
                    print("error:\(error)")
                    completion(.failure(error))
                }
                
            }
            task.resume()
            
        }
        
    }
    
    func categoryPlaylists(categoryName: String, completion: @escaping (Result<CategoryDetailsResponse, Error>) -> Void) {
        let urlString = "https://api.spotify.com/v1/search?q=\(categoryName)&type=playlist&limit=20"
        //"https://api.spotify.com/v1/browse/categories/\(categoryID)"
        
        createRequest(with: URL(string: urlString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let categoryDetails = try JSONDecoder().decode(CategoryDetailsResponse.self, from: data)
                    //JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    
                    print("categoryDetails:\(categoryDetails)")
                    
                    
                    
                    completion(.success(categoryDetails))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    func fetchTracks(for playlist: Playlist, completion: @escaping (Result<[AudioTrack], Error>) -> Void) {
        
        createRequest(with: URL(string: playlist.tracks.href), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? NSError(domain: "Unknown Error", code: -1, userInfo: nil)))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print("json data :\(json)")
                    if let items = json?["items"] as? [[String: Any]] {
                        var tracks: [AudioTrack] = []
                        for item in items {
                            if let trackData = item["track"] as? [String: Any],
                               let track = try? JSONDecoder().decode(AudioTrack.self, from: JSONSerialization.data(withJSONObject: trackData)) {
                                tracks.append(track)
                            }
                        }
                        completion(.success(tracks))
                    } else {
                        completion(.failure(NSError(domain: "Invalid Data", code: -1, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    func searchResult(query:String,completion : @escaping(Result<SearchResponse,Error>)->Void){
        let urlString = "https://api.spotify.com/v1/search?q=\(query)&type=track&limit=2"
        createRequest(with: URL(string: urlString), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                    //JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print("search result is\(result)")
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
}
