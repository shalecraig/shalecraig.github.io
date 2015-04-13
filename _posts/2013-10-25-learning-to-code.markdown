---
layout: post
title: "Learning To Code"
date: 2013-10-25 22:09
comments: true
categories:
---

From time to time, I like to play around with a new programming languages.

I've designed a few generic exercises for experienced programmers to give them a feel on how these languages work.

You'll walk away having implemented a Genetic Algorithm in this language - all in the span of about four hours.

### Exercises: ###

1. 'Hello World' - the archetypal program that starts it all.
	Since code examples can typically be found online, this is just to ensure the environment is setup correctly.

1. 'Hello USER' - ask the user for their name, then respond with "Hello $NAME".
	I like this exercise because it teaches about user input and variables, in a similar context to the Hello World program.

1. 'Guess the Number' game - write a program that answers "higher" or "lower" until the user guesses the correct number.
	I like this because it uses the concept of user input to teach users about control flow.
	I don't like this because it distracts learning the language with string parsing.
	If the number is chosen randomly, we get to learn how that works too.

1. '[Median of Medians](https://en.wikipedia.org/wiki/Median_of_medians)' algorithm - ask the user for a set of numbers, and return the median.
	Since the problem space size isn't configured while defining the problem, this exercise teaches how the language dynamically allocates memory, and how the language deals with arrays.

1. '[Levenshtein Distance](https://en.wikipedia.org/wiki/Levenshtein_distance) Library' - design and write a library that computes the Levenshtein[^Levenshtein] distance between two strings.
	The "optimal" implementation of the algorithm uses arrays - a concept from the previous exercise.
	This accomplishes two things:
	1. This teaches the user about Library design in this language.
	1. It's easy to get this wrong, which makes it a great opportunity to learn about debugging in this language.

1. '[Genetic Algorithm](https://en.wikipedia.org/wiki/Genetic_algorithm)' - starting from a random initial generation of strings, continue through successive generations until the string 'hello world' evolves.
	With the fitness function of an individual `X` as `LevenshteinDistance(X, 'Hello World')`, we can use the library we've written.
	Now all we need to implement is mutation and crossover - both of which are string parsing.
	If the language is object-oriented, the `Individual` object is an awesome place to learn about how that feels.
	This milestone is pretty awesome, since suddenly you've built something reasonable.

1. '[Union Find](https://en.wikipedia.org/wiki/Disjoint-set_data_structure#Disjoint-set_forests)' - implement the fast union find data structure.


Between the first and last 'hello world', this is a great introduction to a language.

-----------

Let me know if you have any suggestions for other things frequently used.
I know I don't deal with OOP, but there are others I've missed too.

-----------
Footnotes:

[^Levenshtein]: Funnily enough, my Sublime Text wants to convert Levenshtein to Liechtenstein.
