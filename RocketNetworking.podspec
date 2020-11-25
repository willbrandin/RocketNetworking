#
#  Be sure to run `pod spec lint RocketNetworking.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RocketNetworking"
  s.version      = "1.0.0"
  s.summary      = "Lightweight Networking in pure swift"
  s.description  = "Lightweight Protocol oriented networking layer written in swift."
  s.homepage     = "https://github.com/willbrandin/RocketNetworking"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "willbrandin" => "will@tidelaundry.com" }
  s.platform     = :ios
  s.platform     = :ios, "12.0"
  s.source       = { :git => "https://github.com/willbrandin/RocketNetworking.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*.{swift}"

  s.swift_version = "4.2"

end
