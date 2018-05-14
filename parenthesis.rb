require 'pry'

class Parenthesis
  OPENING_BRACES = ['(', '{', '[']
  CLOSING_BRACES = [')', '}', ']']
  MATCHERS = [
    /[\(].*[\)]/,
    /[\{].*[\}]/,
    /[\[].*[\]]/
  ]

  def check(string, *rest)
    [string, rest].flatten.map { |e| puts valid? e }
  end

  def valid?(string)
    opened = []
    closed = []

    string.each_char do |c|
      opened.push(c) if OPENING_BRACES.include? c
      closed.push(c) if CLOSING_BRACES.include? c
    end

    return false if opened.length != closed.length

    split(string)
  end

  def split(string)
    return true if string.length == 0
    contains_opening_braces = string.length != (string.split('') - OPENING_BRACES).length
    contains_closing_braces = string.length != (string.split('') - CLOSING_BRACES).length
    return true unless contains_opening_braces || contains_closing_braces

    invalid = false
    count = 0

    invalid = MATCHERS.map do |matcher|
      matches = string.match(matcher).to_a
      count += matches.length
      matches.map { |m| split(m[1..-2]) }
    end.flatten.include? false

    return false if count == 0
    return true unless invalid
    false
  end
end

if $0 == __FILE__
  raise ArgumentError, "Usage: #{$0} 'strings' 'to' 'check'" unless ARGV.length > 0
  Parenthesis.new.check(*ARGV)
end
