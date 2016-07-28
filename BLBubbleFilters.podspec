Pod::Spec.new do |s|
  s.name             = 'BLBubbleFilters'
  s.version          = '0.2.1'
  s.summary          = 'Apple Music style bubble filters.'

  s.description      = <<-DESC
Apple Music style bubble filters. Inspired by: https://github.com/ProudOfZiggy/SIFloatingCollection_Swift
                       DESC

  s.homepage         = 'https://github.com/BellAppLab/BLBubbleFilters'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bell App Lab' => 'apps@bellapplab.com' }
  s.source           = { :git => 'https://github.com/BellAppLab/BLBubbleFilters.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BellAppLab'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BLBubbleFilters/Classes/**/*'

  # s.public_header_files = 'BLBubbleFilters/Classes/**/*.h'
  s.frameworks = 'UIKit', 'SpriteKit'
end
