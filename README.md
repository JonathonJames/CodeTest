# Coding Test - Jonathon James


## Plan
Create a job search app that allows for bookmarking of interesting jobs.

### Scheduling/Deadine issue
I originally thought I had a week to complete this task, but I ended up having ~1.5 days so there's quite a lot of gaps here. Namely functionality is limited, I haven't yet looked at differentiating the UI for iPad, and I haven't dealt with dynamically accounting for dark mode/accessibility changes (just some limited use of dynamic type to get things started).

The UI is also very rudementary. I just needed it to display something.

I ran out of time for delivering the bookmarking. I've at least got the Core Data in place for the basics of it, and apply it to the filtering (in principle, since there's nothing there for it to filter). Additionally the API doesn't allow for loading a listing by id directly, so there'd have been a bunch of wrangling to deliver the feature that wasn't worthwhile in the given time span.

## What was achieved
I aimed to deliver a simple MVVM architecture using UIKit and Combine. Whilst I appreciate the job spec called out Cocoapods, there's nothing here that really requires third party libraries, and I saw no need to add them just for the sake of it.

I chose Combine because it works with iOS 13 and up, which will very soon be Current OS -2. And I've not used it profressionally before, just dabbled, so I took the opportunity to refresh things.

I opted not to use SwiftUI due to my opinion that it is not yet fit for purpose. Even though it's available alongside Combine, the consensus of even the iOS 15 beta iteration is that it's still lacking. And I agree. For now, UIKit is more robust and feature complete.

My commenting and coding style generally revolves around auto-documentation comments and self documenting code. I like to be quite verbose with my variable names, and indeed in my variable typing by explicitly typing the variables. Similarly I tend to not use trailing closures and always explicility use "self." - despite this not being necessary, I find it makes refactoring easier (when code moves from one scope to another, perhaps inside a closure, it prevents the need for fiddly retypes).

Of course I'm always happy to adapt to the standards and practices for each project, regardless of whether it would align with my natural style.

## Tests
I kept the unit tests confined specifically to the search query. The bulk of the functionality within the app is built around that, so it seemed a good place to start. The tests themselves are written as per being built around acceptance critera, with the auto-documentation comments explicitly defining these in a TDD-esque fashion. There's obviously a lot of repetition and boilerplate here as well, so I didn't want to write too much of this given the limited time available. Hopefully what's there conveys what I was going for well enough.

No UITests due to timing issues either. Although they'd follow a similar format where possible (whether using XCUITest or something else), having a BDD style scenarios.

## Extensibility
Beyond the aforementioned bookmarking feature, there's a lot of room for additional functionality here. The API has additional endpoints (for submitting job listings, for example). And if the API was within scope then obviously that could be updated to.

### Potential issues
Although they're likely only broad numbers, this API sends currency values back as floating-point values. Perhaps not so much of an issue here since the values are broad and non-specific. Due to the nature of iOS, there is no in-built way to decode/deserialise these directly into a Decimal type, they have to go through Double first. There _are_ third party libraries that work with dealing with this, but the replace _all_ of the serialization mechanism and are not nearly as well tested as the native mechanism. Ideally the API would be updated to use either strings or integer values using the lowest form of any given currency (e.g GBP would be listed in pence), thereby removing the ambiguity. Alternatively informed rounding can be applied (to correct for this loss of precision (since currency values will only have up to 3 decimal places, depending on the currency, to account for)

## In summary
It's not the most impressive of apps. Certainly not visually. But I hope it conveys my coding style and how I go about problem solving/architecting things. And that you can see where I was headed.

IF you have any queries about decisions I made or anything that isn't clear, please give me a shout.

Thanks for your time.