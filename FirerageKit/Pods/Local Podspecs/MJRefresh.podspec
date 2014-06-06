Pod::Spec.new do |s|
   s.name         = "MJRefresh"
   s.version      = "0.0.1"
   s.summary      = "MJRefresh."
   s.homepage     = "https://github.com/illidan-firerage/MJRefresh"
   s.license      = 'MIT'
   s.author       = { "MJRefresh" => "MJRefresh" }
   s.source       = { :git => "https://github.com/illidan-firerage/MJRefresh.git", :commit => 'c6f8c179dcd5cb0c5d312b923699e42b73f0d654' }
   s.platform     = :ios, '5.1.1'

   s.source_files = 'MJRefreshExample/MJRefreshExample/MJRefresh/*.{h,m}',
   s.resources = "MJRefreshExample/MJRefreshExample/MJRefresh/*.bundle"

   s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit', 'QuartzCore'
   
   s.requires_arc = true
 end
