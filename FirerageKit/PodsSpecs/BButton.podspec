Pod::Spec.new do |s|
	s.name				= 'BButton'
	s.version			= '4.0.0'
	s.summary			= 'Twitter Bootstrap buttons for iOS'
	s.homepage			= 'https://github.com/jessesquires/BButton'
	s.social_media_url	= 'https://twitter.com/jesse_squires'
	s.license			= 'MIT'
	s.authors			= { 'Jesse Squires' => 'jesse.squires.developer@gmail.com', 'Mathieu Bolard' => 'mattlawer08@gmail.com' }
	s.source			= { :git => 'https://github.com/illidan-firerage/BButton', :commit => 'e35dfb1fe82b7d93f2ead5c809d6cb7189679109' }
	s.platform			= :ios, '5.1.1'
	s.source_files		= 'BButton/Classes/*'
	s.resource			= 'BButton/Resources/*'
	s.framework			= 'CoreGraphics'
	s.requires_arc		= true
end
