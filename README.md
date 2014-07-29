# Some dotfiles

These are my dotfiles.  There are many like them, but these ones are mine.

I like to take sort of a minimalist approach, enhancing the original tools rather than turning them into something completely different.
I also don't like huge bulky plugins that turn my shell/editor/whatever into something completely different — I'm using these tools because I already like them.

You may want to run `install.sh`, which will link files into your home directory and install a couple useful odds and ends.

The things I use:

## XCompose

Shortcuts for typing various Unicode glyphs using a compose key.  e.g., typing `compose` `:` `)` produces ☺.

To make any use of these, you'll need a compose key.  Find the "advanced" section of your keyboard settings (it'll be a bunch of sections about very specific key modifications), find the section about the compose key, and pick one.  I use right Alt.

Main downside is that, as far as I can tell, there's no way to reload this file without restarting X.

## ack

Page by default, smart case (all lowercase → ignore case), sort files.

## git

Contains my name, so like, watch out for that.  For this reason, it's not linked by `install.sh` unless your username is `eevee`.  :)

Mostly just sets some colors.  Also some aliases, which I never use.

Oh, and sets `conflictstyle` to `diff3`, which is amazing.

## psql

That is, the PostgreSQL CLI client.  Persistent history, nicer prompt, prettier display.

## screen

Mostly just tries to fix the status bar.  I don't use `screen` any more so this is completely unmaintained.

## tmux

Changes the prefix key to `^A`, adds a couple quick switch bindings.  Pretty colors for the status bar.

## vim

Turns on everything that should be on by default anyway.

Updated syntax for a few languages I use.

A few unobtrusive keybindings: `-` and `=` to switch tabs, Ctrl-arrow to switch windows, `%%` when typing a filename to get the current directory.

Loads `.vimrc.local` from your homedir if it exists.

Plugins:

* Airline for buffer status bars: super slick.
* Ctrl-P for searching your project (or open buffers, or MRU) for files by subsequence.
* Gitgutter for an inline git diff.
* Characterize to enhance `ga`.
* Ack for ack support much like the built-in grep support.
* Some other things I've forgotten I have.

## zsh

Turns on a bunch of options.  History is shared immediately, but up/down don't see what other shells have been doing.  Automatically reports `time` for anything over 5 seconds.

Window title that's SSH-aware, though hardcoded to my username.

Minimal-effort completion: try hard, use menu.

Dead simple Debian-style prompt.

Syntax highlighting, ooh.
