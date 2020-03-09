#
# Be sure to run `pod lib lint TimeUIList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TimeUIList'
  s.version          = '0.0.15'
  s.summary          = 'A short description of TimeUIList.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description  = <<-DESC
         xxx
  DESC
  s.homepage         = 'https://github.com/niefeian/TimeUIList'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '335074307@qq.com' => '872447993@qq.com' }
  s.source           = { :git => 'https://github.com/niefeian/TimeUIList.git', :tag => s.version.to_s }
   s.swift_version = '5.0'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TimeUIList/Classes/*'
  s.resource_bundles = {
     'TimeUIList' => ['TimeUIList/Assets/*.{png,xib}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'NFALunarUtil'
  s.dependency 'NFAToolkit'
  s.dependency 'NFATipsUI'
  
end
