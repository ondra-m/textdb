module Textdb
  
  class ExistError < StandardError
  end

  class UpdateOnKey < StandardError
  end

  class ValueCannotBeKey < StandardError
  end

  class BlockRequired < StandardError
  end

end
