# encoding: utf-8
#
#   this is berlinracingteam.de, a cuba application
#   it is copyright (c) 2009-2011 danilo braband (danilo @ berlinracingteam,
#   then a dot and a 'de')
#

module Kernel
private
  def cdn
    '//berlinracingteam.commondatastorage.googleapis.com'
  end

  def coat(file)
    require 'digest/md5'
    hash = Digest::MD5.file("views#{file}").hexdigest[0..4]
    "#{file.gsub(/\.scss$/, '.css')}?#{hash}"
  end

  def root(*args)
    File.join(File.expand_path(File.dirname(__FILE__)), *args)
  end

  def development?
    !production?
  end

  def production?
    ENV['RACK_ENV'] == 'production'
  end

  def slugify(str)
    s = str.to_ascii
    s.gsub!(/\W+/, ' ')
    s.strip!
    s.downcase!
    s.gsub!(/\ +/, '-')
    s
  end
end

