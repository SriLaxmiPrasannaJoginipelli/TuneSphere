//
//  AuthManager.swift
//  TuneSphere
//
//  Created by Srilu Rao on 1/29/25.
//

import Foundation

final class AuthManager{
    
    private var refreshingToken = false
    static let shared = AuthManager()
    
    private init(){
        
    }
    
    
    private struct Constants{
        static let clientId = "a2a0b6abacee4cf297d5b140d00a394d"
        static let clientSecret = "c78d6f10c62a4f0798ab1dea18f456dd"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "spotify-ios-quick-start://spotify-login-callback"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private"
    }
    
    public var signInURL:URL?{
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientId)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    var isSigned:Bool{
        return accessToken != nil
    }
    
    private var accessToken:String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken:String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate:Date?{
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    //to handle storage of action if refresh did happen after any API call
    private var onRefresh = [(String)->Void]()
//    public func validToken(completion:@escaping(String)->Void){
//        guard !refreshingToken else{
//            onRefresh.append(completion)
//            return
//        }
//        if shouldReferesh{
//            //refresh
//            refreshIfNeeded { [weak self]sucess in
//                
//                if let token = self?.accessToken,sucess{
//                    print("Access token is:\(String(describing: self?.accessToken))")
//                    completion(token)
//                }
//                
//                
//            }
//        }else if let token = accessToken{
//            completion(token)
//        }
//    }
    
    public func validToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefresh.append(completion)
            return
        }

        if shouldReferesh {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    print("✅ Access Token (after refresh): \(token)")
                    completion(token)
                } else {
                    print("❌ Failed to refresh token.")
                    // You may want to handle a failed refresh here (e.g., prompt user to re-login)
                }
            }
        } else if let token = accessToken {
            print("✅ Access Token (cached): \(token)")
            completion(token)
        } else {
            print("❌ No valid access token found.")
        }
    }

    private var shouldReferesh:Bool{
        guard let expirationDate = tokenExpirationDate else{
            return false
        }
        //current date
        let date = Date()
        let fiveMinutes : TimeInterval = 300
        //refresh token when we atleast have five minutes left to token expiry
        return Date().addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code:String, completion:@escaping((Bool)->Void)){
        
        //get the token
        
        guard let url = URL(string: Constants.tokenAPIURL) else{
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
            
        ]
        
        let basic = Constants.clientId+":"+Constants.clientSecret
        guard let data = basic.data(using: .utf8) else {
            print("Failed to encode client credentials")
            return
        }
        let base64String = data.base64EncodedString()
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self]data, _, error in
            guard let data = data, error == nil else{
                completion(false)
                return
            }
            
            do{
                //cpnverts data to json
                let result = try JSONDecoder().decode(AuthResponse.self,from:data)
                self?.cacheToken(result:result)
                completion(true)
            }catch{
                completion(false)
            }
            
            
        }
        
        task.resume()
        
    }
    
    public func refreshIfNeeded(completion : ((Bool)->Void)?){
        guard !refreshingToken else {
            completion?(false) // Prevent multiple simultaneous refresh calls
            return
        }

        guard shouldReferesh else {
            completion?(true)
            return
        }

        guard let refreshToken = self.refreshToken else {
            completion?(false) // No refresh token available
            return
        }

        // Refresh the token
        refreshingToken = true
        guard let url = URL(string: Constants.tokenAPIURL) else {
            completion?(false)
            return
        }

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]

        let basic = Constants.clientId + ":" + Constants.clientSecret
        guard let data = basic.data(using: .utf8) else {
            print("Failed to encode client credentials")
            completion?(false)
            return
        }
        
        let base64String = data.base64EncodedString()

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            
            guard let data = data, error == nil else {
                print("❌ Error during token refresh: \(error?.localizedDescription ?? "Unknown error")")
                completion?(false)
                return
            }

            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                // Cache new tokens
                self?.cacheToken(result: result)
                // Notify all queued callbacks
                self?.onRefresh.forEach { $0(result.access_token) }
                self?.onRefresh.removeAll()
                print("✅ Successfully refreshed token!")
                completion?(true)
            } catch {
                print("❌ Error decoding token refresh response: \(error.localizedDescription)")
                completion?(false)
            }
        }

        task.resume()
    }
    
    private func cacheToken(result:AuthResponse){
        
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token{
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        //current time user logs in + no/of seconds it expires in.
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        
        
        
    }
    
    func signOut(completion : (Bool)->Void){
        
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        
        completion(true)
        
    }
    
    
    
    
}
