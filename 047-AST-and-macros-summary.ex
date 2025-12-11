@doc """
    В Elixir есть функции, упрощающих работу с абстрактным синтаксическим деревом (АСТ) языка. Например:
"""
module = """
  defmodule Example do
    def sum(a, b) do
      a + b
    end
  end
"""

{:ok, result} = Code.string_to_quoted(module)
result
# => {:defmodule, [line: 1],
# =>   [
# =>     {:__aliases__, [line: 1], [:Example]},
# =>     [
# =>       do: {:def, [line: 2],
# =>         [
# =>           {:sum, [line: 2], [{:a, [line: 2], nil}, {:b, [line: 2], nil}]},
# =>           [do: {:+, [line: 3], [{:a, [line: 3], nil}, {:b, [line: 3], nil}]}]
# =>         ]}
# =>   ]
# => ]}

quoted = quote do: 1 + 2

quoted |> Macro.to_string |> IO.puts
# => 1 + 2
# => :ok

quoted_pipe = quote do: 100 |> div(10) |> div(5)
Macro.unpipe(quoted_pipe)
# => [
# =>   {100, 0},
# =>   {{:div, [context: Elixir, imports: [{2, Kernel}]], [10]}, 0},
# =>   {{:div, [context: Elixir, imports: [{2, Kernel}]], [5]}, 0}
# => ]

@doc """
    Теперь подведем итоги модуля. Мы рассмотрели, как с помощью макросов можно расширять возможности языка и напрямую работать с АСТ.

    Однако, в большинстве случаев прибегать к макросам является плохой затеей:

    - Макросы сложнее понимать;
    - Макросы сложнее отлаживать;
    - Макросы притягивают макросы, то есть приходится писать дополнительные обвязки-макросы.

    Перед тем как написать, задумайтесь, есть ли возможность решить задачу с помощью функции? Ответ на этот вопрос почти всегда будет - да.

    Хоть Elixir помогает и одновременно ограничивает разработчиков, например:

    - Макросы по умолчанию гигиеничны;
    - Макросы не дают возможности глобально внедрять произвольный код, то есть необходимо напрямую в конкретном модуле вызвать require или import нужного макроса;
    - Использование макросов в коде явно, поэтому неожиданного поведения, как например, полного переопределения функции, за спиной у разработчика не происходит;
    - Использование явных quote и unqoute тоже упрощает понимание макроса, так как сразу видно, что будет выполнено сразу, а что потом.
    
    Но даже эти механизмы не снимают ответственность с разработчика за написанный им код, пишите макросы ответственно и вдумчиво, и только если в 
    этом есть острая необходимость!
"""

###### ASSIGNMENT ######
@doc """
    Создайте функцию collect_module_stats принимающую строку, в которой определяется модуль и функции модуля, а затем подсчитывается статистика по функциям, 
    определенные внутри модуля.

    Для начала, изучите функцию string_to_quoted модуля Code и функцию prewalk из модуля Macro. Формат собираемой статистики представлен в примерах:
"""
new_module = """
  defmodule MyModule do

  end
"""

Solution.collect_module_stats(new_module)
# => []

new_module = """
  defmodule MyModule do
    def hello() do
      "world"
    end
  end
"""

Solution.collect_module_stats(new_module)
# => [%{arity: 0, name: :hello}]

new_module = """
  defmodule MyModule do
    def hello() do
      "world"
    end

    defp test(a, b) do
      a + b
    end
  end
"""

Solution.collect_module_stats(new_module)
# => [%{arity: 2, name: :test}, %{arity: 0, name: :hello}]

new_module = """
  defmodule MyModule do
    def hello(string) do
      [string, "world"]
    end

    def magic(a, b, c) do
      (a + b) * c
    end

    defp test(a, b) do
      a + b
    end
  end
"""

Solution.collect_module_stats(new_module)
# => [%{arity: 2, name: :test}, %{arity: 3, name: :magic}, %{arity: 1, name: :hello}]

defmodule Solution do
  def collect_module_stats(str) do
    {:ok, ast} = Code.string_to_quoted(str)

    {_ast, functions} =
      Macro.prewalk(ast, [], fn
        {:def, _, [{name, _, args_ast} | _]} = node, acc ->
          arity = count_args(args_ast)
          {node, [%{name: name, arity: arity} | acc]}

        {:defp, _, [{name, _, args_ast} | _]} = node, acc ->
          arity = count_args(args_ast)
          {node, [%{name: name, arity: arity} | acc]}

        node, acc ->
          {node, acc}
      end)

    # Сортируем в обратном алфавитном порядке по имени, как ожидают тесты
    Enum.sort_by(functions, & &1.name, :desc)
  end

  defp count_args(nil), do: 0
  defp count_args(args) when is_list(args), do: length(args)
end

# ALTERNATIVE SOLUTION
defmodule Solution do
  def to_ast(string) do
    {_, result} = Code.string_to_quoted(string)
    result
  end

  def collect_fn_and_arity({op, _, args} = ast, acc) when op in [:def, :defp] do
    {fn_name, fn_args} = get_fn_name_and_args(args)
    arity = length(fn_args)

    {ast, [%{name: fn_name, arity: arity} | acc]}
  end

  def collect_fn_and_arity(ast, acc) do
    {ast, acc}
  end

  defp get_fn_name_and_args(def_args) do
    case def_args do
      [{:when, _, args} | _] -> get_fn_name_and_args(args)
      [{name, _, args} | _] when is_list(args) -> {name, args}
      [{name, _, args} | _] when is_atom(args) -> {name, []}
    end
  end

  def collect_module_stats(string) do
    {_, acc} =
      string
      |> to_ast()
      |> Macro.prewalk([], &collect_fn_and_arity/2)

    acc
  end
end