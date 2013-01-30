require 'em/pg'
require 'em-synchrony'

module Sync
  module EM
    class PG < ::EM::PG

      def self._sync
        f = Fiber.current
        resp = yield
        resp.callback{ |r| f.resume(r) }
        resp.errback{ |r| f.resume(r) }
        o = Fiber.yield
        Exception === o ? raise(o) : o
      end

      def initialize(*args)
        super
        PG._sync{ self }
      end

      [:send_query, :send_prepare, :send_query_prepared, :send_describe_prepared, :send_describe_portal].each do |m|
        define_method(m) do |*args|
          PG._sync{ super(*args) }
        end
      end
    end
  end
end