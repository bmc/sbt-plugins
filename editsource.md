---
title: The EditSource SBT Plugin
layout: withTOC
author: Brian M. Clapper
email: bmc@clapper.org
---

## Introduction

The [EditSource plugin][] provides methods that offer a similar
substitution facility to the one available with an [Ant][] `filterset`.
That is, it edits a source (a file, a string--anything that can be wrapped
in a Scala `Source` object), substituting variable references. Variable
references look like _@var@_. A map supplies values for the variables. Any
variable that isn't found in the map is silently ignored.

[Ant]: http://ant.apache.org/
[EditSource plugin]: http://github.com/bmc/sbt-plugins/tree/master/editsource/

## Getting this Plugin

### The Released Version

In your own project, create a `project/plugins/Plugins.scala` file (if you
haven't already), and add the following lines, to make the project available
to your SBT project:

    val orgClapperMavenRepo = "clapper.org Maven Repo" at "http://maven.clapper.org/"

    val editsource = "org.clapper" % "sbt-editsource-plugin" % "0.2"

Replace the version number with the most recent version number of the
published plugin.

### The Development Version

You can also use the development version of the plugin, by cloning the
[GitHub repository][] repository and running an `sbt publish-local` on it.
The following commands are Unix-specific; make appropriate adjustments for
Windows.

    $ git clone http://github.com/bmc/sbt-plugins.git
    $ cd sbt-plugins
    $ sbt update publish-local

    sbt update publish-local

[GitHub repository]: http://github.com/bmc/sbt-plugins

## Using the Plugin

Regardless of how you get the plugin, here's how to use it in your SBT
project.

Create a project build file in `project/build/`, if you haven't already.
Then, ensure that the project mixes in `MarkdownPlugin`. You have to ensure
that you hook in the Markdown plugin's `update` and `clean-lib` logic, as
shown below. Once you've done that, you can use the plugin's
`editSourceToFile()` and `editSourceToList()` methods.

### Example

This example assumes you have a file called `install.properties` that is
used to configure some (fictitious) installer program; you want to
substitute some values within that file, based on settings in your build
file. The file might look something like this:

    main.jar: @JAR_FILE@
    docs.directory: @DOCS_DIR@
    package.name: @PACKAGE_NAME@
    package.version: @PACKAGE_VERSION@


The EditSource plugin can be used to edit the _@VAR@_ references within the
file, as shown here.

    import sbt_
    import org.clapper.sbtplugins.EditFilePlugin

    class MyProject(info: ProjectInfo) extends DefaultProject with EditSourcePlugin
    {
        val installCfgSource = "src" / "installer" / "install.properties"
        val vars = Map(
            "JAR_FILE" -> jarPath.absolutePath,
            "DOCS_DIR" -> ("src" / "docs").absolutePath,
            "PACKAGE_NAME" -> "My Project",
            "PACKAGE_VERSION" -> projectVersion.value.toString
        ) 

        import java.io.File
        val temp = File.createTempFile("inst", "properties")
        temp.deleteOnExit
        editSourceToFile(Source.fromFile(installCfgSource.absolutePath, temp)
        runInstaller(temp)
        temp.delete

        private def runInstaller(configFile: File) =
        {
            ...
        }
    }


## Copyrights

* The EditSource SBT plugin is copyright &copy; 2010 Brian M. Clapper.
* SBT is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.  

## License

This plugin is released under a [BSD license][license].

[license]: license.html

