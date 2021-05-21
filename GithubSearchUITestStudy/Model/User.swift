//
//  User.swift
//  GithubSearchUITestStudy
//
//  Created by 60080252 on 2021/05/20.
//

import Foundation
import Alamofire

struct Search {
    struct API {
        static let search = "https://api.github.com/search/users"
    }
    
    struct Header {
        var clientId: String? {
            if let id = Bundle.main.object(forInfoDictionaryKey: "GITHUB_CLIENT_ID") as? String, id.isEmpty == false {
                return id
            }
            return nil
        }
        var clientSecret: String? {
            if let secret = Bundle.main.object(forInfoDictionaryKey: "GITHUB_CLIENT_SECRET") as? String, secret.isEmpty == false {
                return secret
            }
            return nil
        }
    
        func jsonValue()-> HTTPHeaders? {
            guard let id = clientId, let secret = clientSecret else { return nil }
            return ["client_id": id,
                    "client_secret": secret]
        }
    }
    
    struct Parameter {
        enum Sort: String {
            case `default` = ""
            case followers = "followers"
            case repositories = "repositories"
            case joined = "joined"
        }
        
        enum Order: String {
            case desc = "desc"
            case asc = "asc"
        }
        
        let query: String
        let sort: Sort?
        let order: Order?
        let page: Int?
        let perPage: Int?
        
        init(query: String, sort: Sort? = nil, order: Order? = nil, page: Int? = nil, perPage: Int? = nil) {
            self.query = query
            self.sort = sort
            self.order = order
            self.page = page
            self.perPage = perPage
        }
        
        func jsonValue()-> [String: Any] {
            return ["q": self.query,
                    "sort": self.sort?.rawValue,
                    "order": self.order?.rawValue,
                    "page": self.page,
                    "per_page": self.perPage]
        }
    }
    
    struct User: Codable {
        let name: String
        let id: Int
        let nodeId: String
        let avatarUrl: String?
        let gravartarId: String
        let url: String?
        let htmlUrl: String?
        let followersUrl: String?
        let subscriptionsUrl: String?
        let organizationsUrl: String?
        let repositoriesUrl: String?
        let receivedEventsUrl: String?
        let type: String?
        let score: Double
    }
    
    struct Response: Codable {
        let totalCount: Int
        let incompleteResults: Bool
        let items: [User]
    }
    
}

extension Search.Response {
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
}

extension Search.User {
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case id = "id"
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravartarId = "gravatar_id"
        case url = "url"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case repositoriesUrl = "repos_url"
        case receivedEventsUrl = "received_events_url"
        case type = "type"
        case score = "score"
    }
}
