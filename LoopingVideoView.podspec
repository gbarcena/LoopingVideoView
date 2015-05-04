Pod::Spec.new do |s|
  s.name             = "LoopingVideoView"
  s.version          = "1.0.0"
  s.summary          = "An easy way to display a looping video."
  s.homepage         = "https://github.com/gbarcena/LoopingVideoView"
  s.license          = 'MIT'
  s.author           = { "Gustavo" => "gustavo@barcena.me" }
  s.source           = { :git => "https://github.com/gbarcena/LoopingVideoView.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'LoopingVideoView/Source/*'

  s.frameworks = 'UIKit', 'AVFoundation'
end
