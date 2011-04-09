require 'dm-sqlite-adapter'
require 'dm-core/spec/setup'

require 'tempfile'

module DataMapper
  module Spec
    module Adapters

      class SqliteAdapter < Adapter
        def connection_uri
          if name == :default
            "sqlite3::memory:"
          else
            # sqlite doesn't support two in memory dbs
            "sqlite3://#{Dir.tmpdir}/#{storage_name}.db"
          end
        end
      end

      use SqliteAdapter

    end
  end
end
