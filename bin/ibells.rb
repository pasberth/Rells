#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'bells'
require 'readline'
require 'stringio'

buf = StringIO.new
lex = Bells::Syntax::Lexer.new buf
env = Bells::Runtime::Global.new
env.bells_require 'bells/lang'
beg = 0
while (line = Readline.readline 'bells> ')
  buf.puts "\n#{line}"
  next if line  !~ /\A\s*\z/
  buf.seek beg
  while node = lex.token
    result = env.bells_eval node
    p result
    puts "# => #{result.bells_env[:to_s].bells_eval}"
  end
  beg = buf.pos
end