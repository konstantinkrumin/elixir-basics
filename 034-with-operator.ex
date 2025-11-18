@doc """
    Рассмотрим оператор with, зачем нужен и как используется. Для начала, опишем пример:
"""
defmodule Example do
  require Integer

  def inc_even(num) do
    if Integer.is_even(num) do
      num + 1
    else
      {:error, :not_even}
    end
  end

  def stringify_odd(num) do
    if Integer.is_odd(num) do
      Integer.to_string(num)
    else
      {:error, :not_odd}
    end
  end
end

@doc """
    Проблема в том, что при попытке скомпоновать эти функции через оператор пайплайна |> будут возникать ошибки, если аргумент окажется неподходящим:
"""
2 |> Example.inc_even() |> Example.stringify_odd()
# => "3"

2 |> Example.stringify_odd() |> Example.inc_even()
# => {:error, :not_even}

@doc """
    Можно попытаться решить проблему через case:
"""
case Example.inc_even(3) do
  {:error, reason} -> reason

  result ->
    case Example.stringify_odd(result) do
      {:error, reason} -> reason

      stringified -> stringified
    end
end

# => :not_even

@doc """
    Однако, такой подход начинает хуже работать с увеличением вложенности операций. Для выпрямления таких вычислений используется конструкция with, 
    с помощью которой описывается удачный путь вычислений (happy path) и комбинировать вызовы функций с разным форматом данных. Перепишем на with:
"""
with incremented <- Example.inc_even(2),
     stringified <- Example.stringify_odd(incremented),
     do: stringified

# => "3"
# по сути получился аналог
# 2 |> Example.inc_even() |> Example.stringify_odd()

@doc """
    Оператор with полезен тем, что можно обрабатывать неудачные вызовы функций в ветке else:
"""
with incremented <- Example.inc_even(3),
    stringified <- Example.stringify_odd(incremented) do
  stringified
else
  {:error, reason} -> reason
end

# => :not_odd

@doc """
    Внутри with можно использовать разные функции с разными возвращаемыми значениями, например:
"""
user = %{name: "John"}
with updated_user <- Map.put(user, :age, 20),
     true <- updated_user[:age] == 20,
     %{hobby: hobby} <- Map.put(updated_user, :hobby, "diving"),
     do: hobby

# => "diving"

@doc """
    Для функции предиката добавим еще одну ветку и поменяем значение по ключу age:
"""
user = %{name: "John"}
with updated_user <- Map.put(user, :age, 22),
     true <- updated_user[:age] == 20,
     %{hobby: hobby} <- Map.put(updated_user, :hobby, "diving") do
  hobby
else
  false -> "incorrect age"
end

# => "incorrect age"

@doc """
    С помощью with проще структурировать ошибки, которые могут возникнуть в цепочке вычислений, однако важно не увлечься при описании такой цепочки, 
    потому что с ростом операций становится тяжелее понять что происходит с данными. В таких случаях лучше сгруппировать часть операции в отдельные функции 
    и в итоговом with описать меньшее количество вызываемых функций. Хорошим примером является фреймворк Phoenix, в котором при генерации ресурса, 
    например пользователя, создается такой код для контроллера:
"""
def create(conn, params) do
  with {:ok, user} <- Users.create_user(params) do
    conn
    |> put_status(:created)
    |> render("show.json", user: user)
end

@doc """
    На верхнем уровне Phoenix перехватывает ошибки создания ресурса, так как оно типично: {:error, changeset}. Поэтому нет необходимости описывать отдельно ветку else.
"""

###### ASSIGNMENT ######
@doc """
   Реализуйте функцию validate, которая проверяет переданный аргумент на следующие условия:

    - аргумент является строкой
    - длина строки меньше или равна 8
    - длина строки больше или равна 2
    
   Примеры работы функции:

    Solution.validate("some")
    # => {:ok, "some"}
    Solution.validate("hello!!")
    # => {:ok, "hello!!"}

    Solution.validate(1)
    # => {:error, :not_binary}
    Solution.validate("a")
    # => {:error, :too_short}
    Solution.validate("hello, world!")
    # => {:error, :too_long}
"""
defmodule Solution do
  def validate(arg) do
    with true <- is_binary(arg) || {:error, :not_binary},
         len = String.length(arg),
         true <- len >= 2 || {:error, :too_short},
         true <- len <=8 || {:error, :too_long} do
        {:ok, arg}
    end
  end
end