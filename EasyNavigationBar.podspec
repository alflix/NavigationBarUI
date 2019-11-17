Pod::Spec.new do |s|
  s.name                  = 'EasyNavigationBar'
  s.version               = '1.0.0'
  s.summary               = 'more powerful and elegant to use UINavigationController and UINavigationBar'

  s.homepage              = 'https://github.com/alflix/EasyNavigationBar'
  s.license               = { :type => 'Apache-2.0', :file => 'LICENSE' }

  s.author                = { 'John' => 'jieyuanz24@gmail.com' }
  s.social_media_url      = 'https://github.com/alflix'

  s.platform              = :ios
  s.ios.deployment_target = '8.0'

  s.source                = { :git => 'https://github.com/alflix/EasyNavigationBar.git', :tag => "#{s.version}" }
  s.ios.framework         = 'UIKit'
  s.source_files          = 'Source/*.swift'

  s.module_name           = 'EasyNavigationBar'
  s.requires_arc          = true

  s.swift_version         = '5.1'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.1' }
  s.static_framework      = true
  
end

