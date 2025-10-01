@doc """
    Так как язык Эликсир является функциональным языком программирования, то в большинстве случаев списки обрабатываются 'классической' тройкой функций map, 
    filter, reduce. Рассмотрим первую функцию map, которая переводится как 'отображение', что полностью отражает суть выполняемой операции:
"""
numbers = [1, 2, 3, 4]

doubled_numbers = Enum.map(numbers, fn (x) -> x * 2 end)
IO.puts(doubled_numbers) # => [2, 4, 6, 8]

users = [%{name: "Igor"}, %{name: "John"}, %{name: "Alice"}, %{name: "Isabella"}]

names = Enum.map(users, &(&1[:name]))
IO.puts(names) # => ["Igor", "John", "Alice", "Isabella"]

# либо с помощью паттерн-матчинга
names = Enum.map(users, fn %{name: name} -> name end)
IO.puts(names) # => ["Igor", "John", "Alice", "Isabella"]

@doc """
    Важно понимать, что при обработке переданного в функцию map списка, создается новый список, а не мутируется исходный, так как язык является иммутабельным. 
    Внутри переданной функции над элементом списка могут выполняться какие-угодно вычисления, однако итоговый список всегда будет такого же размера, 
    как и исходный:
"""
numbers = [1, 2, 3]

incremented_numbers = Enum.map(numbers, fn (x) -> x + 1 end)

IO.puts(numbers) # => [1, 2, 3]
IO.puts(incremented_numbers) # => [2, 3, 4]

stringified = Enum.map(numbers, fn (x) -> "Number: #{x}" end)
IO.puts(stringified) # => ["Number: 1", "Number: 2", "Number: 3"]

@doc """
    Так как функция map ожидает первым аргументом список, то мы можем с помощью оператора |> комбинировать несколько преобразований подряд:
"""
numbers = [1, 2, 3, 4]

result =
  numbers
  |> Enum.map(fn (x) -> x + 1 end)
  |> Enum.map(fn (x) -> x * 5 end)
  |> Enum.map(fn (x) -> x / 2 end)
  |> Enum.map(&Float.round/1)

IO.puts(result) # => [5.0, 8.0, 10.0, 13.0]

###### ASSIGNMENT ######
@doc """
    Реализуйте функцию zip, которая группирует элементы переданных векторов в подвектора. Если вектора отличаются длиной, то вместо сгруппированного элемента 
    оставьте nil. Для обращения к элементу списка по индексу используйте Enum.at. Примеры:

    Solution.zip([], [])
    # => []
    Solution.zip([1, 2, 3, 4], [5, 6, 7, 8])
    # => [[1, 5], [2, 6], [3, 7], [4, 8]]
    Solution.zip([1, 2], [3, 4])
    # => [[1, 3], [2, 4]]
    Solution.zip([1, 2], [3])
    # => [[1, 3], [2, nil]]
    Solution.zip([1], [3, 4])
    # => [[1, 3], [nil, 4]]
"""
defmodule Solution do
  def zip(list1, list2) do
    len = max(length(list1), length(list2))

    if len == 0 do
        []
    else
        for i <- 0..(len - 1) do
            [Enum.at(list1, i), Enum.at(list2, i)]
        end
    end
  end
end

# ALTERNATIVE SOLUTION
defmodule Solution do
  def zip([], []), do: []

  def zip(first, second) do
    len = max(length(first), length(second))
    range = 0..(len - 1)

    Enum.map(range, fn index ->
      [Enum.at(first, index), Enum.at(second, index)]
    end)
  end
end