import Foundation

// MARK: - ResponseHandler

protocol ResponseHandler {
    func getResponse<T: Decodable>(from response: Data) throws -> T
}

// MARK: - APIResponseHandler

struct APIResponseHandler: ResponseHandler {
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    func getResponse<T: Decodable>(from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw RequestError.decode(description: error.localizedDescription)
        }
    }
}


// MARK: -

extension Data {
    func printJson() {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                debugPrint("Inavlid data")
                return
            }
            debugPrint(jsonString)
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }
}
