#
# Add repo:
# pod repo-art add beanstream-partner "https://beanstream.jfrog.io/beanstream/api/pods/beanstream-partner"
#

Pod::Spec.new do |spec|

  spec.name     = 'BeanstreamAPISimulator'
  spec.version  = '1.2.1'
  spec.license  = 'MIT'
  spec.summary  = 'A delightful iOS simulator framework to be helpful with Beanstream.SDK related development.'
  spec.homepage = 'http://developer.beanstream.com'
  spec.authors  = 'Sven M. Resch', 'David Light'
  spec.source   = { :http => 'https://beanstream.jfrog.io/beanstream/beanstream-partner/' + spec.name.to_s + '-' + spec.version.to_s + '.tar.gz' }
  spec.requires_arc = true
  spec.public_header_files = 'APISimulator/*.h'
  spec.source_files = 'APISimulator/*.{h,m}'
  spec.ios.deployment_target = '8.3'

  spec.subspec 'Simulators' do |ss|
    ss.source_files = 'APISimulator/Simulators/*.{h,m}'
    ss.public_header_files = 'APISimulator/Simulators/*.h'
    ss.dependency 'BeanstreamAPISimulator/Utils'
  end

  spec.subspec 'Utils' do |su|
    su.source_files = 'APISimulator/Utils/*.{h,m}'
    su.public_header_files = 'APISimulator/Utils/*.h'
  end

  spec.dependency "AFNetworking", "= 2.6.0"
  spec.dependency 'Beanstream.SDK', "= 2.3.0"
  spec.libraries = 'z', 'c++', 'Beanstream.SDK'
  spec.framework = 'ExternalAccessory'

  spec.xcconfig  = { "LIBRARY_SEARCH_PATHS" => "$(PODS_ROOT)/Beanstream.SDK/Beanstream.SDK" }

end
