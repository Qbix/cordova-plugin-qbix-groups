Pod::Spec.new do |spec|
  spec.name         = 'cordova-plugin-qbix-groups'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/Qbix/cordova-plugin-qbix-groups.git'
  spec.authors      = { 'Igor Martsekha' => 'igor@qbix.com' }
  spec.summary      = 'Cordova base plugin for Q plugin'
  spec.source       = { :git => 'https://github.com/Qbix/cordova-plugin-qbix-groups.git', :tag => spec.version }
  spec.source_files = 'src/ios/*.{h,m}'
  spec.preserve_paths = 'www/*.js'
end