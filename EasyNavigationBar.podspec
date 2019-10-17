Pod::Spec.new do |s|

	s.name = 'EasyNavigationBar'
	s.version = '0.9'
	s.summary = 'Make UINavigationBar Easy to use'
	s.homepage = 'https://github.com/alflix/'
	s.license	 = { :type => "Copyright", :text => "Copyright 2019" }
	s.authors = { 'John' => 'jieyuanz24@gmail.com' }
	s.source = { :path => '/' }

	s.swift_version = "5.1"
	s.ios.deployment_target = "10.0"
	s.platform = :ios, '10.0'	
	s.source_files = "Source/**/*.swift"
	s.requires_arc = true

end
