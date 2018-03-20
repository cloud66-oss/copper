module Copper
  class CopperError < StandardError; end
  class ParseError < CopperError; end
  class RuntimeError < CopperError; end
end
