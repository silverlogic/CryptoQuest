# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CryptoQuest' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CryptoQuest
  pod 'GoogleMaps'
  pod 'LTMorphingLabel', '~> 0.5.3'
  pod 'QRCodeReader.swift'
  pod 'SSBouncyButton', '~> 1.0'
  pod 'Starscream'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              if target.name == 'Starscream' ||
                  target.name == 'LTMorphingLabel' ||
                  target.name == 'QRCodeReader.swift'
                  config.build_settings['SWIFT_VERSION'] = '4.0'
              else
                  config.build_settings['SWIFT_VERSION'] = '3.2'
              end
          end
      end
  end

end
