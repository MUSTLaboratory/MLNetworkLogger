Pod::Spec.new do |s|
  s.name             = "MLNetworkLogger"
  s.version          = "0.1.0"
  s.summary          = "A short description of MLNetworkLogger."
  s.description      = ""
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/MLNetworkLogger"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "MUSTLab Developer" => "hello@mustlab.ru" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/MLNetworkLogger.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'MLNetworkLogger' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
