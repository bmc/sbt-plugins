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

### _more coming_

## Copyrights

These plugins are copyright &copy; 2010 Brian M. Clapper.

SBT is copyright &copy; 2008, 2009 Mark Harrah, Nathan Hamblen.
IzPack is copyright &copy; 2001-2006 Julien Ponge.

## License

This plugin is released under a [BSD license][license].

[license]: license.html


