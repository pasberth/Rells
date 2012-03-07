class PasParse::Lexer
  
  class Unexpected < StandardError; end
  
  def self.state_attr_reader *as
    self.state_attrs += as
    attr_reader *as
  end

  def self.state_attr_writer *as
    self.state_attrs += as
    attr_writer *as
  end

  def self.state_attr_accessor *as
    self.state_attrs += as
    attr_accessor *as
  end
  
  def self.state_attrs
    @state_attrs ||= []
  end
  
  def self.state_attrs= v
    @state_attrs = v
  end
  
  def state_attrs
    Hash[*self.class.state_attrs.flat_map { |a| [a, ((v = send(a)).clone rescue v)] }]
  end
  
  def initialize input
    @input = input
  end
  
  def touch! *a, &b
    begin
      touch *a, &b
    rescue Unexpected
      nil
    end
  end

  def touch *a, &b
    r = expect! *a, &b
    @input.seek -expected.bytes.count, IO::SEEK_CUR
    r
  end
    
  # :call-seq:
  #   expect!(expected=nil, &combinator)
  def expect! *a, &b
    begin
      expect *a, &b
    rescue Unexpected
      nil
    end
  end
  
  # :call-seq:
  #   expect(expected=nil, &combinator)
  def expect *a
    if a.empty?
      return try { yield }
    end
    
    expected = a.shift
    string = ""
    case expected
    when String
      while expected[string]
        return string if string == expected
        s = @input.getc
        if s
          string << s
        else
          break
        end
      end

    when Regexp

      while s = @input.getc
        string << s
        next if string[/\A#{expected}\z/]

        string.sub! /(.|\n)\z/, ''
        if $1
          @input.seek -$1.bytes.count, IO::SEEK_CUR
        end
        break
      end

      if string.empty?
        raise Unexpected
      else
        return string
      end
    end
    @input.seek -string.bytes.count, IO::SEEK_CUR
    raise Unexpected
  end
  
  def many *a, &b
    xs = []
    while x = expect!(*a, &b)
      xs << x
    end
    xs
  end
  
  def many1 *a, &b
    [] << expect(*a, &b) << many(*a, &b)
  end
  
  # :call-seq:
  #   between(open, close, expected=nil, &compinator)
  def between open, close, *a, &b
    expect open
    xs = expect(*a, &b)
    expect close
    xs
  end
  
  def try
    pos = @input.pos
    original = state_attrs.clone
    begin
      yield
    rescue Unexpected
      @input.seek pos
      original.each { |a, v| send(:"#{a}=", v) }
      nil
    end
  end
end