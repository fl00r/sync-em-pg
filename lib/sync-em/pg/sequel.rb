require 'pg'
require 'forwardable'
require 'sync-em/pg'
require 'sequel'
require 'em-synchrony/connection_pool'

module Sync
  module EM
    class PG

      class ReConnectionPool < EventMachine::Synchrony::ConnectionPool
        def initialize(opts, &block)
          @magick = block
          super
        end

        def acquire(fiber)
          if conn = @available.pop
            conn = @magick.call if conn.state != :connected
            @reserved[fiber.object_id] = conn
            conn
          else
            Fiber.yield @pending.push fiber
            acquire(fiber)
          end
        end
      end

      class Sequel
        class ConnectionPool < ::Sequel::ConnectionPool
          DEFAULT_SIZE = 4
          attr_accessor :pool
          def initialize(db, opts = {})
            super
            size = opts[:max_connection] || DEFAULT_SIZE
            @pool = ReConnectionPool.new(size: size) do
              make_new(DEFAULT_SERVER)
            end
          end

          def size
            @pool.available.size
          end

          def hold(server = nil, &blk)
            @pool.execute(false, &blk)
          end

          def disconnect(server = nil)
            @pool.available.each{ |conn| db.disconnect_connection(conn) }
            @pool.available.clear
          end
        end
      end

      class PGconn < Sync::EM::PG
        extend Forwardable

        def_delegators :@pg, :status, :escape_string, :escape_bytea

        CONNECTION_OK = ::PG::CONNECTION_OK

        class << self
          alias :connect :new
        end

        { async_exec: :send_query,
          prepare: :send_prepare,
          exec_prepared: :send_query_prepared,
          finish: :close }.each do |from, to|
          define_method from do |*args|
            send(to, *args)
          end
        end
        # alias :async_exec :send_query
        # alias :prepare :send_prepare
        # alias :exec_prepared :send_query_prepared
        # alias :finish :close

        def block
          true
        end

        [:get_copy_data, :put_copy_data, :put_copy_end, :get_result, :wait_for_notify].each do |m|
          define_method(m) do |*args|
            raise "Unimplemented method #{m} in green postgres adapter"
          end
        end
      end
    end
  end
end

PGconn = Sync::EM::PG::PGconn

require 'sequel/adapters/postgres'

Sequel::Postgres::CONVERTED_EXCEPTIONS << ::EM::PG::Error