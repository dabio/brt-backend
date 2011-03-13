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

  def has_auth?
    !current_person.nil?
  end

  def has_admin?
    has_auth? && current_person.id == 1
  end

  def root(*args)
    File.join(File.expand_path(File.dirname(__FILE__)), *args)
  end

  def development?
    !(production? or test?)
  end

  def production?
    ENV['RACK_ENV'] == 'production'
  end

  def test?
    ENV['RACK_ENV'] == 'test'
  end

  def simple_format(str)
    str = '' if str.nil?
    start_tag = "<p>"
    end_tag = "</p>"
    str.gsub! /\r\n?/, "\n"
    str.gsub! /\n\n+/, "#{end_tag}\n\n#{start_tag}"
    str.gsub! /([^\n]\n)(?=[^\n])/, "\1<br />"
    str.insert 0, start_tag
    str.concat end_tag
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

