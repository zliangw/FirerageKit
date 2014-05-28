Pod::Spec.new do |s|
	s.name				= 'BlockUI'
	s.version			= '0.0.1'
	s.summary			= 'UIControl use block as call back.easy,simple and high performance'
	s.homepage			= 'https://github.com/zhangxigithub/BlockUI'
	s.social_media_url	= 'https://github.com/zhangxigithub/BlockUI'
	s.license			= 'MIT'
	s.authors			= { 'zhangxigithub' => 'zhangxigithub' }
	s.source			= { :git => 'https://github.com/zhangxigithub/BlockUI.git', :commit => 'cce90f585f552dde14131444eb8a474454aff8a7' }
	s.platform			= :ios, '5.1.1'
	s.source_files		= 'BlockUI/*.{h,m}'
	s.framework			= 'UIKit','Foundation','CoreGraphics'
	s.requires_arc		= true
end
