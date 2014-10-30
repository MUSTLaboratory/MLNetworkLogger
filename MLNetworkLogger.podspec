Pod::Spec.new do |s|
  s.name             = "MLNetworkLogger"
  s.version          = "0.1.1"
  s.summary          = "Fast and extensible network activity logger of your choice."
  s.description      = "Extensible network activity logger mainly based on usage of Apple's URL Loading system architecture and NSURLProtocol class. Has no external dependencies other than Foundation. Supports NSURLConnection/NSURLSession/AFNetworking logging."
  s.homepage         = "https://github.com/MUSTLaboratory/MLNetworkLogger"
  s.license          = 'MIT'
  s.author           = { "MUSTLab Developer" => "hello@mustlab.ru" }
  s.source           = { :git => "https://github.com/MUSTLaboratory/MLNetworkLogger.git", :tag => "0.1.1" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{h,m}'

  s.public_header_files = 'Pod/Classes/**/*.h'

  s.frameworks = 'Foundation'
end
