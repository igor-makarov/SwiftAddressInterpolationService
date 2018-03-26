import Swifter
import AddressInterpolation
import Foundation
import Dispatch


let server = HttpServer()

let databaseDir = ProcessInfo.processInfo.environment["INTERPOLATION_DATA_DIR"]!

server.get["/search"] = { request -> HttpResponse in
    let requestDebug = "\(request.method) \(request.path)"
    let time = Date()
    let query = Dictionary(uniqueKeysWithValues: request.queryParams)
    guard let houseNumber = query["number"] else { return .badRequest(nil) }
    guard let street = query["street"] else { return .badRequest(nil) }
    guard let lat = Double(query["lat"] ?? "") else { return .badRequest(nil) }
    guard let lon = Double(query["lon"] ?? "") else { return .badRequest(nil) }
    let latLon = LatLon(lat: lat, lon: lon)
    do {
        let interpolator = try Interpolator(dataDirectory: URL(fileURLWithPath: databaseDir))
        guard let result = try interpolator.interpolate(street: street, houseNumber: houseNumber, coordinate: latLon) else {
            let time = String(format: "%.2fms", Date().timeIntervalSince(time) / 1000)
            print("\(requestDebug) 404 \(time)")
            return .notFound
        }
        let data = try JSONEncoder().encode(result)
        let str = String(data: data, encoding: .utf8) ?? ""
        let time = String(format: "%.2fms", Date().timeIntervalSince(time) * 1000)
        print("\(requestDebug) 200 \(time)")
        return .ok(.text(str + "\n"))
    } catch let error {
        print("\(requestDebug) 500 \(error)")
        return .internalServerError
    }
}

try! server.start(9999, priority: .userInteractive)

print(server.state)

Thread.sleep(until: .distantFuture)
