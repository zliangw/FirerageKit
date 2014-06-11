Pod::Spec.new do |s|
  s.name     = 'UIBubbleTableView'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Cocoa UI component for chat bubbles with avatars and images support'
  s.homepage = 'https://github.com/iSapozhnik/NavigationMenu'
  s.author   = { 'iSapozhnik' => 'iSapozhnik' }
  s.source   = { :git => 'https://github.com/illidan-firerage/UIBubbleTableView.git', :commit => '566291b595e1a33df00965991f4f13024b703d50' }
  s.platform = :ios, '5.1.1'
  s.source_files = 'src/*.{h,m}'
  s.resources = "images/*@2x.png"
  s.framework = 'UIKit','Foundation','CoreGraphics','QuartzCore'
  s.requires_arc = true  
end