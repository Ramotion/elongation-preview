Pod::Spec.new do |s|
  s.name         = 'ElongationPreview'
  s.version      = '2.0.0'
  s.summary      = 'ElongationPreview is an elegant push-pop style view controller.'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/Ramotion/elongation-preview'
  s.author       = { 'Abdurahim Jauzee' => 'jauzee@ramotion.com' }
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/Ramotion/elongation-preview.git', :tag => s.version.to_s }
  s.source_files  = 'ElongationPreview/Source/**/*.swift'
end
