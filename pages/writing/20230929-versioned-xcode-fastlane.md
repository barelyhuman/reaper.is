---
title: Multiple XCode version on Fastlane 
published: true 
date: 29/09/2023
---

This is a short write up on how to have multiple Xcode versions on your local CI without using vagrant images and virtual boxes. 

For context, I handle simplification of tech and automation at [Fountane](https://fountane.com) and the following is basically how we handle MacOS CI boxes. We've got 2 setup's, one is my own macbook and the other is a Mac Mini provisioned by [Scaleway](http://scaleway.com/). The Scaleway version uses vagrant and docker to spin up gitlab runners and do the builds. Though for my macbook, the virtual box images make it hard to run concurrent processes and so I had to switch back to running it the old way. 

The other tool involved in this process is [Fastlane](https://fastlane.tools). Fastlane, has been my go to; tool to handle iOS certificates and Android pre build automation. Though, when working with iOS, there’s this tiny problem that you need a macOS compatible system. The other problem is that certain `xcode` versions cannot be installed on certain macOS versions. 

If you need to deal with the latter; where you need to update to the latest mac and still be able to build older codebases then you are better off going the vagrant way. Luckily, for me the codebases are rather new and can be run from _Monterey_ with XCode versions till 14.2, I'll have to upgrade the codebases for working with Ventura and XCode 15, but for the current state of the codebases, we can manage for a few more months.  

### Solution

1. To Start with, we first need `xcodes` which is a CLI tool that allows you to install multiple `xcode` versions. You can do so with [`homebrew`](http://brew.sh)
```sh
$ brew install xcodesorg/made/xcodes
```
2. Install the required version of xcode, in my case that's 14.2 
```sh
$ xcodes install 14.2
```
3. We need to let fastlane know that it needs to use a specific version. For the sake of the example, I'm hard-coding the _version_, in an actual runner you'd be picking this up from the environment variable to make sure the Fastfile is reusable to newer setups
```ruby
platform :ios
	desc "Create a development build and upload it to TestFlight (create a backup upload on diawi)"
	desc "then notify slack for it"
	lane :beta do 
		xcodes(version: "14.2", select_for_current_build_only: true)
		
		# to keep it more reusable over time 
		# xcodes(version: ENV["XCODE_VERSION"] , select_for_current_build_only: true)

		# remaining actions / statements
		# ...
	end 
end
```

While this works, it's more of a hack then a solution. Cause the environment is going to be dirty and you'll have to make sure your runner cleans up after itself. Since this was done only for my local macbook, it's fine. I would recommend properly setting up vagrant if you only plan to do this for a remote machine that's being provisioned for builds like these.
