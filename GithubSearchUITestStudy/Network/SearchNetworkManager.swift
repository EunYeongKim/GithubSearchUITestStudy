//
//  NetworkManager.swift
//  GithubSearchUITestStudy
//
//  Created by 60080252 on 2021/05/20.
//

import Foundation
import Alamofire

protocol ViewControllerDelegate: class {
    func dataSourceChanged()
}

class SearchNetworkManager {
    weak var delegate: ViewControllerDelegate?
    var paginationAvailable = false
    let PERPAGE = 20
    
    private var isInProgressPagination = false
    private var latestQuery = ""
    private var latestPage = 1
    private(set) var users: [Search.User] = [] {
        didSet {
            delegate?.dataSourceChanged()
        }
    }
    
    func search(query: String, page: Int, completion: @escaping()-> Void) -> Bool {
        if latestQuery != query {
            users.removeAll()
        }
        latestQuery = query
        
        guard !query.isEmpty else {
            completion()
            return false
        }
        
        let header = Search.Header().jsonValue()
        let params = Search.Parameter(query: query,
                                      sort: .default,
                                      order: .desc,
                                      page: page,
                                      perPage: PERPAGE).jsonValue()
        
        AF.request(Search.API.search,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: header).responseJSON { response in
            switch response.result {
            case .success(let value):
                self.didSearchSuccess(response: value, completion: completion)
            case .failure(let error):
                self.didSearchFail(error: error, completion: completion)
            }
        }
        
        return true
    }
    
    func searchNextPage(completion: @escaping()-> Void)-> Bool {
        guard paginationAvailable, !isInProgressPagination else { return false }
        
        latestPage += 1
        isInProgressPagination = true
        search(query: latestQuery, page: latestPage, completion: completion)
        
        return true
    }

    func didSearchSuccess(response: Any, completion: @escaping() -> Void) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let result = try JSONDecoder().decode(Search.Response.self, from: jsonData)
            
            if isInProgressPagination {
                self.users.append(contentsOf: result.items)
            } else {
                self.users = result.items
            }
            
            calcNextPageAvailable(totalCount: result.totalCount)
            
            completion()
        } catch {
            print(error.localizedDescription)
        }
        isInProgressPagination = false
    }
    
    func didSearchFail(error: Alamofire.AFError ,completion: @escaping() -> Void) {
        print(error);
    }
    
    func calcNextPageAvailable(totalCount: Int) {
        if (latestPage * PERPAGE) < totalCount {
            paginationAvailable = true
        } else {
            paginationAvailable = false
        }
    }
}
