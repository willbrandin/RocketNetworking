
# Rocket Networking 🚀
Lightweight protocol oriented Networking

## Installation

### Dependency Managers

<details>
<summary><strong>CocoaPods</strong></summary>

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate RocketNetworking into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!
pod 'RocketNetworking'
```

Then, run the following command:

```bash
$ pod install
```
</details>

### Setup

#### Define Endpoints
A type that conforms to `EndPointType` defines the http request to be used in the Router.

```swift
enum MyAPIEndpoint {
 case getMyEndpoint(id: Int)
 case submitForm(data: MyPropertyLoopableObject)
}
```

<details>
<summary>Conform to EndpointType</summary>

```swift
extension MyAPIEndpoint: EndPointType {

  var environmentBaseURL: String {
      return "http://stg.schoolconnected.net/api"
  }

  var baseURL: URL {
      guard let url = URL(string: environmentBaseURL) else { fatalError("base url could not be config") }
      return url
  }

  var path: String {
      switch self {
      case .getMyEndpoint(id: let id):
          return "/user/info/\(id)"
      case .submitForm:
          return "/message/"
      }
  }

  var httpMethod: HTTPMethod {
      switch self {
      case .getMyEndpoint: return .get
      case .submitForm: return .post
      }
  }

  var task: HTTPTask {
      switch self {
      case .getMyEndpoint(let data):
          return .requestParameters(bodyParameters: data, urlParameters: nil)
      default:
          return .request
      }
  }

  var headers: HTTPHeaders? {
      switch self {
      case .getMyEndpoint:
          return ["hello": "world"]
      default:
          return nil
      }
  }
}
```
</details>

#### Instance of RocketNetworkManager
You can create a singleton.
```swift
struct NetworkManager {
  static let sharedInstance = RocketNetworkManager<MyAPIEndpoint>()

  static func setEnvironment(for environment: NetworkEnvironment) {
      NetworkManager.sharedInstance.setupNetworkLayer(in: environment)
  }
}
```
In `AppDelegate`
```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

  NetworkManger.sharedInstance.setEnvironment(for: .development)
  return true
}
```
