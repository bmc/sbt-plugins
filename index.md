---
title: SBT Plugins
layout: default
---

## Introduction

This repository contains various plugins for the [SBT][sbt] build tool. Each
subdirectory within the repository is its own SBT project. See the `README.md`
file in subdirectory for details on its plugin.

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

[izpack-plugin]: http://github.com/bmc/sbt-plugins/tree/master/IzPack/
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

License
-------

This plugin is released under a BSD license, adapted from
<http://opensource.org/licenses/bsd-license.php>

Copyright &copy; 2010, Brian M. Clapper
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

* Neither the names "clapper.org" nor the names of its contributors may be
  used to endorse or promote products derived from this software without
  specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyrights
----------

These plugins are copyright &copy; 2010 Brian M. Clapper.

[SBT][sbt] is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.
