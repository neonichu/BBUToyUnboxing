Xcode 6 plugin which allows usage of custom frameworks inside [Playgrounds][4].

Place your own frameworks into `$HOME/Library/Developer/Playground Frameworks` and they will be automatically picked up. Currently, this only supports OS X Playgrounds.

If you are interested in the behind the scenes stuff, check out [slides][5] of my talk at NSLondon or visit my upcoming talk at [SwiftCrunch][6].

## Installation

Either

- Clone and build the plugin yourself, it will be installed to the right location automatically by building it.

or

- Install it via [Alcatraz](http://alcatraz.io/)

In any case, relaunch Xcode to load it.

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
