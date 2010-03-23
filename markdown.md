---
title: The Markdown SBT Plugin
layout: withTOC
author: Brian M. Clapper
email: bmc@clapper.org
---

## Introduction

The [Markdown plugin][] supplies methods to translate [Markdown][]
documents into HTML. The plugin uses the [Showdown][] Javascript Markdown
parser and the Mozilla [Rhino][] Javascript engine to convert Markdown into
HTML. For details on the approach, see the related
[Parsing Markdown in Scala][] blog entry.

[Markdown plugin]: markdown.html
[Markdown]: http://daringfireball.net/projects/markdown/
[Showdown]: http://attacklab.net/showdown/
[Rhino]: http://www.mozilla.org/rhino/
[Parsing Markdown in Scala]: http://brizzled.clapper.org/id/98

## Getting this Plugin

### The Released Version

In your own project, create a `project/plugins/Plugins.scala` file (if you
haven't already), and add the following lines, to make the project available
to your SBT project:

    val orgClapperMavenRepo = "clapper.org Maven Repo" at "http://maven.clapper.org/"

    val markdown = "org.clapper" % "sbt-markdown-plugin" % "0.2"

Replace the version number with the most recent version number of the
published plugin.

### The Development Version

You can also use the development version of this plugin (that is, the
version checked into the [GitHub repository][github-repo]), by building it
locally.

First, download the plugin's source code by cloning this repository.

    git clone http://github.com/bmc/sbt-plugins.git

Then, within the `markdown` project directory, publish it locally:

    sbt update publish-local

[github-repo]: http://github.com/bmc/sbt-plugins

## Using the Plugin

Regardless of how you get the plugin, here's how to use it in your SBT
project.

Create a project build file in `project/build/`, if you haven't already.
Then, ensure that the project mixes in `MarkdownPlugin`. Doing so
automatically hooks the plugin's `update` and `clean-lib` actions into your
project; it also makes the plugin's `markdown()` method available to your
project.

Here's an example:

    import sbt_
    import org.clapper.sbtplugins.MarkdownPlugin

    class MyProject(info: ProjectInfo) extends DefaultProject with MarkdownPlugin
    {
        override def cleanLibAction = super.cleanAction dependsOn(markdownCleanLibAction)
        override def updateAction = super.updateAction dependsOn(markdownUpdateAction)

        // An "htmlDocs" action that creates an HTML file from a Markdown source.
        val usersGuideMD = "src" / "docs" / "guide.md"
        val usersGuideHTML = "target" / "doc" / "guide.html"
        lazy val htmlDocs = fileTask(usersGuideMD from usersGuideHTML)
        {
            markdown(usersGuideMD, usersGuideHTML, log)
        }
    }

## Copyrights

* The Markdown SBT plugin is copyright &copy; 2010 Brian M. Clapper.
* SBT is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.  

## License

This plugin is released under a [BSD license][license].

[license]: license.html


