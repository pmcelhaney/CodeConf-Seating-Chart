require 'do_sqlite3'
require 'dm-do-adapter'

module DataMapper
  module Adapters

    class SqliteAdapter < DataObjectsAdapter

      def initialize(name, options)
        super(name, normalize_options(options))
      end

      # @api private
      def supports_subquery?(query, source_key, target_key, qualify)
        # SQLite3 cannot match a subquery against more than one column
        source_key.size == 1 && target_key.size == 1
      end

      def normalize_options(options)
        # TODO Once do_sqlite3 accepts both a Pathname or a String,
        # normalizing database and path won't be necessary anymore
        # Clean out all the 'path-like' parameters in the options hash
        # ensuring there can only be one.
        # Also make sure a blank value can't possibly mask a non-blank one
        path = nil
        [:path, 'path', :database, 'database'].each do |key|
          db = options.delete(key)
          unless db.nil?
            normalized_db = db.to_s # no Symbol#empty? on 1.8.7(ish) rubies
            path ||= normalized_db unless normalized_db.empty?
          end
        end

        options.update(:adapter => 'sqlite3', :path => path)
      end

    end

    const_added(:SqliteAdapter)

  end
end
