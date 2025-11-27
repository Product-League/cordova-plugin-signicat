#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

module.exports = function (context) {
    const projPath = path.join(context.opts.projectRoot,
      'platforms/ios', 'Adriano_Sandbox.xcodeproj', 'project.pbxproj');

    if (!fs.existsSync(projPath)) return;

    let text = fs.readFileSync(projPath, 'utf8');

    // Remove Cordova wrong overrides
    text = text.replace(/ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = .+?;/g,
                        'ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES;');

    text = text.replace(/LD_RUNPATH_SEARCH_PATHS = .+?;/g,
                        'LD_RUNPATH_SEARCH_PATHS = "$(inherited)";');

    fs.writeFileSync(projPath, text, 'utf8');
    console.log('[HOOK] Fixed Xcode build settings for runpath & Swift libraries');
};
