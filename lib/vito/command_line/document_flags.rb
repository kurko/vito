module Vito
  module CommandLine
    module DocumentFlags
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        @@flags        ||= []
        @@descriptions ||= []

        def flags
          @@flags
        end

        def descriptions
          @@descriptions
        end

        def flag(flag)
          @@flags << flag
        end

        def desc(description)
          @@descriptions << description
        end
      end
    end
  end
end
