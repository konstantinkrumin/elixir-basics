@doc """
    Вспомним пример из прошлого упражнения:
"""
defmodule Exercise do
  defmacro double(x) do
    {:*, [], [2, x]}
  end
end

@doc """
    В этом макросе мы вернули код во внутреннем представлении языка Elixir, но работать с таким представлением неудобно, особенно если есть вложенность:
"""
# в этом макросе выполняется следующая операция ((x * 4) + 3) * x
defmodule Exercise do
  defmacro magic(x) do
    {:*, [],
      [
        {:+, [],
          [{:*, [], [x, 4]}, 3]},
        x
      ]
    }
  end
end

require Exercise

Exercise.magic(1)
# 7, т.к. ((1 * 4) + 3) * 1
Exercise.magic(2)
# 22, т.к. ((2 * 4) + 3) * 2

@doc """
    В примере выше мы напрямую управляли структурой AST дерева, однако понимать этот код стало сложнее. Для упрощения работы с AST в макросах Elixir есть 
    функции quote и unquote прямиком перекочевавшие из Lisp-подобных языков.

    Функция quote принимает произвольное выражение на языке Elixir и преобразует его во внутренне представление языка:
"""
quote do: 1 + 2
# => {:+, [], [1, 2]}

quote do: Integer.to_string((1 + 2) * 3)
# => {{:., [], []}, [],
# =>   [
# =>     {:*, [],
# =>       [{:+, [], [1, 2]}, 3]}
# => ]}

@doc """
    Теперь попробуем переписать макрос из начала упражнения:
"""
defmodule Exercise do
  defmacro double(x) do
    quote do: 2 * x
  end
end

require Exercise

Exercise.double(2)
# => error: undefined variable "x" (context Exercise)

@doc """
    Код не работает из-за того, что x при передаче в макрос уже в форме внутреннего представления, поэтому нужно сообщить Elixir, что аргумент не нужно 
    переводить во внутренне представление, для этого используется функция unquote:
"""
defmodule Exercise do
  defmacro double(x) do
    quote do
      2 * unquote(x)
    end
  end
end

require Exercise

Exercise.double(2)
# => 4

@doc """
    По сути мы сообщили Elixir следующее: Преврати 2 * x во внутреннее представление, но оставь аргумент x в исходном виде.

    Подведем итоги: quote означает преврати все в блоке do в формат внутреннего представления, unquote означает не превращай это во внутренний формат.

    Многие, кто пишут макросы, частно допускают ошибку, забывая передать аргументы функции unquote. Важно помнить, что все аргументы передаются макросам 
    во внутреннем формате.

    Так же важно знать, что при передаче в quote атома, числа, строки, списка или кортежа с двумя элементами, функция вернет аргумент без изменений, 
    а не кортеж во внутреннем формате.
"""
quote do: :a
# => :a
quote do: 2
# => 2
quote do: "hello"
# => "hello
quote do: [1, 2, 3]
# => [1, 2, 3]

quote do: {1, 2}
# => {1, 2}
quote do: {1, 2, 3}
# => {:{}, [], [1, 2, 3]}
quote do: %{a: 2}
# => {:%{}, [], [a: 2]}

@doc """
    Происходит это потому, что элементы из примера выше тоже представляют собой часть AST структуры Elixir, поэтому их не нужно дополнительно переводить 
    во внутреннее представление.
"""

###### ASSIGNMENT ######
@doc """
    Создайте макрос my_unless, который повторяет семантику unless:

    require Solution

    Solution.my_unless(false, do: 1 + 3)
    # => 4
    Solution.my_unless(true, do: 1 + 3)
    # => nil
    Solution.my_unless(2 == 2, do: "hello")
    # => nil
    Solution.my_unless(2 == 1, do: "world")
    # => "world"
"""
defmodule Solution do
  defmacro my_unless(condition, do: block) do
    quote do
        if !unquote(condition) do
            unquote(block)
        else
            nil
        end
    end
  end
end

# ALTERNATIVE SOLUTION
defmodule Solution do
  defmacro my_unless(condition, do: expression) do
    quote do
      if(!unquote(condition), do: unquote(expression))
    end
  end
end