# XKCDViewer

## Project Priorities

My main priorities with this project was reliability and scalability. This involved focusing on a few areas:

* Creating a network stack that was scalable - so even though we only have one network request running through it, it could be expanded in the future to make multiple network calls. Also put in base error handling (with user feedback) that could be expanded.
* Unit and Integration tests to assure that anywhere we transform data, make network operations, or utilize persistent is properly tested so future changes are less prone to create unnoticed errors
* Reusable components where possible: rather than just putting a TextField in the main view, a reusable component was created that handled the validation to only allow numbers in the field - thus it could be reused elsewhere if needed.
* Added a persistence layer for iOS 17+, to reduce network calls

## Time spent

I spent about 3.5-4 hours on this project. The flow of the project was as follows:

* Started by creating my model for the json data, and my network layer. This was created in unison with the unit/integration tests for them, to assure that the foundation for the data the app would use was solid. Spent ~35 minutes on this.
* From that point, I worked on the main view, including the reusable TextField to limit input to only numerals. ~20 minutes.
* The Comic Detail View, subviews, and ViewModel for making the network requests was next. Unit tests were built in unison with the ViewModel functions to assure that all view states and data transformations were in place. Only network requests were handled at this point, persistence was added later. ~45 minutes.
* At this point, the app was in a "feature complete" state, meeting the technical requirements of the app. I added a persistence layer using SwiftData (trade-offs were made, explained below) to cache the network requests so they would draw from cache instead of making repetitive network calls. ~1 hour.
* Finally, I went back through the app, did some minor refactoring, added/updated comments, and added a network connection monitor, to disable network requests when the device does not have a network connection, as well as show the user a banner notifying them to the lack of connection. Also added a GitHub action to run unit tests whenever code is pushed to the main branch. ~ 35 minutes.
* This documentation, and quickly making a super basic icon for the app 😀. ~30 minutes.

And while I know this will be hard to believe given my amazing work on the app icon 🙃, I'm not a designer. My focus was mainly put on functionality, with the main UI effort put towards making sure the app behaves well with accessibility text sizes, and where appropriate adding accessibility labels.

## Decisions and trade-offs

There are a few areas where decisions were made that involved trade-offs:

### Image downloads

Because the size of images was small, AsyncImage was used to download the images. The trade-offs are as follows:

* AsyncImage utilizes URLSession, so no custom code needs to be written to create the network requests. It allows for Apple-provided way to reliably download images.
* While AsyncImage does use URLCache, so in theory it can reused cached images, but if the image source has caching prevented, then image will always re-download. Caching images while using AsyncImage is possible, but is arguably as complex as downloading the images manually and caching them with NSCache/custom caching system.
* Pinch-to-zoom is not available in my implementation. If a WKWebView was used this would have been available by default, but it would have given less control over the overall layout. Downloading the image manually and displaying it with a custom approach might have also allowed the usage of the MagnifyGesture on iOS 17+

### Persistence choices

The choice to use SwiftData for persistence has the following positives:

* Uses a modern persistence system, with simpler migrations than other less-modern or third party systems
* Model based, no need to create boilerplate code or a model object file

The main trade-off is that iOS 16 does not get to take part in the persistence, as SwiftData is not available before iOS 17. Knowing that Experian will most likely be dropping iOS 16 support in the next calendar year, and that overall iOS adoption has iOS 17/18 at [roughly 91% worldwide](https://mixpanel.com/trends/#report/ios_18), this seemed like a fair trade for the gains in code modernization.

Another persistence choice that was made is the assumption that all data is static (data won't change over time). Once a user views comic #100, that data will no longer be refreshed from the web. Due to the nature of XKCD, this seems unlikely, so the decision to bypass further network requests for the sake of lowering network traffic was made. In a different system, one of two routes might be taken:

1. Load from cache if available, but then still pull data from the web. If there is a diff, load the newly fetched data and update the cache. This still provides an apparent speed improvement to the user, but does not lower network traffic.
2. With a backend that we have control over, the request could include a version number in the request, and if the server version is the same, the return would return that the cache already has the correct information. This would not limit network calls, but would limit data used.

### Additional information

The vast majority of the code was written custom for this application, but I will point out a few pieces that I have carried forward from previous projects:

* `Bundle+Extension.swift` - this code originally came from [](hackingwithswift.com), but I have been using it for loading json files from the bundle for years. It essentially goes in all my projects to help with unit testing.
* `NetworkViewModel.swift` - this was adapted from code I've been using in the past few years. My original code had been updated to use the iOS 17 `@Observable` model, but I converted it back to use `@ObservedObject` for this project.

