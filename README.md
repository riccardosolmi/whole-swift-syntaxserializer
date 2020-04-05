# SwiftSyntaxSerializer

![CI][ci badge]

`SwiftSyntaxSerializer` is a command line tool that lets you parse Swift code into a [JSON-LD][jsonld] serialization format and vice versa.

This tool is part of the [Whole Platform][wholeplatform]; the installation of this tool is necessary in order to enable the native Swift persistence of the Swift and SwiftSyntax languages.

`SwiftSyntaxSerializer` depends on [SwiftSyntax][swiftsyntax] for parsing and unparsing the Swift code and on [SwiftFormat][swiftformat] for formatting the Whole generated code.

## Requirements

The version of the standalone parsing library that is distributed as part of the Swift toolchain must match the one expected by [SwiftSyntax][swiftsyntax]. So you should check out and build `SwiftSyntaxSerializer` from the branch that is compatible with the version of Swift you are using. As an alternative you can install and switch to a compatible Swift toolchain.

The last supported version of Swift is: 5.1. Check from the command line the version of Swift you are using.

```sh
$ swift --version
Apple Swift version 5.1.3 (swiftlang-1100.0.282.1 clang-1100.0.33.15)
```

## Installation

Clone the repository and build the executable with the [Swift Package Manager][packagemanager] included with Swift.

```
git clone https://github.com/riccardosolmi/whole-swift-syntaxserializer.git
cd whole-swift-syntaxserializer
swift build -c release
cp .build/release/SwiftSyntaxSerializer /usr/local/bin
```

## License

The Whole Platform is Copyright 2004-2020 Riccardo Solmi. All rights reserved.

The Whole Platform is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Whole Platform is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.
See the [GNU Lesser General Public License](http://www.gnu.org/licenses/lgpl.txt) for more details.


[ci badge]: https://github.com/riccardosolmi/whole-swift-syntaxserializer/workflows/CI/badge.svg
[wholeplatform]: https://github.com/wholeplatform/whole
[swiftsyntax]: https://github.com/apple/swift-syntax
[swiftformat]: https://github.com/apple/swift-format
[jsonld]: https://json-ld.org
[packagemanager]: https://swift.org/package-manager/
