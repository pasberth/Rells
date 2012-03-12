#!/usr/bin/env ruby

require 'pry'
require 'pry-stack_explorer'

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'bells'
require 'bells/interpreter'

Bells::Interpreter.bells *ARGV
