# MLNetworkLogger

[![CI Status](http://img.shields.io/travis/MUSTLab Developer/MLNetworkLogger.svg?style=flat)](https://travis-ci.org/MUSTLab Developer/MLNetworkLogger)
[![Version](https://img.shields.io/cocoapods/v/MLNetworkLogger.svg?style=flat)](http://cocoadocs.org/docsets/MLNetworkLogger)
[![License](https://img.shields.io/cocoapods/l/MLNetworkLogger.svg?style=flat)](http://cocoadocs.org/docsets/MLNetworkLogger)
[![Platform](https://img.shields.io/cocoapods/p/MLNetworkLogger.svg?style=flat)](http://cocoadocs.org/docsets/MLNetworkLogger)

## Usage

In your App Delegate just add these lines for basic setup (this will enable requests& responses logging from global NSURLSession and NSURLConnection):

```
#!objective-c
#import <MLNetworkLogger.h>
```
In your **application:didFinishLaunchingWithOptions:** just add:
```
#!objective-c
[[MLNetworkLogger sharedLogger] startLogging];
```
and you are ready to go! But you can do a lot more with customizations...

### To log traffic also from AFNetworking just add this:
```
#!objective-c
    [[MLNetworkLogger sharedLogger] addAdapter:[MLAFNetworkingAdapter new]];
```

### To set log detalization:
```
#!objective-c
    [[MLNetworkLogger sharedLogger] setLogDetalization:MLNetworkLoggerLogDetalizationHigh];
```

### Here is what different detallization level means for HTTP requests/responses:
* **MLNetworkLoggerLogDetalizationLow** - will log only URL, HTTP method and status code
* **MLNetworkLoggerLogDetalizationMedium** - will log only URL, HTTP method, status code and HTTP headers
* **MLNetworkLoggerLogDetalizationHigh** - will log all HTTP headers and the body

### Optionally you can set a requests filter:
```
#!objective-c
[[MLNetworkLogger sharedLogger] setRequestFilter:[MLHostnameRequestFilter filterWithHostnames:@[@"apple.com"]]];
```
**NOTE:** Currently we only have hostname filter preinstalled, which you can use to log network traffic only from specific hosts, or match them with RegEx pattern. And still you can write your own filter and do a pull request to make it available to everybody.

### You can change logging format for requests, currently we support regular and cURL formats:
```
#!objective-c
    [[MLNetworkLogger sharedLogger] setRequestLogFormat:MLNetworkLoggerRequestLogFormatCURL];
```

### Also we support adapters to log traffic from different networking frameworks:

Currently we support only AFNetworking, so to log from it just add this:
```
#!objective-c
[[MLNetworkLogger sharedLogger] addAdapter:[MLAFNetworkingAdapter new]];
```
**NOTE:** we know that AFNetworking uses native NSURLSession/NSURLConnection classes to operate with requests and responses, but the problem is that it creates it's own NSURLSession object which can be logged only by the AFNetworking framework itself and is not accessible from any external framework. So you need this option only if you use AFNetworking with AFURLSessionManager API.

To run the example project, clone the repo, and run `pod try MLNetworkLogger`

## Requirements

* iOS 7+
* Xcode 5+

## Installation

MLNetworkLogger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MLNetworkLogger"

## Author

MUSTLab Developer, hello@mustlab.ru

## License

MLNetworkLogger is available under the MIT license. See the LICENSE file for more info.