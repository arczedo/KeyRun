//
//  Logger.swift
//  uiPackN
//
//  Created by JPZ3562 on 2022/03/16.
//

import Combine
import Foundation
#if LOGGING
import Logging
#endif

// MARK: - debug helpers
func log(_ c: String, _ items: [Any]) {
    Log.shared.qSend(c, items.map { "<xmp>\(_desc($0))</xmp>" }.joined(separator: "<br>"))
//    Log.shared.qSend(c, items.map { _desc($0) }.joined(separator: "\n"))
}

func log(_ c: Int, _ items: Any...) {
    Log.shared.qSend(c.toS(), items.map { "<xmp>\(_desc($0))</xmp>" }.joined(separator: "<br>"))
}

fileprivate func _desc(_ x: Any) -> String {
    String(describing: x)
}

public func log1(_ items: Any...) { log("1", items) }
public func log2(_ items: Any...) { log("2", items) }
public func log3(_ items: Any...) { log("3", items) }
public func log4(_ items: Any...) { log("4", items) }
public func log5(_ items: Any...) { log("5", items) }
public func log6(_ items: Any...) { log("6", items) }
public func log7(_ items: Any...) { log("7", items) }
public func log8(_ items: Any...) { log("8", items) }
public func log9(_ items: Any...) { log("9", items) }
public func logM(_ items: Any...) { log("m", items) }

public func logClear() { log("clear", []) }

public func fileLink(_ s: String, _ ln: UInt) -> String {
    var urlComponents = URLComponents()
    urlComponents.path = "/open"
    urlComponents.queryItems = [
        URLQueryItem(name: "path", value: s),
        URLQueryItem(name: "ln", value: ln.toS()),
    ]
    urlComponents.escapePlusSign()

    let name = URL(string: s)?.lastPathComponent ?? ""
    return "\n<button onclick='fetch(\"\(urlComponents.url!)\")'>🔎 \(name) #\(ln)</button>"
}

class Log {

    let session = URLSession(configuration: .default)
//    private let q = DispatchQueue(label: "logc")

    private var bag = Set<AnyCancellable>()
    //    var channel: Channel
    //    var message: String

    init() {
        qSend("clear", "")
        qSend("1", "⭐️")
    }

    static let shared = Log()
    let g = DispatchSemaphore(value: 1)
    private func send(_ c: String, _ s: String) {
        g.wait()

        var components = URLComponents()
        components.scheme = "http"
        components.host = "127.0.0.1"
        components.port = 4567
        components.path = "/send"
        var req = URLRequest(url: components.url!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: ["c": c, "message": s], options: .prettyPrinted)

        session
            .dataTaskPublisher(for: req)
            .sink(
                receiveCompletion: { r in
                    self.g.signal()
                },
                receiveValue: { r in
                }
            )
            .store(in: &bag)
    }

    func qSend(_ c: String, _ s: String) {
        send(c, s)
    }
}

extension URLComponents {
    mutating func escapePlusSign() {
        percentEncodedQuery = percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
    }
}
#if LOGGING
public struct SafariLogHandler: LogHandler {
    public static func shared(label: String) -> SafariLogHandler {
        SafariLogHandler(label: label)
    }

    private let label: String
    internal init(label: String) {
        self.label = label
    }

    public var logLevel: Logger.Level = .info

    public var metadata = Logger.Metadata()

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set {
            metadata[metadataKey] = newValue
        }
    }

    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        if let i = metadata?.channel {
            SafariLogger.log(i, message, fileLink(file, line), function)
        } else {
            log1(message, fileLink(file, line), function)
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        !metadata.isEmpty
            ? metadata.lazy.sorted(by: { $0.key < $1.key }).map { "\($0)=\($1)" }.joined(separator: " ")
            : nil
    }

}
extension Logger.Metadata {
    var channel: Int? {
        if case .string(let s) = self["channel"], let i = Int(s) {
            return i
        }
        return nil
    }
}

#endif
extension BinaryInteger {
    func toS() -> String {
        description
    }
}

public func pj(_ data: Data) -> String {
    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
        return String(decoding: jsonData, as: UTF8.self)
    } else {
        return "Not JSON Data."
    }
}

public func po(_ obj: Any) -> String {
    if let jsonData = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted) {
        return String(decoding: jsonData, as: UTF8.self)
    } else {
        return "Not JSON Data."
    }
}

public func po(_ obj: Codable) -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    if let jsonData = try? encoder.encode(obj) {
        return String(decoding: jsonData, as: UTF8.self)
    } else {
        return "Not JSON Data."
    }
}

extension String {
    func f1() -> String {
        replacingOccurrences(of: "\\[\n[ \n]*?\\]", with: "[]", options: .regularExpression, range: .init(NSRange(location: 0, length: count), in: self))
    }
    func f2() -> String {
        replacingOccurrences(of: "\\{\n[ \n]*?\\}", with: "{}", options: .regularExpression, range: .init(NSRange(location: 0, length: count), in: self))
    }
}

public func pos(_ obj: Codable) -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    if let jsonData = try? encoder.encode(obj) {
        return String(decoding: jsonData, as: UTF8.self).f1().f2()
    } else {
        return "Not JSON Data."
    }
}

extension URLRequest {
    func curlString() -> String {
        var t = """

            curl -X '\(httpMethod ?? "")' \\
            '\(url?.absoluteString ?? "")' \\
            \((allHTTPHeaderFields ?? [:]).map{"-H \"\($0): \($1)\""}.joined(separator: " \\\n")) \\
            """
        if let data = httpBody,
            let string = String(data: data, encoding: .utf8),
            !string.isEmpty
        {
            t += "\n--data '\(string)'"
        }

        return t + "\n"
    }

    var accessToken: String? {
        if let t = value(forHTTPHeaderField: "Authorization"),
            t.hasPrefix("Bearer ")
        {
            return String(t.suffix(t.count - 7))
        }
        return nil
    }
}
