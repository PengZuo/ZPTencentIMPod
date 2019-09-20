#
# Be sure to run `pod lib lint ZPTencentIMPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZPTencentIMPod'
  s.version          = '0.1.1'
  s.summary          = '腾讯IM'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/PengZuo/ZPTencentIMPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zp_crash@163.com' => '[zp_crash@163.com]' }
  s.source           = { :git => 'https://github.com/PengZuo/ZPTencentIMPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZPTencentIMPod/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZPTencentIMPod' => ['ZPTencentIMPod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
s.dependency 'TXIMSDK_TUIKit_iOS', '~> 4.4.479'
end
