class CalculateService
  SPACE = ' '.freeze

  MATH_SYMBOLS = %w[
    0 1 2 3 4 5 6 7 8 9
    + - * : / ^
    ( )
  ].freeze

  ALLOWED_SYMBOLS = MATH_SYMBOLS + [SPACE]

  FILTERED_MATH = '**'.freeze

  TO_RUBY_MATH = {
    ':' => '/',
    '^' => '**'
  }.freeze

  def self.calculate!(query)
    calc = new query

    calc.send :calculate! if calc.allowed?
  end

  def initialize(query)
    @query = query
  end

  def allowed?
    safe? and not filtered_math?
  end

  private

  def safe?
    (@query.split('') - ALLOWED_SYMBOLS).empty?
  end

  def filtered_math?
    /#{Regexp.quote(FILTERED_MATH)}/.match(@query)
  end

  def calculate!
    begin
      result = eval adapted_query

      beautify(result)
    rescue StandardError, SyntaxError
      nil
    end
  end

  def beautify(result)
    (result - result.to_i).zero? ? result.to_i : result
  end

  def adapted_query
    all_integer_numbers_are_float!
    to_ruby_math!

    @query
  end

  def all_integer_numbers_are_float!
    @query.gsub!(/([^\.])(\d+)([^\.])/, '\1\2.0\3')
  end

  def to_ruby_math!
    for query_sym, ruby_sym in TO_RUBY_MATH
      @query.gsub!(/#{Regexp.quote(query_sym)}/, ruby_sym)
    end
  end
end
