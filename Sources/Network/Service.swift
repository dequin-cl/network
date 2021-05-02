import Foundation
import RxCocoa
import RxSwift

public struct Resource<T: Decodable> {
    let url: URL
    let retries: Int
    
    public init(url: URL, retries: Int = 1) {
        self.url = url
        self.retries = retries
    }
}

@available(iOS 10,macOS 10.12, *)
public enum APIService {
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    static public func load<T>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in

                if 200 ..< 300 ~= response.statusCode {
                    return try decoder.decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
    }

    static public func load<T>(resource: Resource<T>,
                        disposeBag: DisposeBag,
                        callback: @escaping ((T?, Error?) -> Void))
    {
        APIService.load(resource: resource)
            .retry(resource.retries)
            .materialize()
            .subscribe(onNext: { event in
                switch event {
                case let .error(error):
                    callback(nil, error)
                case let .next(result):
                    callback(result, nil)
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}
