import Foundation

// MARK: - NetworkHandler

protocol NetworkHandler {
    func fetch<T: Decodable>(request: Request) async throws -> T
}

// MARK: - NetworkManager

final class NetworkManager: NetworkHandler {
    var requestHandler  : RequestHandler
    var responseHandler : ResponseHandler
    
    init(requestHandler: RequestHandler = APIRequestHandler(), responseHandler: ResponseHandler = APIResponseHandler()) {
        self.requestHandler     = requestHandler
        self.responseHandler    = responseHandler
    }
    
    func fetch<T>(request: Request) async throws -> T where T : Decodable {
        let data = try await requestHandler.sendRequest(request)
        return try responseHandler.getResponse(from: data)
    }    
}
