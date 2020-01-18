require "./lib/feed_collection"
require "./lib/cache"

namespace :feed do
	namespace :cache do
		task :refresh do
			puts "Refreshing cache!"
			FeedCollection.refresh_cache
			puts "Done refreshing cache!"
		end

		task :purge do
			puts "Purging cache!"
			Cache.new.flush!
			puts "Cache purged"
		end
	end
end
