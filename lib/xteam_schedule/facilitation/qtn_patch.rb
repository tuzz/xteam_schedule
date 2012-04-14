# Fixes dynamic find by method attempting to use the connection
# on ActiveRecord::Base in activerecord versions 3.1.0 to 3.2.2
# when it should be respecting the connection on its subclass
class QuoteTableNamePatch
  def self.quote_table_name(name)
    name
  end
end

module ActiveRecord
  module Associations
    class AliasTracker
      private
      def connection
        ActiveRecord::Base.connection
      rescue ActiveRecord::ConnectionNotEstablished
        QuoteTableNamePatch
      end
    end
  end
end
