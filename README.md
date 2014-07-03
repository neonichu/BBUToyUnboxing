Xcode 6 plugin which allows usage of custom frameworks inside [Playgrounds][4]. Currently, this only supports OS X Playgrounds.

Place your own frameworks into `$HOME/Library/Developer/Playground Frameworks` and they will be automatically picked up. You can also place them next to whatever `.playground` bundle you are opening and they will be loaded.

If you are interested in the behind the scenes stuff, check out [slides][5] of my talk at NSLondon or visit my upcoming talk at [SwiftCrunch][6].

**Note:** The plugin ships with a pre-built version of `libPlaygroundInjector.dylib` which will be placed inside the plugin bundle. If you build it yourself using the corresponding target, this version will be preferred instead of the binary version. It is just there to make the installation via [Alcatraz][7] possible.

## Installation

Either

- Clone and build the plugin yourself, it will be installed to the right location automatically by building it.

or

- Install it via [Alcatraz][7]

In any case, relaunch Xcode to load it.

Because it will modify functionality of plugins which are not initially loaded by Xcode, there is a slight delay of 5 seconds before the magic happens. If you launch Xcode with a new Playground directly, the plugin might not yet be ready.

## Help needed

Follow [@NeoNacho](https://twitter.com/NeoNacho) to help me beat [@orta](https://twitter.com/orta) in followers count.

## Thanks

Many thanks to [Sam Marshall][1] for his [initial research][2] on the topic. Also to [Daniel Haight][3] for some random ideas he gave me :).


[1]: https://github.com/samdmarshall
[2]: http://samdmarshall.com/blog/custom_frameworks_and_swift.html
[3]: https://github.com/confidenceJuice
[4]: https://developer.apple.com/library/prerelease/ios/recipes/xcode_help-source_editor/ExploringandEvaluatingSwiftCodeinaPlayground/ExploringandEvaluatingSwiftCodeinaPlayground.html
[5]: https://speakerdeck.com/neonichu/custom-playgrounds
[6]: http://swiftcrunch.com
[7]: http://alcatraz.io/
