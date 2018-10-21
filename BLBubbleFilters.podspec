Pod::Spec.new do |s|

  s.name                = "BLBubbleFilters"
  s.version             = "1.0.1"
  s.summary             = "BLBubbleFilters gives you bubble filters à la Apple Music."
  s.screenshots         = ["https://github.com/BellAppLab/BLBubbleFilters/raw/master/Images/bubble_filters.png",
                           "https://github.com/BellAppLab/BLBubbleFilters/raw/master/Images/bubble_filters.gif"]

  s.description         = <<-DESC
BLBubbleFilters gives you bubble filters à la Apple Music.

Inspired by: [SIFloatingCollection_Swift](https://github.com/ProudOfZiggy/SIFloatingCollection_Swift).
                   DESC

  s.homepage            = "https://github.com/BellAppLab/BLBubbleFilters"

  s.license             = { :type => "MIT", :file => "LICENSE" }

  s.author              = { "Bell App Lab" => "apps@bellapplab.com" }
  s.social_media_url    = "https://twitter.com/BellAppLab"

  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"

  s.module_name         = 'BLBubbleFilters'
  s.header_dir          = 'Headers'

  s.source              = { :git => "https://github.com/BellAppLab/BLBubbleFilters.git", :tag => "#{s.version}" }

  s.source_files        = "BLBubbleFilters", "Headers"

  s.framework           = "SpriteKit"

  s.ios.framework       = "UIKit"
  s.tvos.framework      = "UIKit"

end
