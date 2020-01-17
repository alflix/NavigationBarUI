Pod::Spec.new do |s|
  s.name                  = 'NavigationBarUI'
  s.version               = '0.9.1'
  s.summary               = 'More powerful and elegant to use UINavigationController and UINavigationBar'

  s.homepage              = 'https://github.com/alflix/NavigationBarUI'
  s.license               = { :type => 'Apache-2.0', :file => 'LICENSE' }

  s.author                = { 'John' => 'jieyuanz24@gmail.com' }
  s.social_media_url      = 'https://github.com/alflix'

  s.platform              = :ios
  s.ios.deployment_target = '10.0'

  s.source                = { :git => 'https://github.com/alflix/NavigationBarUI.git', :tag => "#{s.version}" }
  s.ios.framework         = 'UIKit'
  s.source_files          = 'Source/**/*.swift'

  s.module_name           = 'NavigationBarUI'
  s.requires_arc          = true

  s.swift_version         = '5.1'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.1' }
  s.static_framework      = true
  
end

