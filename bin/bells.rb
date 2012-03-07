#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__) + '/../lib'
require 'bells'
require 'bells/interpreter'

Bells::Interpreter.bells ARGV