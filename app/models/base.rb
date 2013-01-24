# encoding: utf-8

class Base

  def editlink
    "#{self.class.link}/#{id}"
  end

  def deletelink
    "#{self.class.link}/#{id}"
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
