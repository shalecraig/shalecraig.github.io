---
layout: post
title: "Scala config for IntelliJ"
date: 2014-04-06 00:27
comments: true
categories: dev code note-to-self
---

I was trying to get Scala setup with Intellij, and noticed that it was asking me
about the Scala home directory.

For Scala installed using homebrew's `brew install scala` command, homebrew
outputs a nice message when `brew info scala` is run:

~~~
$ brew info scala
....

==> Caveats
To use with IntelliJ, set the Scala home to:
  /usr/local/opt/scala/idea
~~~

I was surprised, and figured I'd post it.
