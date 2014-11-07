Pod::Spec.new do |s|
  s.name             = "BKDeltaCalculator"
  s.version          = "0.0.1"
  s.summary          = "Lightweight Objective-C library to transform a pair of collections into sets of changes"
  s.description      = "Lightweight Objective-C library to transform a pair of collections into sets of changes, primarily for use in dynamically-updated table and collection views"
  s.homepage         = "https://github.com/Basket/BKDeltaCalculator"
  s.license          = 'MIT'
  s.author           = { "Andrew Toulouse" => "andrew@atoulou.se" }
  s.source           = { :git => "https://github.com/Basket/BKDeltaCalculator.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'BKDeltaCalculator/*.{h,m}'
  s.public_header_files = 'BKDeltaCalculator/BKDelta.h',
                          'BKDeltaCalculator/BKDeltaCalculator.h'
  s.frameworks = 'Foundation'
end
