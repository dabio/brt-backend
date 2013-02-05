# encoding: utf-8

class Base

  def editlink
    if new?
      self.class.link
    else
      "#{self.class.link}/#{id}"
    end
  end

  def deletelink
    "#{self.class.link}/#{id}"
  end

  def simple_format(text, options={})
    t = options.delete(:tag) || :p
    start_tag = "<#{t}>"
    text = text.to_s.dup
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</#{t}>\n\n#{start_tag}")  # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    text.insert 0, start_tag
    text << "</#{t}>"
  end

  class << self

    def link
      '/'
    end

    def createlink
      self.link
    end

  end
end
