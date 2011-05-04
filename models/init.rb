# coding:utf-8
#
#   this is berlinracingteam.de, a sinatra application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#


def slugify(str)
  s = str.to_ascii
  s.gsub!(/\W+/, ' ')
  s.strip!
  s.downcase!
  s.gsub!(/\ +/, '-')
  s
end


