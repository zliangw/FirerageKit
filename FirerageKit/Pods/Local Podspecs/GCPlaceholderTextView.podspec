Pod::Spec.new do |s|
  s.name     = 'GCPlaceholderTextView'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'A subclass of UITextView that allow a placeholder.'
  s.homepage = 'https://github.com/gcamp/GCPlaceholderTextView'
  s.author   = { 'gcamp' => 'gcamp' }
  s.source   = { :git => 'https://github.com/gcamp/GCPlaceholderTextView.git', :commit => 'c89d0d2563b976f4b1dca04f68d59bc94394f2f6' }
  s.source_files = 'GCPlaceholderTextView/*.{h,m}'
  s.platform = :ios, '5.1.1'
  s.framework = 'UIKit','Foundation','CoreGraphics'
  s.requires_arc = true  
end
