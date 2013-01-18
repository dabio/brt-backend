# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/app/boot')

run Rack::URLMap.new({
#  '/' => Brt::Frontend,
  '/admin' => Brt::Admin,
  '/admin/news' => Brt::AdminNews,
  '/admin/people' => Brt::AdminPeople,
  '/admin/sponsors' => Brt::AdminSponsors,
})
