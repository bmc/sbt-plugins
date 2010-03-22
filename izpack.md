---
title: The IzPack SBT Plugin
layout: default
author: Brian M. Clapper
email: bmc@clapper.org
---

## Introduction

The [IzPack][izpack] SBT Plugin is a plugin for the [Scala][scala]-based
[SBT][sbt] build tool. IzPack is an open source tool that allows you to
create flexible Java-based graphical and command-line installers. This
plugin allows you to use IzPack from your SBT project, either

* via a traditional [IzPack XML installation file][izpack-install-file], or
* by building a Scala-based IzPack configuration object.

This document explains how to use the plugin.

[sbt]: http://code.google.com/p/simple-built-tool/
[izpack]: http://izpack.org/
[izpack-install-file]: http://izpack.org/documentation/installation-files.html
[scala]: http://www.scala-lang.org/

## Motivation

There are several reasons I wrote this plugin, but two reasons are paramount.

### Ease of invocation

There was no simple way to invoke the IzPack compiler from SBT. Rather than
craft a clumsy way to invoke IzPack via the command line, I wrote this
plugin so I could invoke it directly from within SBT.

### XML is a lousy configuration file format

IzPack uses a complex XML configuration file.

I dislike the whole trend of using XML as a configuration file format. Yes,
XML is ostensibly human-readable. But it isn't always human-*friendly*. I
agree with [Terence Parr][parr], author of [ANTLR][antlr] and
[StringTemplate][stringtemplate], who wrote, in 2001, that XML is a poor
human interface:

[parr]: http://www.cs.usfca.edu/~parrt/
[antlr]: http://www.antlr.org/
[stringtemplate]: http://stringtemplate.org/

> XML should be a safe bet for most of your program-to-program data format
> needs. What about programs, specifications, initialization files, and the
> like that are conversations between a human and a computer? In this
> section, I hope to convince you that humans should not have to write and
> grok XML. Besides the many existing standard special-purpose languages
> that provide superior interfaces, XML is about as far away from natural
> human language as you can get.

See [*Humans should not have to grok XML*][grok-XML].

[grok-xml]: http://www.ibm.com/developerworks/xml/library/x-sbxml.html

Build files are an especially challenging use of XML, since they often must
contain procedural build logic, conditional expressions, and the like. XML
is a very clumsy syntax for expressing that kind of logic. (Martin Fowler
makes many of these same points in his 2005 article entitled,
[*Using the Rake Build Language*][fowler-rake].)

SBT is a breath of fresh air, allowing me to create succinct build files,
while giving me full access to the power of the Scala programming language.
In every way I can imagine, SBT is [Rake][rake] for Scala.

[rake]: http://rake.rubyforge.org/
[fowler-rake]: http://martinfowler.com/articles/rake.html

To provide flexibility, the IzPack XML configuration syntax permits
variables, conditionals, and other programming language-like constructs, in
using concepts borrowed liberally from the [Ant][ant] build tool. But, as I
noted above, XML is a lousy syntax for a programming language. Wouldn't it
be nicer to be able to encode build-time programming syntax in a real
programming language?

[ant]: http://ant.apache.org/

This [SBT][sbt] plugin strives to permit just that. With this plugin, you
can use your existing IzPack XML files, if you want. But you can
also code your configuration in Scala; the plugin will translate it to the
XML necessary for IzPack. This second approach provides several benefits:

* Instead of using clumsy Ant-like XML `fileset` elements to specify
  file locations, you can use SBT's powerful built-in path and
  wildcard syntax.
* You have the full power of Scala at your command, for making build-time
  decisions.

## Getting the plugin

In your SBT project, create a `project/plugins/Plugins.scala` file, if you
haven't done so already. Then, add the following lines, to make the plugin
available to your project:

    val orgClapperRepo = "clapper.org Maven Repo" at "http://maven.clapper.org"
    val izPackPlugin = "org.clapper" % "sbt-izpack-plugin" % "0.1.2"

Replace the version number with the most recent version number of the
published plugin.

You can also use the development version of the plugin, by cloning the
[GitHub repository][github-repo] repository and running an `sbt
publish-local` on it. The following commands are Unix-specific; make
appropriate adjustments for Windows.

    $ git clone http://github.com/bmc/sbt-plugins.git
    $ cd sbt-plugins/izpack
    $ sbt update publish-local

[github-repo]: http://github.com/bmc/sbt-plugins

## Mixing it into your project

This part's easy: Just mix it in:

    import sbt._
    
    class MyProject(info: ProjectInfo)
    extends DefaultProject(info) with IzPackPlugin

At that point, your project has access to the methods provided by the plugin.

## Using an Existing IzPack Installation File

If you already have an existing, external IzPack configuration file, you're
pretty much almost done. You just have to create an SBT task to run IzPack
on your file. Here's an example:

    class MyProject(info: ProjectInfo)
    extends DefaultProject(info) with IzPackPlugin {

        lazy val installer = task {installerAction; None}
                             .dependsOn(packageAction, docAction)
                             .describedAs("Build installer.")

        private def installerAction = {
            val installFile = "src" / "main" / "izpack" / "install.xml"
            val installJar = projectName.value.toString.toLowerCase + "-" +
                             projectVersion.value.toString + "-install.jar"
            izpackMakeInstaller(installFile, installJar)
        }
    }

The `installerAction` method uses SBT's `Path` capabilities to build paths
to the installation configuration file and the target installer jar file,
and then invokes the plugin's `izpackMakeInstaller` method to make the
installer jar. The rest is just SBT task boilerplate.

## Building your configuration entirely in SBT

If you don't have an existing IzPack configuration file, you can choose to
build your configuration entire within your Scala SBT project file, using
Scala code, rather than XML.

### Features

* Build your configuration (almost) entirely in Scala.
* For those features not yet supported (such as `condition` sections),
  you can supply the raw XML yourself directly in your SBT Scala build file.
* The layout of the configuration object mirrors the layout of the
  IzPack XML file, for the most part.
* You can use the powerful SBT `Path` capability to find your files.

### Restrictions

* The `IzPackConfig` class does not support every single IzPack feature,
  though most (hopefully all) of the most common ones are supported. If there's
  an unsupported IzPack feature you need, you can supply the XML for it
  manually, within your SBT Scala build file.

### Let's start with an example

Before explaining each configuration section, let's start with a simple 
example. We'll tear into the example, section by section, further down.


    lazy val installConfig = new IzPackConfig("target" / "install", log)
    {
        val InstallSrcDir = mainSourcePath / "izpack"
        val TargetDocDir = "target" / "doc"
        val LicenseHTML = TargetDocDir / "LICENSE.html"
        val ReadmeHTML = TargetDocDir / "README.html"

        new Info
        {
            appName = projectName.value.toString
            appVersion = projectVersion.value.toString
            author("Tina Gheek", "tina@example.org")
            author("James Class", "jimclass@example.org")
            url = "http://supertool.example.org/"
            javaVersion = "1.6"
            writeInstallationInfo = true
        }

        languages = List("eng", "chn", "deu", "fra", "jpn", "spa", "rus")

        new Resources
        {
            new Resource
            {
                id = "HTMLLicencePanel.licence"
                source = LicenseHTML
            }

            new Resource
            {
                id = "HTMLInfoPanel.info"
                source = ReadmeHTML
            }

            new Resource
            {
                id = "Installer.image"
                source = InstallSrcDir / "supertool-logo.png"
            }

            new Resource
            {
                id = "XInfoPanel.info"
                source = InstallSrcDir / "final_screen.txt"
            }

            new InstallDirectory
            {
                """C:\Program Files\SuperTool""" on Windows
                "/Applications/SuperTool on MacOSX
                "/usr/local/supertool" on Unix
            }
        }
        new Packaging
        {
            packager = Packager.SingleVolume
        }

        new GuiPrefs
        {
            height = 768
            width = 1024

            new LookAndFeel("looks")
            {
                onlyFor(Windows)
                params = Map("variant" -> "extwin")
            }

            new LookAndFeel("looks")
            {
                onlyFor(Unix)
            }
        }

        new Panels
        {
            new Panel("HelloPanel")
            new Panel("HTMLInfoPanel")
            new Panel("HTMLLicencePanel")
            new Panel("TargetPanel")
            new Panel("PacksPanel")
            new Panel("InstallPanel")
            new Panel("XInfoPanel")
            new Panel("FinishPanel")
        }

        new Packs
        {
            new Pack("Core")
            {
                required = true
                preselected = true
                description = "The SuperTool jar file, binaries, and " +
                              "dependent jars"

                new SingleFile(LicenseHTML, "$INSTALL_PATH/LICENSE.html")
                new SingleFile(ReadmeHTML, "$INSTALL_PATH/README.html")

                new SingleFile(InstallSrcDir / "supertool.sh",
                               "$INSTALL_PATH/bin/supertool")
                {
                    onlyFor(Unix, MacOSX)
                }

                new Parsable("$INSTALL_PATH/bin/supertool")
                {
                    onlyFor(Unix, MacOSX)
                }

                new Executable("$INSTALL_PATH/bin/supertool")
                {
                    onlyFor(Unix, MacOSX)
                }

                new SingleFile(InstallSrcDir / "supertool.bat",
                               "$INSTALL_PATH/bin/supertool.bat")
                {
                    onlyFor(Windows)
                }

                new Parsable("$INSTALL_PATH/bin/supertool.bat")
                {
                    onlyFor(Windows)
                }

                new Executable("$INSTALL_PATH/bin/supertool.bat")
                {
                    onlyFor(Windows)
                }

                new SingleFile(InstallSrcDir / "sample.cfg",
                               "$INSTALL_PATH/sample.cfg")

                new SingleFile(jarPath, "$INSTALL_PATH/lib/supertool.jar")

                // Get the list of jar files to include, besides the
                // project's jar. Note to self: "**" means "recursive drill
                // down". "*" means "immediate descendent".

                val projectBootDir = "project" / "boot" / scalaVersionDir
                val jars = 
                    (("lib" +++ "lib_managed") **
                     ("*.jar" - "izpack*.jar"
                              - "scalatest*.jar"
                              - "scala-library*.jar"
                              - "scala-compiler.jar")) +++
                     (projectBootDir ** "scala-library.jar")

                new FileSet(jars, "$INSTALL_PATH/lib")
            }

            new Pack("Documentation")
            {
                required = false
                preselected = true
                description = "The SuperTool User's Guide and other docs"

                new FileSet((TargetDocDir * "*.html") +++
                            (TargetDocDir * "*.js") +++
                            (TargetDocDir * "*.md") +++
                            (TargetDocDir * "*.css") +++
                            (TargetDocDir * "FAQ"),
                            "$INSTALL_PATH/docs")
                new File(path("CHANGELOG"), "$INSTALL_PATH/docs")
            }
        }
    }

## The Main Section

_TBD_

## The Info Section

_TBD_

## Language Packs

_TBD_

## The Resources Section

_TBD_

## The GuiPrefs section

_TBD_

## The Panels section

_TBD_

## The Packs section

_TBD_

## Copyrights

These plugins are copyright &copy; 2010 Brian M. Clapper.

SBT is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.
IzPack is copyright &copy; 2001-2006 Julien Ponge.

## License

This plugin is released under a [BSD license][license].

[license]: license.html


