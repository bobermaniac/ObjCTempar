#! /usr/bin/ruby

require 'rubygems'
require 'treetop'
require 'liquid'
require 'optparse'
require_relative 'objc'
require_relative 'scribe'
require_relative 'AST/scribe'

parameters = { :source => [], :destination => Dir.pwd }

OptionParser.new do |opts|
  opts.banner = "Usage: objctemplar [options]"
  opts.on('-s [ARG]', '--source [ARG]', "Source files (could be multiple)") do |v|
    parameters[:source] += [ v ]
  end
  opts.on('-d [ARG]', '--destination [ARG]', "Destination folder (default = working directory)") do |v|
    parameters[:destination] = v
  end
  opts.on('--version', 'Display the version') do
    puts "objctemplar version 0.1a"
    exit
  end
  opts.on('-h', '--help', 'Display this help') do
    puts opts
    exit
  end
end.parse!

def sanitize(input)
  input.gsub!(/\/\/[^\n]*\n/, ' ')
  input.gsub!(/\/\*.*?\*\//, ' ')
  input
end

header_template = Liquid::Template.parse(IO.read 'src/objc_header.template')
source_template = Liquid::Template.parse(IO.read 'src/objc_source.template')

parser_class = Treetop.load 'src/objc_grammar'
parser = parser_class.new

results = parameters[:source].map do |s|
  result = parser.parse(sanitize IO.read s)
  abort "Error processing file #{s}: #{parser.failure_reason}" if result.nil?
  result
end

if results.include? nil
  abort parser.failure_reason
else
  Scribe.default_interfaces = {
      'foundation' => '<Foundation/Foundation.h>',
      'tracking' => { 'protocol' => 'SCTrackChanges', 'in' => '"SCTrackChanges.h"' },
      'tracker' => { 'class' => 'SCPropertyChangesTracker', 'protocol' => { 'ext' => 'SCTracker', 'int' => 'SCTracking' }, 'in' => '"SCPropertyChangesTracker.h"'},
      'validator' => { 'protocol' => 'SCValidator', 'in' => '"SCValidator.h"'},
      'immutable copy' => { 'protocol' => 'SCImmutableCopying', 'in' => '"SCImmutableCopying.h"', 'helper' => '"SCImmutableCopyingHelpers.h"' }
  }
  classes = Scribe.to_objc results
  abort '[ERROR] Validation failed for class graph. Please check messages above and fix all problems' unless Scribe.validate_classes classes

  for cls in classes
    other_classes = classes.reject { |c| c == cls }
    File.open("#{parameters[:destination]}/#{cls.name}.h", 'w') do |header|
      header.write(header_template.render 'class' => cls,
                                          'other_classes' => other_classes.map { |cls| cls.name },
                                          'interfaces' => Scribe.default_interfaces )
    end
    File.open("#{parameters[:destination]}/#{cls.name}.m", 'w') do |source|
      source.write(source_template.render 'class' => cls,
                                          'other_classes' => other_classes.map { |cls| cls.name },
                                          'interfaces' => Scribe.default_interfaces)
    end
  end
end