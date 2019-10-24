
Pod::Spec.new do |s|
  s.name         = "RNBaiduTrace"
  s.version      = "1.0.1"
  s.summary      = "RNBaiduTrace"
  s.description  = <<-DESC
                  RNBaiduTrace
                   DESC
  s.homepage     = "https://github.com/ltovem/react-native-baiduTrace"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "dev.ltove.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/ltovem/react-native-baiduTrace.git", :tag => "master" }
  s.source_files  = "ios/RNBaiduTraceModule/*.{h,m}"

  s.preserve_paths  = "*.js"
  s.vendored_libraries = "ios/RNBaiduTraceModule/*.a"
  s.vendored_frameworks = "ios/RNBaiduTraceModule/*.framework"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

