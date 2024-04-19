import Foundation

// MARK: - RequestHandler

protocol RequestHandler {
    func sendRequest(_ request: Request) async throws -> Data
}

// MARK: - APIRequestHandler

struct APIRequestHandler: RequestHandler {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func sendRequest(_ request: Request) async throws -> Data {
        let urlRequest = try request.createURLRequest()
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.failed(description: "Request Failed.")
        }
        switch response.statusCode {
        case 200...299:
            return data
        case 401:
            throw RequestError.unauthorized
        default:
            throw RequestError.unexpectedStatusCode(description: "Status Code: \(response.statusCode)")
        }
    }
}
