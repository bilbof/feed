require 'dalli'

class Cache
	def initialize(namespace: "cache_v1")
		@namespace = namespace
	end

	def get(key)
		client(raise_errors: true).get(key)
	rescue Dalli::DalliError => e
		raise CacheError.new(e)
	end

	def set(key, object, expires_in: DEFAULT_EXPIRES_IN)
		client(expires_in: expires_in).set(key, object)
	rescue Dalli::DalliError => e
		nil
	end

	def flush!
		client(raise_errors: true).flush
	end

private

	class CacheError < Dalli::DalliError; end

	attr_accessor :namespace

	DEFAULT_EXPIRES_IN = 600

	def client(expires_in: DEFAULT_EXPIRES_IN, raise_errors: false)
		options = {
			namespace: namespace,
			compress: true,
			expires_in: expires_in,
			raise_errors: raise_errors,
		}
		Dalli::Client.new('localhost:11211', options)
	end
end
