Pod::Spec.new do |s|
  s.name             = "FeedbackAPIModel"
  s.summary          = "FeedbackAPIModel"
  s.version          = "1.0"
  s.homepage         = "https://github.com/Sorix/whirr-letter-shared-model"
  s.license          = 'Custom'
  s.author           = { "Vasily Ulianov" => "vasily@me.com" }
  s.source           = {
    :git => "https://github.com/Sorix/whirr-letter-shared-model",
    :tag => s.version.to_s
  }

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.source_files = 'Sources/**/*.swift'

  s.ios.frameworks = 'Foundation'
  s.osx.frameworks = 'Foundation'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
