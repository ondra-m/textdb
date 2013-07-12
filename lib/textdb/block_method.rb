module Textdb
  class BlockMethod

    instance_methods.each do |meth| 
      undef_method(meth) unless meth =~ /\A__/ || meth == :object_id || meth == :instance_eval
    end

    attr_reader :methods_seq

    def self.get(&block)
      begin
        Textdb::BlockMethod.new.instance_eval(&block).methods_seq
      rescue NoMethodError
        []
      end
    end

    def initialize
      @methods_seq = []
    end

    def method_missing(method, *args, &block)
      @methods_seq << method.to_s
      self
    end
    
  end
end
