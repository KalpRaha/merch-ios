//
//  MultipartFormDataBuilder.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 12/01/26.
//

import Foundation


public enum MultipartFormDataEntry {
    
    case file(paramName: String, fileName: String?, fileData: Data?, contentType: String)
    case string(paramName: String, value: Any?)
    
}


public class MultipartFormDataBodyBuilder {
        
    let boundary: String
    let entries: [MultipartFormDataEntry]
    
    public init(
        boundary: String,
        entries: [MultipartFormDataEntry]) {
        self.boundary = boundary
        self.entries = entries
    }
    
    func build() -> Data {
        entries.forEach({ entry in
            
            switch entry {
            case .file(let paramName, let fileName, let fileData, let contentType):
                Logger.log("MultiPart Param: Type - File, ParamName - \(paramName)), FileName - \(fileName ?? "N/A"), FileData - \(String(describing: fileData?.count)), ContentType - \(contentType)")
                
            case .string(let paramName, let value):
                Logger.log("MultiPart Param: Type - String, ParamName - \(paramName), Value - \(value ?? "N/A")")
            }
        })
        
        var httpData = entries
            .map { $0.makeBodyData(boundary: boundary) }
            .reduce(Data(), +)
        httpData.append("--\(boundary)--\r\n")
        return httpData
    }
}

private extension MultipartFormDataEntry {
    
    func makeBodyData(boundary: String) -> Data {
        var body = Data()
        switch self {
        case .file(let paramName, let fileName, let fileData, let contentType):
            if let fileName, let fileData {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n")
                body.append("Content-Type: \(contentType)\r\n\r\n")
                body.append(fileData)
                body.append("\r\n")
            }
        case .string(let paramName, let value):
            if let value {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(paramName)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        return body
    }
}

private extension Data {
    
    mutating func append(_ string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}
