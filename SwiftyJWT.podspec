Pod::Spec.new do |s|
  s.name         = "SwiftyJWT"
  s.version      = "0.0.8"
  s.summary      = "A library to generate JWT with Swift"
  s.homepage     = "https://github.com/Wstunes/SwiftyJWT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Wstunes" => "wangshuogr@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/bloombox/SwiftyJWT.git", :tag => s.version }
  s.source_files = 'Sources/**/*.swift'
  s.dependency 'SwiftyCrypto', '~> 0.0.3'
  s.swift_version = '4.2'
end
