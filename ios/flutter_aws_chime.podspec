#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_aws_chime.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_aws_chime'
  s.version          = '1.1.0'
  s.summary          = 'A flutter plugin for supporting aws chime usage.'
  s.description      = <<-DESC
A flutter plugin for supporting aws chime usage.
                       DESC
  s.homepage         = 'https://www.linkedin.com/in/yijia-li/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'liyijia428@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.static_framework = true

  # third party platform
  s.dependency 'AmazonChimeSDK'
  s.dependency 'AmazonChimeSDKMachineLearning'

  # s.xcconfig = { 'OTHER_LDFLAGS' => '-framework AmazonChimeSDKMachineLearning' }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
