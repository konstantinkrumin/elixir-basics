@doc """
    Помимо именованных функций, можно создавать анонимные в форме fn (x) -> fn_body end, важно отметить, что для вызова таких функций нужно дописать 
    перед скобками точку .. Рассмотрим примеры:
"""
sum = fn (x, y) -> x + y end
sum.(2, 3) # => 5

magic = fn (a, b, c) -> (a + b) * c end
magic.(2, 3, 4) # => 20

@doc """
    Так как функции в эликсире являются объектами первого класса, то часто приходится писать анонимные функции, которые передаются в другие функции и 
    для сокращения записи таких функций используется оператор &:
"""
mul = &(&1 * &2)
mul.(3, 3) # => 9

magic = &((&1 + &2 + &3) * &4)
magic.(1, 2, 3, 4) # => 24

more_magic = &(&1.(&2))
increment = &(&1 + 1)
more_magic.(increment, 10) # => 11

double = &(&1 * &1)
more_magic.(double, 5) # => 25

@doc """
    При использовании сокращенного синтаксиса для анонимных функций следует быть аккуратным, так как при большом количестве аргументов можно легко 
    запутаться с их порядком, особенно, если в функции есть сложная логика.
"""

###### ASSIGNMENT ######
@doc """
    Даны два целых числа. Создайте простой калькулятор, который поддерживает следующие операции: сложение, вычитание, деление, умножение.

    Solution.calculate("+", 2, 3)  # => 5
    Solution.calculate("+", 0, -3) # => -3
    Solution.calculate("-", 2, 3) # => -1
    Solution.calculate("-", 0, 3) # => -3
    Solution.calculate("/", 4, 4) # => 1.0
    Solution.calculate("/", 3, 2) # => 1.5
    Solution.calculate("*", 2, 2) # => 4
    Solution.calculate("*", 0, 2) # => 0
"""
defmodule Solution do
  def calculate(op, num1, num2) do
    ops = %{
        "+" => fn a,b -> a + b end,
        "-" => fn a,b -> a - b end,
        "*" => fn a,b -> a * b end,
        "/" => fn a,b -> a / b end
    }

    f = ops[op]
    f.(num1, num2)
  end
end

# OR

defmodule Solution do
  @operations %{"+" => &(&1 + &2), "-" => &(&1 - &2), "*" => &(&1 * &2), "/" => &(&1 / &2)}

  def calculate(operation, arg1, arg2) do
    Map.get(@operations, operation).(arg1, arg2)
  end
end