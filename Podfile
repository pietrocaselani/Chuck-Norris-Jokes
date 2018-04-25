def shared_pods
  pod 'Alamofire', '~> 4.7'
end

def test_pods
  pod 'Mockingjay'
end

def ios_test_pods
  pod 'MockUIAlertController'
end

target 'Chuck Norris' do
  use_frameworks!
  platform :ios, '10.0'

  shared_pods

  target 'Chuck NorrisTests' do
    inherit! :search_paths
    ios_test_pods
  end

end

target 'ChuckNorrisCore' do
  use_frameworks!
  platform :osx, '10.12'

  shared_pods

  target 'ChuckNorrisCoreTests' do
    inherit! :search_paths
    test_pods
  end

end

target 'ChuckNorrisCore-iOS' do
  use_frameworks!
  platform :ios, '10.0'

  shared_pods

end

target 'ChuckNorrisPlaygroundFramework' do
  use_frameworks!
  platform :ios, '10.0'

  shared_pods
end
