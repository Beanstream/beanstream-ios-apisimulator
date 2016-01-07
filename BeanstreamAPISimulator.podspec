Pod::Spec.new do |s|

  s.name     = 'BeanstreamAPISimulator'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'A delightful iOS simulator framework to be helpful with Beanstream.SDK related development.'
  s.homepage = 'http://developer.beanstream.com'
  s.authors  = 'Sven M. Resch', 'David Light'
  s.source   = { :git => 'https://stash.beanstream.com/scm/ios/beanstreamios.sdk.apisimulator.git', :submodules => true }
  s.requires_arc = true
  
  s.public_header_files = 'APISimulator/*.h'
  s.source_files = 'APISimulator/*.{h,m}'
  
  s.ios.deployment_target = '8.0'
  
  s.subspec 'Simulators' do |ss|
    ss.source_files = 'APISimulator/Simulators/*.{h,m}'
    ss.public_header_files = 'APISimulator/Simulators/*.h'
    ss.dependency 'BeanstreamAPISimulator/Utils'
  end

  s.subspec 'Utils' do |ss|
    ss.source_files = 'APISimulator/Utils/*.{h,m}'
    ss.public_header_files = 'APISimulator/Utils/*.h'
  end

  
  s.dependency "AFNetworking", "= 2.6.0"
  s.dependency 'Beanstream.SDK', :podspec => 'http://localhost/Beanstream.SDK.podspec'
  s.libraries = 'z', 'c++', 'iSMP', 'Beanstream.SDK'

  s.xcconfig  = { "LIBRARY_SEARCH_PATHS" => "$(PODS_ROOT)/Beanstream.SDK/Beanstream.SDK" }

end