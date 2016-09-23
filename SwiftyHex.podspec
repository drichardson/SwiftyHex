Pod::Spec.new do |s|
  s.name         = "SwiftyHex"
  s.version      = "1.2.0"
  s.summary      = "hex encoder and decoder"
  s.homepage     = "https://github.com/drichardson/SwiftyHex"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Doug Richardson" => "dougie.richardson@gmail.com" }
  s.source       = { :git => "https://github.com/drichardson/SwiftyHex.git", :tag => s.version }
  s.source_files = "SwiftyHex"

  s.platform     = :ios, "8.0"
end
