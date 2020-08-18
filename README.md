# GitTrend Take Home Test
An up to date list of trending Github projects

## Dependencies
None

## What I'd do with more time

### Create RepoViewModel
Currently a `RepoViewModel` isn't worth it as the API decodable translates almost seamlessly.
However some of the additions below would add enough business logic on top of the basic `Repo` model to justify a `RepoViewModel`

### Adapt Cells for Dyanmic text
-

### Create a memory managed Cache
At present we cache the repo author's avatar image data within the `Repo`.
This works fine as the API only returns 25 repos but would not scale if the 
API was modified in the future to return very large numbers.
I'd create my own `Cache` that utilizes `NSCache` but allows us to cache value types

### Reduce Image size
This would be as simple as appending `s=120` to the image URLs.
However such a change should be done using ViewModels as we'd no longer have a 1 to 1 mapping between the `Repo` and the `RepoCell`

### Replace GitTrendAPI with protocol
This dependecy should abise by the dependency inversion principle so we can easily swap
our `RepoAPIRequest` out for a third party library if needed.

### Track Image download requests
If you scroll very fast upon the initial load it's possible to have more than one request
for the avatar url images. This can be remedied by either recording the requests made within the
`GitTrendAPI` or by using a third party networking library. I chose not to do the latter here
as the purpose of this project is to showcase my own code for hiring purposes.

### Add Error Handling to Network layer and utilize Result
-
