## 3.0.2

* Re-trigger analysis pipeline re-run

## 3.0.1

* Trigger analysis pipeline re-run

## 3.0.0

* **MAJOR UPDATE**: Added complete support for future dates
* Added `tomorrow` field to `TimestampLocale` for localizing "Tomorrow"
* Added `minutesFromNowPrefix` and `hoursFromNowPrefix` fields to `TimestampLocale`
* Added `minutesFromNow()` and `hoursFromNow()` methods to `TimestampLocale`
* Future dates now display as "in 45m", "in 2h", "Tomorrow", etc.
* Enhanced example app to showcase both past and future date formatting
* Added comprehensive test coverage for future date scenarios (53 total tests)
* Updated README with future date examples and updated API documentation
* **Breaking Change**: `TimestampLocale` constructor has new optional parameters (backward compatible with default values)

## 2.0.6

* Updated documentation

## 2.0.5

* Updated documentation

## 2.0.4

* Added Ko-fi and Codecy report

## 2.0.3

* Enhanced documentation

## 2.0.2

* Added a description screenshot for recognizing the package

## 2.0.1

* Added topics for a better indexing

## 2.0.0

* Code refinements and enhanced test widget
* Updated Documentation and README.md
* Made Code coverage from 89% to 100%

## 1.1.2

* Updated Documentation and README.md

## 1.1.1

* Bug fixes and improvements

## 1.1.0

* Added `hoursAgoSuffix` to `TimestampLocale`
* Added `timeagoLimit` parameter to `toTimeagoFormat()`
* Added support for hours to timeago format
* Fix timeagoformat to work with hours
* Updated Documentation and README.md

## 1.0.3

* Bug fixes and improvements

## 1.0.2

* Bug fixes and improvements

## 1.0.1

* Updated README.md
* Updated pubspec.yaml

## 1.0.0

* Initial release.
* `toTimeagoFormat()` extension on `DateTime?`.
* Supports `showTimeForOveraged`, `locale`, `timePattern`, and `referenceTime` parameters.
* `TimestampLocale` for full i18n / custom wording.
