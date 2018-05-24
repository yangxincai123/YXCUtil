Pod::Spec.new do |s|

  s.name         = "YXCUtil"
  s.version      = "0.0.1"
  s.summary      = "A short description of YXCUtil."
  s.description  = "A short description of YXCUtil ss"
  s.homepage     = "https://github.com/yangxincai123/YXCUtil"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "杨新财" => "550480414@qq.com" }
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/yangxincai123/YXCUtil.git", :tag => "#{s.version}" }
  s.source_files  = "Classes/**/*.{swift,xib}"

  s.frameworks = 'UIKit', 'Photo', 'Foundation'

  s.requires_arc = true

  s.subspec "Core" do |ss|
    ss.dependency 'SnapKit', '~> 4.0.0'
    ss.dependency 'KeychainAccess', '~> 3.1.0'
    ss.framework  = "Foundation"
  end

  
end
