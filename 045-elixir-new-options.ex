@doc """
    Макросы позволяют добавлять в язык новые команды, как в предыдущем упражнении:
"""
defmodule Solution do
  defmacro my_unless(condition, do: expression) do
    quote do
      if(!unquote(condition), do: unquote(expression))
    end
  end
end

@doc """
    На самом деле, в Elixir все конструкции имеют внутреннее представление, даже функции. Это означает, что с помощью макроса можно сгенерировать функцию:
"""
defmodule Exercise do
  defmacro create_multiplier(fn_name, factor) do
    quote do
      def unquote(fn_name)(value) do
        unquote(factor) * value
      end
    end
  end
end

@doc """
    Чтобы воспользоваться этим макросом, нужно создать другой модуль, так как определение функции доступно только внутри модуля:
"""
defmodule MyModule do
  require Exercise

  Exercise.create_multiplier(:double, 2)
  Exercise.create_multiplier(:triple, 3)

  def run_example() do
    x = double(2)
    IO.puts("Two times 2 is #{x}")
  end
end

MyModule.double(5)
# => 10
MyModule.triple(3)
# => 9
MyModule.run_example()
# => Two times 2 is 4

@doc """
    Создадим универсальный макрос, который за один вызов создает нужное количество функций:
"""
defmodule Exercise do
  defmacro create_functions(fn_list) do
    Enum.map(fn_list, fn {name, factor} ->
      quote do
        def unquote(:"#{name}_value")(value) do
          unquote(factor) * value
        end
      end
    end)
  end
end

@doc """
    И теперь опробуем макрос в новом модуле:
"""
defmodule Example do
  require Exercise

  Exercise.create_functions([{:double, 2}, {:triple, 3}, {:nullify, 0}])
end

Example.double_value(2)
# => 4
Example.triple_value(2)
# => 6
Example.nullify_value(2)
# => 0

@doc """
    Если нужно создать макрос только внутри модуля, то defmacrop то что нужно. Как и приватные функции, макрос объявленный таким образом, будет доступен 
    только в модуле, где макрос объявлен и только во время компиляции.
"""

###### ASSIGNMENT ######
@doc """
    Создайте макрос prohibit_words, генерирующий функцию forbidden?, в который передается список запрещенных слов и проверяется, запрещено ли слово, 
    переданное в функцию forbidden?. Если передано не слово, то функция возвращает false:

    defmodule Exercise
    require Solution

    Solution.prohibit_words(["hello", "world", "foo"])
    end

    Exercise.forbidden?("hello")
    # => true
    Exercise.forbidden?("test")
    # => false
    Exercise.forbidden?(1)
    # => false
    Exercise.forbidden?(%{hello: :world})
    # => false
"""
defmodule Solution do
  defmacro prohibit_words(words) do
    quote do
        def forbidden?(word) when is_binary(word) do
            unquote(words)
            |> Enum.member?(word)
        end

        def forbidden?(_), do: false
    end
  end
end

# ALTERNATIVE SOLUTION
defmodule Solution do
  defmacro prohibit_words(words) do
    quote do
      def forbidden?(word) when is_bitstring(word) do
        word in unquote(words)
      end

      def forbidden?(_), do: false
    end
  end
end