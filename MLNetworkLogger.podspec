Pod::Spec.new do |s|
  s.name             = "MLNetworkLogger"
  s.version          = "0.1.0"
  s.summary          = "Fast and extensible network activity logger of your choice."
  s.description      = "Extensible network activity logger mainly based on usage of Apple's URL Loading system architecture and NSURLProtocol class. Has no external dependencies other than Foundation. Supports NSURLConnection/NSURLSession/ AFNetworking logging."
  s.homepage         = "https://bitbucket.org/mustlab_opensource/mlnetworklogger"
  s.license          = 'MIT'
  s.author           = { "MUSTLab Developer" => "hello@mustlab.ru" }
  s.source           = { :git => "https://bitbucket.org/mustlab_opensource/mlnetworklogger.git", :tag => "0.1.0" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/**/*.m'

  s.public_header_files = 'Pod/Classes/**/**/*.h'
  s.frameworks = 'Foundation'
end
