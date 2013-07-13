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
        METHOD

        if value.is_a?(Array)
          eval <<-METHOD
            def #{key}=(value)
              @#{key} = value
              #{value[1]}
              value
            end
          METHOD
          
          instance_variable_set :"@#{key}", value[0]
        else
          eval <<-METHOD
            def #{key}=(value)
              @#{key} = value
            end
          METHOD
          
          instance_variable_set :"@#{key}", value
        end

      end



    end
    
  end
end
