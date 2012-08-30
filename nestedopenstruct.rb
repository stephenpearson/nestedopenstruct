#!/usr/bin/env ruby

require 'ostruct'

module ActsAsNestedOpenStruct
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def structify
      instance_eval do
        class << self
          @@attrs ||= OpenStruct.new
        end
  
        def method_missing(method, *args)
          name = @@attrs.send(method, *args)
          unless name
            @@attrs.send("#{method}=", self.class.new)
            @@attrs.send(method).send(:structify)
            return @@attrs.send(method)
          end
          name
        end
      end
      self
    end
  end
end

class String
  include ActsAsNestedOpenStruct
end

fee = "fee".structify
fee.fie.foe.fum = "namhsilgnE"

# To prove that fum is still a String
puts fee.fie.foe.fum.reverse
