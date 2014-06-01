Pod::Spec.new do |s|
	s.name				= 'HPGrowingTextView'
	s.version			= '0.0.1'
	s.summary			= 'HPGrowingTextView'
	s.homepage			= 'https://github.com/illidan-firerage/HPGrowingTextView'
	s.social_media_url	= 'https://github.com/illidan-firerage/HPGrowingTextView'
	s.license			= 'MIT'
	s.authors			= { 'illidan' => 'illidan' }
	s.source			= { :git => 'https://github.com/illidan-firerage/HPGrowingTextView.git', :commit => 'e014ffd4606861d1d373c60d43f4b284e1fb2685' }
	s.platform			= :ios, '5.1.1'
	s.source_files		= '*.{h,m}'
	s.framework			= 'UIKit','Foundation','CoreGraphics'
	s.requires_arc		= true
end
