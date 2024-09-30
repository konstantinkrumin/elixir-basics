@doc """
    Если из конструкции case убрать шаблоны, но оставить охранные выражения, то получится 
    конструкция cond.

    Было:
"""

case Expr do
  Pattern1 [when GuardSequence1] ->
      Body1
  ...
  PatternN [when GuardSequenceN] ->
      BodyN
end

# Стало:

cond do
  GuardSequence1 ->
      Body1
  ...
  GuardSequenceN ->
      BodyN
end

@doc """
    В принципе, это эквивалент цепочки if...else if, которая нередко встречается в 
    императивных языках. Python, например:

    a = int(input())
    if a < -5:
        print('Low')
    elif -5 <= a <= 5:
        print('Mid')
    else:
        print('High')

    Как и в конструкции case, очередность выражений важна. И если ни одно из выражений не 
    вычислилось в true, то возникает исключение.
"""

def my_fun(num) do
  cond do
    num > 10 -> IO.puts("more than 10")
    num > 5 -> IO.puts("more than 5")
  end
end

my_fun(20) # => more than 10
my_fun(8) # => more than 5
my_fun(3) # ** (CondClauseError) no cond clause evaluated to a truthy value

# В Эликсир есть привычная всем конструкция if:

def gcd(a, b) do
  if rem(a, b) == 0 do
    b
  else
    gcd(b, c)
  end
end

@doc """
    Только это не настоящая конструкция языка, а макрос. Впрочем, в Эликсир очень многое является макросами. 
    В некоторых случаях это важно знать, в некоторых не важно.

    Есть и конструкция unless, тоже макрос:
"""

def gcd(a, b) do
  unless rem(a, b) != 0 do
    b
  else
    gcd(b, c)
  end
end

# Есть важное отличие от императивных языков -- в функциональных языках if всегда возвращает какое-то значение.

a = 5
b = 10
c = if a > b do
  a
  else
  b
end

IO.puts(c)
# => 10

@doc """
    Некоторые функциональные языки требуют, чтобы часть else всегда присутствовала, потому что значение нужно вернуть 
    в любом случае, выполняется условие if или не выполняется. Эликсир этого не требует:
"""
c = if a > b do
  a
end

IO.puts(c) # => nil

###### ASSIGNMENT ######
@doc """
    Реализовать функцию single_win?(a_win, b_win), которая принимает 2 булевых параметра: a_win -- победил ли игрок A, 
    и b_win -- победил ли игрок B. Функция возвращает true если победил только один из двоих игроков, иначе 
    возвращает false.

    Реализовать функцию double_win?(a_win, b_win, c_win), которая принимает 3 булевых параметра для трех игроков. 
    Если победили игроки A и B, то функция возвращает атом :ab. Если победили игроки A и C, то функция возвращает 
    атом :ac, если победили игроки B и C, то функция возвращает атом :bc. Во всех остальных случаях функция 
    возвращает false.

    Solution.single_win?(true, false)
    # => true
    Solution.single_win?(false, true)
    # => true
    Solution.single_win?(true, true)
    # => false

    Solution.double_win?(true, true, false)
    # => :ab
    Solution.double_win?(true, false, true)
    # => :ac
    Solution.double_win?(true, true, true)
    # => false
    Solution.double_win?(true, false, false)
    # => false
"""

defmodule Solution do
    def single_win?(a_win, b_win) do
        cond do
            a_win and not b_win -> true
            b_win and not a_win -> true
            true -> false
        end
    end

    def double_win?(a_win, b_win, c_win) do
        cond do
            a_win and b_win and not c_win -> :ab
            a_win and c_win and not b_win -> :ac
            b_win and c_win and not a_win -> :bc
            true -> false  # If all three are true, return false
        end
    end
end
