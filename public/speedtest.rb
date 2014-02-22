#!/usr/bin/ruby 
require 'net/http'
times = 1

stimes = ARGV[0]
if(!stimes.nil?)
	times = stimes.to_i
end

local_base = "http://127.0.0.1:3000"
remote_base = "http://sse-basic-demo.herokuapp.com"

base = local_base

NORMAL = base+"/check"
STREAMING = base+"/check?stream=true&times="+times.to_s


def time(raw_url, num=1)
	a = []
	if raw_url == NORMAL
		def get(raw_url)
			t0 = Time.now
			url = URI.parse(raw_url)
			req = Net::HTTP::Get.new(url)
			res = Net::HTTP.start(url.host, url.port) {|http|
			  http.request(req)
			}
			t = Time.now
			return t-t0
		end
		a=num.times.map{|m| get(raw_url) }
	end
	if raw_url == STREAMING
		t0 = Time.now
		uri = URI(raw_url)
		Net::HTTP.start(uri.host, uri.port) do |http|
		  request = Net::HTTP::Get.new uri
		  http.request request do |response|
	      response.read_body do |chunk|
	        # chunk
	        t = Time.now
	        a << (t-t0)
	        t0 = t
	      end
		  end
		end
	end
	a.reduce(:+)
end

puts "normal:"
puts time(NORMAL, times)
puts "streaming"
puts time(STREAMING)