---
title: SBT Plugins Change Log
layout: default
---

Version 0.3:

* Now published to the [Scala Tools Maven repository][], which [SBT][]
  includes by default. Thus, if you're using SBT, it's longer necessary to
  specify a custom repository to find this artifact.

[Scala Tools Maven repository]: http://www.scala-tools.org/repo-releases/
[SBT]: http://code.google.com/p/simple-build-tool/

Version 0.2.2:

* Now uses [Posterous-SBT][] SBT plugin.

[Posterous-SBT]: http://github.com/n8han/posterous-sbt

Version 0.2.1:

* Changed [Markdown plugin][] to permit insertion of an arbitrary list of
  HTML nodes in the generated HTML `head` section.
* Internal changes to the [IzPack plugin][] to use `map()` calls instead of
  `for` and `yield`.

[IzPack plugin]: http://software.clapper.org/sbt-plugins/izpack.html
[Markdown plugin]: http://software.clapper.org/sbt-plugins/markdown.html

Version 0.2:

* The [IzPack plugin][] now provides support for configuring the installer
  directly within SBT, using Scala, rather than XML.
* Web pages now exist for each plugin, including a comprehensive one
  for the IzPack plugin.

[IzPack plugin]: http://software.clapper.org/sbt-plugins/izpack.html

Version 0.1:

First release to the web.
