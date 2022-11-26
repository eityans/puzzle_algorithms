# ruby ten_puzzle_solver.rb 1 2 3 4
arg = ARGV.map(&:to_i)

OPERATORS = %w[+ - * /]

def is_operator?(char)
  OPERATORS.include?(char)
end

# calc_poland("12+3+4*")
def calc_poland(poland_str)
  stack = []
  poland_str.split('').each do |c|
    if is_operator?(c)
      # 順番大事
      second = stack.pop
      first = stack.pop

      result = case c
        in "+"
          first + second
        in "-"
          first - second
        in "*"
          first * second
        in "/"
          first / second
      end

      stack << result
    else
      stack << c.to_i
    end
  end
  stack.first
end

pp calc_poland("12+3+4*")
