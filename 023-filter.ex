@doc """
    Функция map может менять элементы списка, но не может менять их количество: сколько элементов было в исходном списке, столько же останется. 
    Функция filter же, напротив, не может менять сами элементы, но может решать, какие из них попадут в выходной список, а какие будут отброшены.
"""
numbers = [12, 2, 30, 4, 55, 10, 11]

result = Enum.filter(numbers, fn (x) -> x >= 10 end)
IO.puts(result) # => [12, 30, 55, 10, 11]

result =
  numbers
  |> Enum.filter(fn (x) -> x < 20 end)
  |> Enum.filter(fn (x) -> rem(x, 2) == 0 end)
  |> IO.puts() # => [12, 2, 4, 10]

users = [%{name: "Igor", age: 21}, %{name: "John", age: 13}, %{name: "Alice", age: 20}, %{name: "Isabella", age: 13}]

result = Enum.filter(users, fn %{age: age} -> age < 15 end)
IO.puts(result) # => [%{age: 13, name: "John"}, %{age: 13, name: "Isabella"}]

result = Enum.filter(users, &(String.starts_with?(&1[:name], "Al")))
IO.puts(result) # => [%{age: 20, name: "Alice"}]

###### ASSIGNMENT ######
@doc """
    Реализуйте функцию inc_numbers, которая берёт из переданного списка значения, являющиеся числами is_number и возвращает список этих чисел, увеличив 
    каждое число на единицу. Примеры:

    Solution.inc_numbers(["foo", false, ["foo"]])
    # => []
    Solution.inc_numbers([10, "foo", false, true, ["foo"], 1.2, %{}, 32])
    # => [11, 2.2, 33]
    Solution.inc_numbers([1, 2, 3, 4, 5, 6.0])
    # => [2, 3, 4, 5, 6, 7.0]
"""
defmodule Solution do
  def inc_numbers(list) do
    list
        |> Enum.filter(fn (x) -> is_number(x) end)
        |> Enum.map(fn (x) -> x + 1 end)
  end
end

# ALTERNATIVE SOLUTION
defmodule Solution do
  def inc_numbers(elements) do
    elements
    |> Enum.filter(&is_number/1)
    |> Enum.map(&(&1 + 1))
  end
end