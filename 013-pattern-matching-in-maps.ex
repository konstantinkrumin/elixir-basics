@doc """
    Есть некоторые нюансы сопоставления с образцом при работе со словарями. В шаблоне 
    не нужно перечислять все ключи, какие есть в словаре. Мы указываем только те 
    ключи, которые нам нужны:
"""
my_map = %{a: 1, b: 2, c: 3}
%{a: value} = my_map

IO.puts(value) # => 1

# Если ключи не являются атомами, то синтаксис отличается:
my_map = %{"a" => 1, "b" => 2, "c" => 3}
%{"a" => value1} = my_map
IO.puts(value1) # => 1

%{"b" => value2, "c" => value3} = my_map
IO.puts(value2) # => 2
IO.puts(value3) # => 3

@doc """
    Шаблон %{} совпадает с любым словарём. Это контринтуитивно, можно было бы ожидать, 
    что этот шаблон совпадает только с пустым словарём. Этим шаблоном нельзя ничего 
    извлечь, но можно проверить, что значение является словарём, а не чем-то иным.
"""
my_map = %{"a" => 1, "b" => 2, "c" => 3}
%{} = my_map
my_map = 42
%{} = my_map # ** (MatchError) no match of right hand side value: 42

# Переменные можно использовать для извлечения значений, но не для извлечения ключей:
%{"c" => my_var} = my_map
IO.puts(my_var) # => 3

%{my_var => 1} = my_map # ** (CompileError) iex:17: cannot use variable my_var as map key inside a pattern.

@doc """
    Переменная в шаблоне может выполнять две роли. Либо мы хотим, чтобы эта переменная 
    получила новое значение, и тогда не важно, использовалась ли эта переменная раньше, 
    было ли у нее какое-то значение. Либо мы хотим использовать значение, которое 
    переменная уже имеет, как часть шаблона. Во втором случае понадобится pin operator.
"""
animal = :cat
{^animal, "Tihon"} = {:cat, "Tihon"}
{^animal, "Tihon"} = {:dog, "Tihon"} # ** (MatchError) no match of right hand side value: {:dog, "Tihon"}

@doc """
    pin operator извлекает текущее значение переменной и подставляет его в шаблон. 
    И дальше это значение в шаблоне работает как литерал.

    pin operator можно использовать и для ключа, и для значения:
"""
value1 = 1
%{"a" => ^value1} = my_map
keyb = "b"
%{^keyb => _} = my_map

###### ASSIGNMENT ######
@doc """
    Реализовать функцию get_values(data), которая принимает словарь, извлекает из него два 
    значения по ключам :a и :b, и возвращает их в виде кортежа {a_value, b_value}.

    Реализовать функцию get_value_by_key(data, key), которая принимает словарь и ключ, 
    извлекает значение по указанному ключу и возвращает его.

    Обе функции генерируют исключение MatchError если в словаре нет нужных ключей.

    Solution.get_values(%{a: 1, b: 2})
    # => {1, 2}
    Solution.get_values(%{a: :ok, b: 42, c: true})
    # => {:ok, 42}

    Solution.get_values(%{})
    # => MatchError

    Solution.get_value_by_key(%{answer: 42}, :answer)
    # => 42
    Solution.get_value_by_key(%{question: "6 * 7"}, :question)
    # => "6 * 7"

    Solution.get_value_by_key(%{a: 1}, :b)
    # => MatchError
"""
defmodule Solution do
    def get_values(data) do
        %{a: value1, b: value2} = data
        {value1, value2}
    end 

    def get_value_by_key(data, key) do
        %{^key => value} = data
        value
    end
end