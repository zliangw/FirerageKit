#
#  Be sure to run `pod spec lint FirerageKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
   s.name         = "FirerageKit"
   s.version      = "0.0.1"
   s.summary      = "FirerageKit is an Objective-C library for iOS developers."
   s.homepage     = "https://github.com/illidan-firerage/FirerageKit"
   s.license      = 'MIT'
   s.author       = { "illidan" => "illidan.firerage@qq.com" }
   s.source       = { :git => "https://github.com/illidan-firerage/FirerageKit.git", :commit => '9546dbca36138423759527a3bbb68fc4f28b7eb0' }
   s.platform     = :ios, '7.0.0'
   s.requires_arc = true

   s.subspec 'Control' do |cl|
     cl.source_files = 'Firerage/FRCategories/Control/*.{h,m}'
   end

   s.subspec 'ImageView' do |iv|
     iv.source_files = 'Firerage/FRCategories/ImageView/*.{h,m}'
   end

   s.subspec 'Image' do |image|
     image.source_files = 'Firerage/FRCategories/Image/*.{h,m}'
   end

   s.subspec 'Button' do |bt|
     bt.source_files = 'Firerage/FRCategories/Button/*.{h,m}'
   end

   s.subspec 'String' do |st|
     st.source_files = 'Firerage/FRCategories/String/*.{h,m}'
   end

   s.subspec 'Label' do |lb|
     lb.source_files = 'Firerage/FRCategories/Label/*.{h,m}'
   end

   s.subspec 'View' do |view|
     view.source_files = 'Firerage/FRCategories/View/*.{h,m}'
   end

   s.subspec 'Date' do |date|
     date.source_files = 'Firerage/FRCategories/Date/*.{h,m}'
   end

   s.subspec 'AlertView' do |alertView|
    alertView.source_files = 'Firerage/FRCategories/AlertView/*.{h,m}'
   end
git add
   s.subspec 'ActionSheet' do |actionSheet|
    actionSheet.source_files = 'Firerage/FRCategories/ActionSheet/*.{h,m}'
   end

   s.subspec 'NetworkingModule' do |nm|
     nm.source_files = 'Firerage/NetworkingModule/**/*.{h,m}'
   end
end