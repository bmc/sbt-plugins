---
title: The IzPack SBT Plugin
layout: withTOC
author: Brian M. Clapper
email: bmc@clapper.org
---

## Introduction

The [IzPack][] SBT Plugin is a plugin for the [Scala][]-based [SBT][] build
tool. IzPack is an open source tool that allows you to create flexible
Java-based graphical and command-line installers. This plugin allows you to
use IzPack from your SBT project, using one of the following methods:

* via a traditional XML [IzPack installation file][]
* by building a Scala-based IzPack configuration object.

This document explains how to use the plugin.

[SBT]: http://code.google.com/p/simple-build-tool/
[Izpack]: http://izpack.org/
[IzPack installation file]: http://izpack.org/documentation/installation-files.html
[Scala]: http://www.scala-lang.org/

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
agree with [Terence Parr][], author of [ANTLR][] and [StringTemplate][],
who wrote, in 2001, that XML is a poor human interface:

[Terence Parr]: http://www.cs.usfca.edu/~parrt/
[ANTLR]: http://www.antlr.org/
[StringTemplate]: http://stringtemplate.org/

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
In every way I can imagine, SBT is [Rake][] for Scala.

[Rake]: http://rake.rubyforge.org/
[fowler-rake]: http://martinfowler.com/articles/rake.html

To provide flexibility, the IzPack XML configuration syntax permits
variables, conditionals, and other programming language-like constructs, in
using concepts borrowed liberally from the [Ant][] build tool. But, as I
noted above, XML is a lousy syntax for a programming language. Wouldn't it
be nicer to be able to encode build-time programming syntax in a real
programming language?

[Ant]: http://ant.apache.org/

This [SBT][] plugin strives to permit just that. With this plugin, you can
use your existing IzPack XML files, if you want. But you can also code your
configuration in Scala; the plugin will translate it to the XML necessary
for IzPack. This second approach provides several benefits:

* Instead of using clumsy Ant-like XML `fileset` elements to specify
  file locations, you can use SBT's powerful built-in path and
  wildcard syntax.
* You have the full power of Scala at your command, for making build-time
  decisions.

## Getting the plugin

In your SBT project, create a `project/plugins/Plugins.scala` file, if you
haven't done so already. Then, add the following lines, to make the plugin
available to your project:

    val izPackPlugin = "org.clapper" % "sbt-izpack-plugin" % "0.3.1"

Replace the version number with the most recent version number of the
published plugin.

**NOTE**

* Prior to 0.3, you also had to specify the location of the *clapper.org*
  Maven repository. With version 0.3, however, the plug-in is now being
  published to the [Scala Tools Maven repository][], which SBT
  automatically searches.

You can also use the development version of the plugin, by cloning the
[GitHub repository][] repository and running an `sbt publish-local` on it.
The following commands are Unix-specific; make appropriate adjustments for
Windows.

    $ git clone http://github.com/bmc/sbt-plugins.git
    $ cd sbt-plugins
    $ sbt update publish-local

## Mixing it into your project

This part's easy: Just mix it in:

    import sbt._
    import org.clapper.sbtplugins.IzPackPlugin

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
* The configuration class uses terminology and names that are deliberately
  similar to the XML elements and attributes in the IzPack XML configuration
  file, which means you can often use the official IzPack documentation for
  clarification.

### Restrictions

* The `IzPackConfig` class does not support every single IzPack feature,
  though most (hopefully all) of the most common ones are supported. If there's
  an unsupported IzPack feature you need, you can supply the XML for it
  manually, within your SBT Scala build file.

### Let's start with an example

Before explaining each configuration section, let's start with a simple 
example. We'll tear into the example, section by section, further down.
You can also [download an example][] from the GitHub repository.

[download an example]: http://github.com/bmc/sbt-plugins/blob/master/IzPack/src/testproj/project/build/Project.scala

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
            url = "http://supertool.example.org/"
            author("Tina Gheek", "tina@example.org")
            author("James Class", "jimclass@example.org")
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

                val scalaVersionDir = "scala-" + buildScalaVersion
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

### The Main Container

The main container for an IzPack XML configuration is the `installation`
element:

    <installation version="1.0">
    ...
    </installation>

When writing your IzPack configuration purely in SBT, the main container
is an `IzPackConfig` object, typically declared as a `lazy val`:

    lazy val installConfig = new IzPackConfig("target" / "install", log)

The constructor takes two parameters:

* The SBT `Path` object describing the directory to contain the generated
  installation files. (The plugin will create the directory, if it doesn't
  already exist.)
* The SBT `Logger` object.

The main configuration will contain all the other sections of your
configuration. You are also free to put helper methods and variable
definitions of your own within the class. The example, above, contains these
`val` definitions:

    val InstallSrcDir = mainSourcePath / "izpack"
    val TargetDocDir = "target" / "doc"
    val LicenseHTML = TargetDocDir / "LICENSE.html"
    val ReadmeHTML = TargetDocDir / "README.html"

Those definitions are not required by the `IzPackConfig` class; indeed, the
base `IzPackConfig` object doesn't even know they're there. They're just a
useful place to stash some common definitions.

Except for the [language packs][], to add sections to the `IzPackConfig`,
you simply create a new class for the corresponding section. For instance,
to define the `Info` section, you just create an `Info` object:

    new Info
    {
        ...
    }

[language packs]: #language_packs

### The Info Section

The `Info` class corresponds to the XML `info` section, and it shares similar
terminology. You create an `Info` object inline, as follows:

    new Info
    {
        appName = projectName.value.toString
        appSubpath = "org.example/" + appName
        appVersion = projectVersion.value.toString
        author("Tina Gheek", "tina@example.org")
        author("James Class", "jimclass@example.org")
        createUninstaller = true
        javaVersion = "1.6"
        pack200 = false
        requiresJSK = false
        runPrivileged = false
        summaryLogFilePath = "$INSTALL_PATH/log.html"
        url = "http://supertool.example.org/"
        webDir = "http://www.example.org/software/SoftTool/1.0"
        writeInstallationInfo = true
    }

`Info` supports the following settings.

* `appName`

        appName = "My Application Name"

> The application name. Corresponds to the XML `appname` element. Instead
> of hardcoding a constant string, consider using the SBT-provided
> `projectName.value.toString` value, which takes the project's name from
> the `project.name` value in the `project/build.properties` file.
>
> Required.

* `appSubpath`

        appSubpath = "SuperTool"

  The subpath for the default installation path. The IzPack compiler will
  perform variable substitution and slash-backslash conversion on this
  value.

  Optional. Default: `appName`

* `appVersion`

        appVersion = "1.0"

   The application version. Corresponds to the XML `appversion` element.
   Instead of hardcoding a constant string, consider using the SBT-provided
   `projectVersion.value.toString` value, which takes the project's name
   from the `project.version` value in the `project/build.properties` file.

   Optional. No default.

* `author`

        author("Tina Gheek", "tina@example.org")
        author("James Class", "jimclass@example.org")

   Specifies an author, or multiple authors, of the software. The first
   parameter is the author's name, and the second is the author's email
   address. If an author has no email address, that parameter can be omitted.
   Each invocation of `author()` adds an author to the list of authors.

   Optional. No default.

* `createUninstaller`

        createUninstaller = true

   Whether or not to create an uninstaller jar at installation time.

   Optional. Default: `true`

   NOTE: This setting is less powerful than the corresponding setting
   in the IzPack XML configuration. If you need access to all the capabilities
   of the underlying `uninstaller` XML element, use custom XML. For example:

        customXML = <uninstaller write="yes" name="remove.jar"/>

   See [Custom XML][] for more information.

[Custom XML]: #custom_xml

* `javaVersion`

        javaVersion = "1.6"

   The minimum Java version required to install and run the program. Values
   can be "1.2", "1.3", etc., and are compared against the value of the
   `java.version` System property on the install machine.

   Optional. No default.

* `pack200`

        pack200 = false

   Setting this variable to `true` causes every jar file that you add to
   your packs to be compressed using Pack200 (see [Pack200][]). Signed jars
   are not compressed using Pack200, as it would invalidate the signatures.
   This makes the compilation process a little bit longer, but it usually
   results in significantly smaller installer files. See the
   [IzPack documentation][izpack-info-section] for more details.

   Optional. Default: `false`

[Pack200]: http://java.sun.com/j2se/1.5.0/docs/guide/deployment/deployment-guide/pack200.html
[izpack-info-section]: http://izpack.org/documentation/installation-files.html#the-information-element-info

* `requiresJDK`

        requiresJDK = false

   Whether or not a JDK is required at runtime (as opposed to a JRE).

   Optional. Default: `false`.

* `runPrivileged`

        runPrivileged = false

   Whether or not to attempt privilege escalation.

   Optional. Default: `false`

   NOTE: This setting is less powerful than the corresponding setting
   in the IzPack XML configuration. If you need access to all the capabilities
   of the underlying `runprivileged` XML element, use custom XML. For example:

        customXML = <runprivileged condition="ifwindows"/>

   See [Custom XML][] for more information.

* `summaryLogFilePath`

        summaryLogFilePath = "$INSTALL_PATH/log.html"

   Specifies the path of the logfile for IzPack's 
   `SummaryLoggerInstallerListener`.

   Optional. No default.

* `url`

        url = "http://supertool.example.org/"

   The website URL for the application.

   Optional. No default.

* `webDir`

        webDir = "http://www.example.org/software/SoftTool/1.0"

   Causes a web installer to be created, and specifies the URL from which
   packages are to be retrieved at installation time.

   Optional. Default: a web installer is *not* created

* `writeInstallationInfo`

        writeInstallationInfo = true

   Specifies whether or not the file `.installinformation` should be written,
   which includes the information about installed packs.

   Optional. Default: `true`

### Language Packs

Unlike the IzPack XML format, there's no special `locale` object in the
`IzPackConfig` class. Instead, language packs are simply specified as a
Scala list of strings, each element of which is an [ISO3 country code][].

For example:

    languages = List("eng", "chn", "deu", "fra", "jpn", "spa", "rus")

[ISO3 country code]: http://en.wikipedia.org/wiki/ISO_3166-1_alpha-3

### The Packaging Section

The `Packaging` class corresponds to the XML `packaging` section, and it
shares similar terminology.  You create a `Packaging` object inline, within
the `IzPackConfig` object:

    new Packaging
    {
        import Packager._

        packager = Packager.SingleVolume
    }

If this setting is omitted, a single-volume installer is created.

`Packaging` supports the following settings.

* `packager`

        import Packager._

        packager = Packager.SingleVolume

   The `packager` variable can be set to either `Packager.SingleVolume` or
   `Packager.MultiVolume`; these values correspond exactly to their IzPack
   XML counterparts. You *must* import the `Packager` submodule, as shown
   above, to set this value.

* `volumeSize`

        volumeSize = 1024*1024*1024

   Ignored unless `packager` is set to `Packager.MultiVolume`, this variable
   sets the size, in bytes, of each volume of a multivolume installer. It
   corresponds to the IzPack XML `volumesize` option.

   Optional. Default: None

* `firstVolFreeSpace`

        firstVolFreeSpace = 1024*1024

   Ignored unless `packager` is set to `Packager.MultiVolume`, this variable
   sets the size, in bytes, of the free space to leave on the first volume of
   a multivolume installer. It corresponds to the IzPack XML
   `firstvolumefreespace` option.

   Optional. Default: None

### The Resources Section

The `Resources` class corresponds to the XML `resources` section, and it
shares similar terminology. You create a `Resources` object inline, within
the `IzPackConfig` object:

    new Resources
    {
        ...
    }

The `Resources` object, in turn, consists of individual `Resource` objects
and an optional `InstallDirectory` object:

    new Resources
    {
        new Resource
        {
            id = "HTMLLicencePanel.licence"
            source = "src" / "docs" / LICENSE.html"
        }

        new Resource
        {
            import ParseType._

            id = "HTMLInfoPanel.info"
            source = "src" / "docs" / "README.html"
            parseType = ParseType.Plain
        }

        new Resource
        {
            id = "Installer.image"
            source = InstallSrcDir / "supertool-logo.png"
        }

        new InstallDirectory
        {
            """C:\Program Files\SuperTool""" on Windows
            "/Applications/SuperTool on MacOSX
            "/usr/local/supertool" on Unix
        }
        ...
    }


The Resources section has no variables that it recognizes (though you can
set your own variables, for your personal use).

#### Individual Resource sections

Each individual `Resource` object supports the following settings:

* `source`

        source = "path" / "to" / "the" / "resource" / "file"

   An SBT `Path` that specifies the file that is used to create the resource.
   
   Required.

* `id`

        id = "HTMLInfoPanel.info"

   An XML ID, used to refer to the panel later. Some IDs are fixed by IzPack.
   Consult the [IzPack installation file][] documentation for details.
   
   Required.

* `parseType`

        import ParseType._

        parseType = ParseType.Plain

  If the resource is parsable, the `parseType` value tells IzPack what kind
  of file it is. Legal values:
  
  - `ParseType.JavaProperties`: The file is a Java properties file.
  - `ParseType.XML`: The file is XML.
  - `ParseType.Plain`: The file is plain text.
  - `ParseType.Java`: The file is Java source code.
  - `ParseType.Shell`: The file is a shell script.
  - `ParseType.Ant`: The file is an [Ant][] build file.
  
  The legal values are dictated by IzPack; `Scala` isn't currently one of the
  choices.
  
  Optional. Default: `ParseType.Plain`

### Variables

The `Variables` class corresponds to the XML `variables` section and
defines variables that will be created in the generated IzPack XML and can
be substituted in parsable files. The section is optional, and it can contain
multiple `variable()` calls, of this form:

    variable(name, value)
    
The name must be a unique string. The value can be of any type; it will be
converted to string before being written to the generated XML. For example:

    new Variables
    {
        variable("app-version", projectVersion.value)
        variable("released-on", new java.util.Date)
    }

### Conditions

Conditions are not directly supported in the `IzPackConfig` class, but you
can insert them via [Custom XML][].

### The GuiPrefs section

The `GuiPrefs` class corresponds to the XML `guiprefs` section. As with the
other sections, you create a `GuiPrefs` object inline, within the `IzPackConfig`
object:

    new GuiPrefs
    {
        height = 768
        width  = 1024

        new LookAndFeel("metouia")
        {
            onlyFor(Unix)
        }

        new LookAndFeel("liquid")
        {
            onlyFor(Windows, MacOS)

            params = Map("decorate.frames" -> "yes",
                         "decorate.dialogs" -> "yes")
        }
    }

The `GuiPrefs` class, itself, has several settings. In addition, it supports
embedded `LookAndFeel` objects.

The recognized `GuiPrefs` settings are:

* `height`

        height = 768

   The initial window height, in pixels, of the graphical installer UI.
   
   Optional. Default: 600

* `width`

        height = 768

   The initial window width, in pixels, of the graphical installer UI.
   
   Optional. Default: 800

* `resizable`

        resizable = true
        
   Whether the graphical installer UI window can be resized by the user.

#### LookAndFeel sections

With the GuiPrefs section, you may also specify `LookAndFeel` object, which
correspond directly to `laf` sections in the generated XML. A `LookAndFeel`
object is created with a name (the name of the look-and-feel, as recognized
by IzPack), and it may also contain operating system restrictions and arbitrary
parameters. In the example above:

        new LookAndFeel("metouia")
        {
            onlyFor(Unix)
        }

specifies that the Metouia look-and-feel may be used, but only on Unix
systems.

Similarly:

        new LookAndFeel("liquid")
        {
            onlyFor(Windows, MacOS)

            params = Map("decorate.frames" -> "yes",
                         "decorate.dialogs" -> "yes")
        }

says that the Liquid look-and-feel may be used on Windows and Mac OS X.
It specifies two additional Liquid-specific parameters.

Consult the [IzPack installation file][] documentation for details.

### The Panels section

The `Panels` class specifies the individual installer panels in the UI; it
corresponds to the XML `panels` section. It consists of individual `Panel`
objects, each of which specifies one panel.

#### Individual Panel sections

Each `Panel` section specifies one panel in the installer.

    new Panel("HelloPanel")
    new Panel("HTMLLicencePanel")
    new Panel("TargetPanel")
    new Panel("PacksPanel")
    new Panel("InstallPanel")

    new Panel("UserInputPanel")
    {
        id = "myuserinput"
        condition = "pack2selected"
    }

    new Panel("FinishPanel")
    {
        jar = "MyFinishPanel.jar"
    }

At a minimum, the panel's class name is required, as its only parameter.
The remaining settings are optional.

* `id`

  An identifier for the panel, which can be used later (e.g., for reference
  by a user-input panel definition).
   
* `condition`

  The ID of a condition which has to be fulfilled to show this panel.
  (NOTE: `IzPackConfig` does not currently directly support conditions, but
  you can define them via [Custom XML][].

* `jar`

  The jar file where classes for this panel can be found. This option is
  necessary only if you're not using a standard IzPack panel.


### The Packs section

The `Packs` section defines the individual installation packs: the
selectable categories that the user will be installing. It corresponds to
the XML `packs` section, and it consists of one or more `Pack` sections.

#### Individual Pack sections

Each `Pack` section represents an installable unit. It takes several settings,
and a series of file specifications.

The settings are:

* `required`

  A boolean setting indicating whether or not the pack is required to be
  installed. If it's required, it cannot be deselected.
  
  Optional. Default: `false`
  
* `preselected`

  A boolean setting indicating whether or not the pack is preselected on the
  screen. Required options are always preselected.
  
  Optional. Default: `false`
  
* `description`

  A brief description of the pack's contents.
  
  Optional. Default: none
  
* `depends`

  A list of other packs that must be selected for the pack to be installed.
  For example:
  
        val docPack = new Pack("Docs")
        {
            required = false
            preselected = false
            description = "Documentation"
            ...
        }

        new Pack("Doc source")
        {
            required = false
            preselected = false
            description = "Documentation Source"
            depends = List(docPack)
            ...
        }

  Optional. Default: empty list (i.e., no dependencies on other packs)

* `hidden`

  A boolean setting that indicates whether the pack is hidden or not.
  
  Optional. Default: `false`

##### Specifying files

The remainder of a `Pack` section is typically taken up with file
specifications. There are three ways to specify files to put in the pack.
All three use SBT's `Path` capability, rather than the underlying IzPack
`fileset` and path primitives. Using SBT's `Path` capabilities, rather than
relying on IzPack's, has several advantages, including:

1. Readability. SBT's path semantics are *much* more readable than the
   Ant-like file sets used in the IzPack XML files.
2. Debugging. You can embed `print` statements or logging calls within
   your SBT build file, to ensure that you're getting the files you think
   you're getting.
   
Here are the file-selection sections:

* `File`

  Includes a single file in the pack, specifying both the source file
  (as a `Path`) and the target installation directory (as a string).
  The file will have the same name when installed as it does within the
  source tree.

        new File("myutils.jar", "$INSTALL_PATH/lib")
        
  `File` supports two variables:
  
  - `unpack`: Whether or not the file needs to be unpacked (e.g., it's a
    zip file). Defaults to `false`.
  - `overwrite`: What to do if the file exists when the installer runs.
    Legal values:
    
    + `Overwrite.Yes` to overwrite unconditionally
    + `Overwrite.No` to leave the existing file alone
    + `Overwrite.AskYes` to ask the user, with "yes" preselected
    + `Overwrite.AskNo` to ask the user, with "no" preselected
    + `Overwrite.Update` to overwrite unconditionally, but only if the
      file being installed is newer than the one on disk.

    To use these constants, you must import `Overwrite._`

* `SingleFile`

  Includes a single file in the pack, specifying both the source file
  (as a `Path`) and the target installation location (as a string).
  `SingleFile` is similar to `File`, except that it permits the file to
  have a different name when installed.

        new SingleFile(jarPath, "$INSTALL_PATH/lib/supertool.jar")
        
* `FileSet`

  Use `FileSet` to specify multiple files, via SBT's powerful path-finder
  semantics. The full example, above, has a good illustration of the power
  of this class:

        val projectBootDir = "project" / "boot" / "scala-" + buildScalaVersion
        val jars = (("lib" +++ "lib_managed") **
                    ("*.jar" - "izpack*.jar"
                             - "scalatest*.jar"
                             - "scala-library*.jar"
                             - "scala-compiler.jar")) +++
                    (projectBootDir ** "scala-library.jar")
        new FileSet(jars, "$INSTALL_PATH/lib")
        
  The first `val` setting creates a `Path` value that points to the
  directory where SBT stashes the downloaded Scala libraries.
  
  The second `val` uses SBT's path-finder language to get all the jars
  in the "lib" and "lib_managed" directories, except for certain jars.

  Finally, those jars are passed to a `FileSet` object, so they'll be
  included in the generated installer.

  `FileSet` supports two variables:
  
  - `unpack`: Whether or not the files need to be unpacked (e.g., it's a
    zip file). Defaults to `false`.
  - `overwrite`: What to do if a file exists when the installer runs.
    Legal values:
    
    + `Overwrite.Yes` to overwrite unconditionally
    + `Overwrite.No` to leave the existing file alone
    + `Overwrite.AskYes` to ask the user, with "yes" preselected
    + `Overwrite.AskNo` to ask the user, with "no" preselected
    + `Overwrite.Update` to overwrite unconditionally, but only if the
      file being installed is newer than the one on disk.

    To use these constants, you must import `Overwrite._`
  
### Custom XML

There are features of IzPack that this plugin's `IzPackConfig` class does
not support directly. If you need those features, you can usually just plug
the XML you need right into the section where it belongs. The plugin will
ensure that the extra, custom XML gets into the generated configuration.

For example, suppose you want to define a series of conditions.
`IzPackConfig` does not directly support conditions, but you can add them
via a `customXML` setting:

    lazy val installConfig = new IzPackConfig("target" / "install", log)
    {
        customXML = 
            <conditions>
              <condition type="variable" id="standardinstallation">
                <name>setup.type</name>
                <value>standard</value>
              </condition>
              <condition type="variable" id="expertinstallation">
                <name>setup.type</name>
                <value>expert</value>
              </condition>
              <condition type="java" id="installonwindows">
                <java>
                  <class>com.izforge.izpack.util.OsVersion</class>
                  <field>IS_WINDOWS</field>
                </java>
                <returnvalue type="boolean">true</returnvalue>
              </condition>
              <condition type="and" id="standardinstallation.onwindows">
                <condition type="ref" refid="standardinstallation"/>
                <condition type="ref" refid="installonwindows" />
              </condition>
            </conditions>
        ...
    }
    
The custom XML will be inserted into the generated XML, in this case, within
the main `installation` section (where it belongs).

All section classes support the `customXML` setting.

### Putting it all together

Once you've defined your `IzPackConfig` object, you have to wire it into your
SBT build by creating a task that will generate the installer. The easiest
way to do that is to follow this boilerplate:

    lazy val installer = task {buildInstaller; None}
                         .dependsOn(packageAction, docAction)
                         .describedAs("Build installer.")

    private def buildInstaller =
    {
        val installerJar = projectName.value.toString.toLowerCase + "-" +
                           projectVersion.value.toString + "-install.jar"
        izpackMakeInstaller(installConfig, "target" / installerJar)
    }

Putting that logic in your SBT build file will expose an "installer" action,
so that `sbt installer` will build your installer jar file.

## Copyrights

* The IzPack SBT plugin is copyright &copy; 2010-2011 Brian M. Clapper.
* IzPack is copyright &copy; 2001-2008 Julien Ponge
* SBT is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.  

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
[Scala Tools Maven repository]: http://www.scala-tools.org/repo-releases/
