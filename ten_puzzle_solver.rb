# ruby ten_puzzle_solver.rb 1 2 3 4
arg = ARGV.map(&:to_i)

TARGET = 10
OPERATORS = %w[+ - * /]

def is_operator?(char)
  OPERATORS.include?(char)
end

# calc_poland("12+3+4*")
# => 24
def calc_poland(poland_str)
  stack = []
  poland_str.split('').each do |c|
    if is_operator?(c)
      # 順番大事
      second = stack.pop.to_f
      first = stack.pop.to_f

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

# decode_poland("12+3+4*")
# => (1+2+3)*4
def decode_poland(poland_str)
  space = []
  poland_str.split('').each do |c|
    if is_operator?(c)
      second = space.pop
      first = space.pop

      if ["*", "/"].include?(c)
        first = first.size > 1 ? "("+first+")" : first
        second = second.size > 1 ? "("+second+")" : second
      end

      result = first + c + second
      space << result
    else
      space << c
    end
  end

  space.join
end

def polands(numbers)
  raise ArgumentError.new("numbers must be just four numbers, but input is #{numbers}") unless numbers.size == 4
  polands = []
  number_permutations = numbers.permutation.to_a
  operator_permutations = OPERATORS.repeated_permutation(3).to_a

  number_permutations.each do |nums|
    operator_permutations.each do |ops|
      polands << [nums[0], nums[1], nums[2], nums[3], ops[0], ops[1], ops[2]].join
      polands << [nums[0], nums[1], nums[2], ops[0], nums[3], ops[1], ops[2]].join
      polands << [nums[0], nums[1], nums[2], ops[0], ops[1], nums[3], ops[2]].join
      polands << [nums[0], nums[1], ops[0], nums[2], nums[3], ops[1], ops[2]].join
      polands << [nums[0], nums[1], ops[0], nums[2], ops[1], nums[3], ops[2]].join
    end
  end

  polands.uniq
end

def solve(arg)
  results = []
  polands(arg).each do |poland|
    results << decode_poland(poland) if (calc_poland(poland) - TARGET).abs < Float::MIN
  rescue ZeroDivisionError
  end
  results
end

puts solve(arg)
