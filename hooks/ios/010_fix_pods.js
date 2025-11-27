#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

module.exports = function (context) {
    const iosPlatform = path.join(context.opts.projectRoot, 'platforms/ios');
    const podfile = path.join(iosPlatform, 'Podfile');

    if (!fs.existsSync(podfile)) return;

    let content = fs.readFileSync(podfile, 'utf8');

    // Force platform iOS 12
    content = content.replace(/platform :ios, ['"][0-9.]+['"]/, "platform :ios, '12.0'");

    // Ensure Swift 5
    if (!content.includes("SWIFT_VERSION"))
        content += `
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
`;

    fs.writeFileSync(podfile, content, 'utf8');
    console.log('[HOOK] iOS Podfile patched for iOS 12 & Swift 5');
};
