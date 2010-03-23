---
title: SBT Plugins
layout: default
---

## Introduction

This repository contains various plugins for the [SBT][] build tool. Each
subdirectory within the repository is its own SBT project. See the `README.md`
file in each plugin's directory for details on the plugin.

[SBT]: http://code.google.com/p/simple-build-tool/

## The Plugins

This repository currently contains the following [SBT][] plugins.

### EditSource

The [EditSource plugin][] provides methods that offer a similar
substitution facility to the one available with an [Ant][] `filterset`.
That is, it edits a source (a file, a string--anything that can be wrapped
in a Scala `Source` object), substituting variable references. Variable
references look like _@var@_. A map supplies values for the variables. Any
variable that isn't found in the map is silently ignored.

Consult the [README][editsource-readme] for complete details.

[Ant]: http://ant.apache.org/
[EditSource plugin]: http://github.com/bmc/sbt-plugins/tree/master/editsource/
[editsource-readme]: http://github.com/bmc/sbt-plugins/tree/master/editsource/README.md

### IzPack

The [IzPack plugin][] provides a method that will run the [IzPack][]
compiler, generating an installer jar for your application.

Consult the [IzPack][] web site and the [IzPack plugin] page for
for complete details.

[IzPack Plugin]: izpack.html
[izpack-readme]: http://github.com/bmc/sbt-plugins/tree/master/IzPack/README.md
[IzPack]: http://izpack.org/

### Markdown

The [Markdown plugin][] supplies methods to translate [Markdown][]
documents into HTML. The plugin uses the [Showdown][] Javascript Markdown
parser and the Mozilla [Rhino][] Javascript engine to convert Markdown into
HTML. For details on the approach, see the related
[Parsing Markdown in Scala][] blog entry.

Consult the the plugin's [README][md-readme] for complete details.

[Markdown Plugin]: http://github.com/bmc/sbt-plugins/tree/master/markdown/
[md-readme]: http://github.com/bmc/sbt-plugins/tree/master/markdown/README.md
[Markdown]: http://daringfireball.net/projects/markdown/
[Showdown]: http://attacklab.net/showdown/
[Rhino]: http://www.mozilla.org/rhino/
[Parsing Markdown in Scala]: http://brizzled.clapper.org/id/98


## Copyrights

These plugins are copyright &copy; 2010 Brian M. Clapper.

[SBT][] is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.

## License

This plugin is released under a [BSD license][].

[BSD license]: license.html


