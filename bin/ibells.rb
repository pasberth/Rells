#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'bells'
require 'readline'
require 'stringio'

buf = StringIO.new
lex = Bells::Syntax::Lexer.new buf
global = Bells::Runtime::Global.new
global.require 'bells/lang'
beg = 0
while (line = Readline.readline 'bells> ')
  buf.puts "\n#{line}"
  next if line  !~ /\A\s*\z/
  buf.seek beg
  while node = lex.token
    result = global.eval node
    puts "# => #{result.env[:to_s].eval}"
  end
  beg = buf.pos
end