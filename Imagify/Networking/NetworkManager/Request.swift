import Foundation

// MARK: - Request

protocol Request {
    var host        : String { get }
    var scheme      : String { get }
    var path        : String { get }
    var requestType : RequestType { get }
    var headers     : [String: String] { get }
    var queryItems  : [String: String] { get }
    var params      : [String: Any] { get }
}

extension Request {
    var host: String {
        APIHost.base.urlString
    }
    
    var scheme: String {
        "https"
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var queryItems: [String: String] {
        [:]
    }
    
    var params: [String: Any] {
        [:]
    }
    
    var requestType: RequestType {
        .get
    }
    
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems.map({ URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        return urlRequest
    }
}
