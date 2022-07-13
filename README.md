# sapling
A Lua Game Engine for Panic's Playdate

Sapling is intended to ease application development by providing a familiar framework for iOS developers coming to the Playdate.
It uses the existing Playdate callbacks to create a View/Subview architecture that comes with several view objects pre-defined,
but more importantly, it provides an easy to extend mechanism for customization.

Most custom widgets should derive from the View class, as that provides out of the box support for redraw, input handling and
sub-view management. A small sample application has been provided that shows how easy it is to get a simple application up
and running.

Pull requests and bug reports are always welcome as well as any input on direction.