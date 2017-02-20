Pod::Spec.new do |s|
  s.name         = 'ElongationPreview'
  s.version      = '1.0.0'
  s.summary      = 'This control allow you to have `expandable` tableView with smooth transition to `detail` screen.'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/Ramotion/elongation-preview'
  s.author       = { 'Abdurahim Jauzee' => 'jauzee@ramotion.com' }
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/Ramotion/elongation-preview.git', :tag => s.version.to_s }
  s.source_files  = 'ElongationPreview/Source/**/*.swift'
end