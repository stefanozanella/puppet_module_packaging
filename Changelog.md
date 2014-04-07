# Changelog

## 0.2.0

* Introduce :recursive option, which performs recursive dependency packaging if
  enabled.

## 0.1.1

* Fix a bug in the Modulefile parser that prevented correct dependency
  detection when no space between constraint qualifier and actual version was
  provided.

## 0.1.0

* Fix a shadowed variable bug in the test suite that prevented it to work
  correctly.
* Added the Modulefile to the list of installed files in the final package
* Fixed parsing of `name-author` string in Modulefile
* Added support for translation of dependencies from Modulefile to final package
* Minor refactoring

## 0.0.2

* Fix a bug that let the tasks fail if not all the standard module directories
  were present (see #1).

## 0.0.1

* Add `rpm`, `deb`, `install` and `clean` tasks.
* Recognize all the `Modulefile` fields except dependencies.
