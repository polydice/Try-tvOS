pod-install:
	bundle exec pod install --no-repo-update
	xcproj touch iCookTV.xcodeproj
