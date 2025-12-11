@doc """
    При создании макросов важно соблюдать их гигиену, так как макросы, которые модифицируют окружение, могут сильно навредить. Негигиеничные макросы еще 
    сложнее понимать и отлаживать, потому что они меняют окружение, в котором исполняется код. Для устранения таких проблем в разных языках добавлены 
    специальные возможности по упрощению создания гигиеничных макросов, Elixir, в том числе.

    По умолчанию, в Elixir макросы гигиеничны, поэтому можно не переживать за контекст, в котором макрос используется:
"""
defmodule Example do
  defmacro no_interference do
    quote do: a = 1
  end
end

defmodule HygieneTest do
  def run() do
    require Example
    a = 13
    Example.no_interference()
    a
  end
end

HygieneTest.run()
# => 13

@doc """
    В примере выше, макрос не перезаписывает a, происходит это потому, что Elixir аннотирует переменные контекстом, в котором они объявлены:
"""
defmodule Sample do
  def quoted do
    quote do: x
  end
end

Sample.quoted()
#=> {:x, [line: 3], Sample}

@doc """
    Благодаря аннотации, Elixir понимает к какому контексту переменные принадлежат.

    В очень редких случаях, когда иначе никак, макрос можно сделать негигиеничным, например с помощью var!:
"""
defmodule Example do
  defmacro interference do
    quote do: var!(a) = 1
  end
end

defmodule HygieneTest do
  def run() do
    require Example
    a = 13
    Example.interference()
    a
  end
end

HygieneTest.run()
# => 1

@doc """
    Так делать можно только в исключительных случаях, будьте крайне осторожны.

    Иногда, нужно динамически объявить переменную, тогда воспользуемся var:
"""
defmodule Exercise do
  defmacro initialize_to_char_count(variables) do
    Enum.map(variables, fn name ->
      var = Macro.var(name, nil)
      length = name |> Atom.to_string |> String.length

      quote do
        unquote(var) = unquote(length)
      end
    end)
  end

  def run do
    initialize_to_char_count [:red, :green, :yellow]
    [red, green, yellow]
  end
end

Exercise.run()
# => [3, 4, 5]

@doc """
    Обратите внимание, что передается вторым аргументом в var. Это контекст объявления переменной, благодаря которому пересечения переменных не произойдет, 
    если они были объявлены ранее.

    Есть магическая структура __ENV__, которая хранит всю информацию о скомпилированном окружении, включая модули, файлы, переменные, импорты и так далее:
"""
__ENV__.module
# => nil

__ENV__.file
# => "iex"

__ENV__.requires
# => [Application, Exercise, IEx.Helpers, Kernel, Kernel.Typespec, Solution]

require Integer
__ENV__.requires
# => [Application, Exercise, IEx.Helpers, Integer, Kernel, Kernel.Typespec, Solution]

@doc """
    Большинство функций, которые используются в модуле Macro, взаимодействуют с этим окружением.
"""

###### ASSIGNMENT ######
@doc """
    Создайте макрос with_logging, который принимает функцию, логгирует результат выполнения и возвращает результат. Примеры использования:

    defmodule Exercise
        require Solution

        def run_fn(function) do
            Solution.with_logging do
            function
            end
        end
    end

    Exercise.run_fn(fn -> 1 + 5 end)
    # => Started execution...
    # => Execution result is: 6
    # => 6


    Exercise.run_fn(fn -> %{hello: :world} end)
    # => Started execution...
    # => Execution result is: %{hello: :world}
    # => %{hello: :world}
"""
defmodule Solution do
    defmacro with_logging(do: block) do
        quote do
            IO.puts("Started execution...")

            result = unquote(block).()

            IO.puts("Execution result is: #{inspect(result)}")

            result
        end
    end
end