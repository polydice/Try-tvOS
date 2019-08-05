bootstrap:
	gem install bundler -v 2.0.2
	bundle install
	# pod install
	bundle exec pod keys set BaseAPIURL "https://polydice.com/iCook-tvOS/demo/"
	bundle exec pod keys set CrashlyticsAPIKey "-"
	bundle exec pod keys set TreasureDataAPIKey "-"
	bundle exec pod install
	# sh scripts/fabric.sh
	mkdir -p keys
	touch keys/fabric.apikey && echo "fabric.apikey" > keys/fabric.apikey
	touch keys/fabric.buildsecret && echo "fabric.buildsecret" > keys/fabric.buildsecret
