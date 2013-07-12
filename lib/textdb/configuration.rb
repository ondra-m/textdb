module Textdb
  class Configuration

    def initialize(config)
      config.each do |key, value|
        eval <<-METHOD
          def #{key}(value = nil, &block)
            if block_given?
              @#{key}.instance_eval(&block)
            end

            if value.nil?
              if @#{key}.is_a?(Proc)
                return @#{key}.call
              end
              return @#{key}
            end

            self.#{key} = value
          end

          def #{key}=(value)
            Textdb.rebuild
            @#{key} = value
          end
        METHOD

        self.send("#{key}=", value)
      end
    end
    
  end
end
