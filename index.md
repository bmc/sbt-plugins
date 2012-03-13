---
title: SBT Plugins
layout: default
---

## Introduction

This repository contains various plugins for the 0.7 version of the [SBT][] build tool. Each
subdirectory within the repository is its own SBT project. See the `README.md`
file in each plugin's directory for details on the plugin. Some, but not all,
of the plugins have their own pages here.

<p style="color: red; font-weight: bold">NOTE: These plugins are no longer maintained. Please see <a href="http://software.clapper.org/sbt-editsource">sbt-editsource</a>,  <a href="http://software.clapper.org/sbt-izpack">sbt-izpack</a>, and <a href="http://software.clapper.org/sbt-lwm">sbt-lwm</a>, instead.</p>

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

Consult the [EditSource plugin][] page for complete details.

[Ant]: http://ant.apache.org/
[EditSource plugin]: editsource.html

### IzPack

The [IzPack plugin][] provides a method that will run the [IzPack][]
compiler, generating an installer jar for your application.

Consult the [IzPack][] web site and the [IzPack plugin][] page for
for complete details.

[IzPack Plugin]: izpack.html
[IzPack]: http://izpack.org/

### Markdown

The [Markdown plugin][] supplies methods to translate [Markdown][]
documents into HTML. The plugin uses the [Showdown][] Javascript Markdown
parser and the Mozilla [Rhino][] Javascript engine to convert Markdown into
HTML. For details on the approach, see the related
[Parsing Markdown in Scala][] blog entry.

Consult the [Markdown plugin][] page for complete details.

[Markdown plugin]: markdown.html
[Markdown]: http://daringfireball.net/projects/markdown/
[Showdown]: http://attacklab.net/showdown/
[Rhino]: http://www.mozilla.org/rhino/
[Parsing Markdown in Scala]: http://brizzled.clapper.org/id/98

## Copyrights

* These plugins are copyright &copy; 2010-2011 Brian M. Clapper.
* [SBT][] is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.

## License

This plugin is released under a [BSD license][].

## Patches

I gladly accept patches from their original authors. Feel free to email
patches to me or to fork the [GitHub repository][] and send me a pull
request. Along with any patch you send:

* Please state that the patch is your original work.
* Please indicate that you license the work to the *clapper.org SBT
  Plugins* project under a [BSD License][].

[GitHub repository]: http://github.com/bmc/sbt-plugins
[BSD license]: license.html


