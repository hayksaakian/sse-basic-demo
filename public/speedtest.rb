#!/usr/bin/ruby 
require 'net/http'
times = 1

stimes = ARGV[0]
if(!stimes.nil?)
	times = stimes.to_i
end

local_base = "http://127.0.0.1:3000"
remote_base = "http://sse-basic-demo.herokuapp.com"

NORMAL = remote_base+"/m"
STREAMING = remote_base+"/s?times="+times.to_s


def time(raw_url, num=1)
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
	a.reduce(:+)
end

puts "normal:"
puts time(NORMAL, times)
puts "streaming"
puts time(STREAMING)