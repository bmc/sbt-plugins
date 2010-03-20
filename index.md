---
title: SBT Plugins
layout: default
---

## Introduction

This repository contains various plugins for the [SBT][sbt] build tool. Each
subdirectory within the repository is its own SBT project. See the `README.md`
file in each plugin's directory for details on the plugin.

[sbt]: http://code.google.com/p/simple-build-tool/

## The Plugins

This repository currently contains the following [SBT][sbt] plugins.

### EditSource

The [EditSource plugin][editsource] provides methods that offer a similar
substitution facility to the one available with an [Ant's][ant]
`filterset`. That is, it edits a source (a file, a string--anything that
can be wrapped in a Scala `Source` object), substituting variable
references. Variable references look like _@var@_. A map supplies values
for the variables. Any variable that isn't found in the map is silently
ignored.

Consult the [README][editsource-readme] for complete details.

[ant]: http://ant.apache.org/
[editsource]: http://github.com/bmc/sbt-plugins/tree/master/editsource/
[editsource-readme]: http://github.com/bmc/sbt-plugins/tree/master/editsource/README.md

### IzPack

The [IzPack plugin][izpack-plugin] provides a method that will run the
[IzPack][izpack] compiler, generating an installer jar for your application.

Consult the [IzPack][izpack] web site and the plugin's [README][izpack-readme] 
for complete details.

[izpack-plugin]: izpack.html
[izpack-readme]: http://github.com/bmc/sbt-plugins/tree/master/IzPack/README.md
[izpack]: http://izpack.org/

### Markdown

The [Markdown plugin][md-plugin] supplies methods to translate
[Markdown][markdown] documents into HTML. The plugin uses the
[Showdown][showdown] Javascript Markdown parser and the Mozilla
[Rhino][rhino] Javascript engine to convert Markdown into HTML. For details
on the approach, see the related [Parsing Markdown in Scala][markdown-blog]
blog entry.

Consult the the plugin's [README][md-readme] for complete details.

[md-plugin]: http://github.com/bmc/sbt-plugins/tree/master/markdown/
[md-readme]: http://github.com/bmc/sbt-plugins/tree/master/markdown/README.md
[markdown]: http://daringfireball.net/projects/markdown/
[showdown]: http://attacklab.net/showdown/
[rhino]: http://www.mozilla.org/rhino/
[markdown-blog]: http://brizzled.clapper.org/id/98


## Copyrights

These plugins are copyright &copy; 2010 Brian M. Clapper.

[SBT][sbt] is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.

## License

This plugin is released under a [BSD license][license].

[license]: license.html


