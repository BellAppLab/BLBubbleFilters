Pod::Spec.new do |s|
  s.name             = 'BLBubbleFilters'
  s.version          = '0.1.0'
  s.summary          = 'Apple Music style bubble filters.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

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

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'SpriteKit'
end
