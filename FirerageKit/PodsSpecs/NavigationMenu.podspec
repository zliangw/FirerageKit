Pod::Spec.new do |s|
  s.name     = 'NavigationMenu'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Objective-C component that adds menu to the navigation bar.'
  s.homepage = 'https://github.com/iSapozhnik/NavigationMenu'
  s.author   = { 'iSapozhnik' => 'iSapozhnik' }
  s.source   = { :git => 'https://github.com/iSapozhnik/NavigationMenu.git', :commit => '7e2528d2a22e67528137cbfa649f950d07716317' }
  s.platform = :ios  
  s.source_files = 'NavigationMenu/NavigationMenu/NavigationMenuView/*.{h,m}'
  s.framework = 'UIKit','Foundation','CoreGraphics'
  s.requires_arc = true  
end