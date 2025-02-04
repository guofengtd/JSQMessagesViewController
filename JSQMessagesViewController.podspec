Pod::Spec.new do |s|
	s.name = 'JSQMessagesViewController'
	s.version = '7.3.5'
	s.summary = 'An elegant messages UI library for iOS.'
	s.license = 'MIT'
	s.platform = :ios, '7.0'

	s.author = 'Jesse Squires'
	s.homepage         = 'https://github.com/guofengtd/JSQMessagesViewController'
	s.source = { :git => 'https://github.com/guofengtd/JSQMessagesViewController.git', :tag => s.version }
	s.source_files = 'JSQMessagesViewController/**/*.{h,m}'

	s.resources = ['JSQMessagesViewController/Assets/JSQMessagesAssets.bundle', 'JSQMessagesViewController/**/*.{xib}']
  
	s.frameworks = 'QuartzCore', 'CoreGraphics', 'CoreLocation', 'MapKit', 'MobileCoreServices', 'AVFoundation'
	s.requires_arc = true

  s.dependency 'Masonry'
  s.dependency 'GolfTools'
  
  s.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ANIMATED_GIF_SUPPORT=1' }
  s.dependency 'PINRemoteImage/iOS'
  s.dependency 'PINRemoteImage/PINCache'
  
end
