all:
	echo "text"
#	lessc -x app/views/css/styles.scss > public/css/styles.css

install:
	gem install bundler
	bundle install --without production

uninstall:
	rvm --force gemset empty
	rm Gemfile.lock

