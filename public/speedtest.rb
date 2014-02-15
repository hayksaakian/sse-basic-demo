#!/usr/bin/ruby 
require 'net/http'
times = 25
NORMAL = "http://127.0.0.1:3000/m"
STREAMING = "http://127.0.0.1:3000/s?times="+times.to_s

puts ARGV[0]

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