# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/app/boot')

run Rack::URLMap.new({
  '/' => Brt::App,
  '/news' => Brt::NewsApp,
  '/people' => Brt::People,
  '/sponsors' => Brt::Sponsors,
})
