Pod::Spec.new do |s|
  s.name         = "SwiftyHex"
  s.version      = "1.0.0"
  s.summary      = "hex encoder and decoder"
  s.homepage     = "https://github.com/drichardson/SwiftyHex"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Doug Richardson" => "dougie.richardson@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/drichardson/SwiftyHex.git", :tag => "1.0.0" }
  s.source_files = "SwiftyHex"
end
