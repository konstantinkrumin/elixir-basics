@doc """
    Для моделирования данных, которые лучше отражает предметную область, используют структуры.

    Структуры по сути словари, но с некоторыми особенностями. Структуры проверяются на уровне компиляции, в них можно задать значения по умолчанию и 
    структурам недоступны протоколы для словарей, например протоколы Enum. Протоколы рассмотрим чуть дальше, а сейчас изучим структуры:
"""
defmodule Counter do
  defstruct state: 0
end

my_counter = %Counter{}
%Counter{state: 0}

@doc """
    В примере мы объявили модуль Counter и в нем объявили, что этот модуль является структурой с полем state, которое по умолчанию равно 0. 
    Затем мы связали my_counter с ранее объявленной структурой. Еще мы можем объявить поля без значения по умолчанию:
"""
defmodule Counter do
  defstruct [:current, initial: 0, hello: "world"]
end

defmodule Counter2 do
  defstruct current: nil, initial: 0, hello: "world"
end

my_counter = %Counter{}
# => %Counter{current: nil, initial: 0, hello: "world"}
my_second_counter = %Counter2{}
# => %Counter2{current: nil, initial: 0, hello: "world"}}

@doc """
    Теперь рассмотрим, как работать с полями структур:
"""
defmodule User do
  defstruct age: 0, name: "John"
end

john = %User{age: 20}
john.age
# => 20

john.name
# => "John"

alice = %{john | name: "Alice"}
alice.name
# => "Alice"

jane = %{alice | other_field: "some"}
# => ** (KeyError) key :other_field not found in: %User{age: 20, name: "Alice"}
# =>   (stdlib 4.3.1.1) :maps.update(:other_field, "some", %User{age: 20, name: "Alice"})

@doc """
    Используя синтаксис модификации |, виртуальная машина заранее знает, что структура имеет фиксированное количество полей и не дает добавлять новые, 
    только менять заранее объявленные. Интересный момент, что структуры можно использовать в паттерн-матчинге:
"""
defmodule Pet do
  defstruct name: "Barkley"
end

defmodule User do
  defstruct name: "John"
end

defmodule Example do
  def print_name(%User{name: name} = user) do
    "Hello, human #{name}"
  end

  def print_name(%Pet{name: name} = pet) do
    "Hello, pet #{name}"
  end
end

pet = %Pet{}
user = %User{}

Example.print_name(pet)
# => "Hello, pet Barkley"
Example.print_name(user)
# => "Hello, human John"

@doc """
    Благодаря паттерн-матчингу мы добились полиморфного поведения функции.

    Так как структуры не используют протоколы словарей, то и доступ к полю через [] становится недоступным:
"""
defmodule User do
  defstruct age: 0, name: "John"
end

user = %User{}
# => %User{age: 0, name: "John"}

user.name
# => "John"

user[:name]
# => ** (UndefinedFunctionError) function User.fetch/2 is undefined (User does not implement the Access behaviour. If you are using get_in/put_in/update_in, you can specify the field to be accessed using Access.key!/1)
# =>   User.fetch(%User{age: 0, name: "John"}, :name)
# =>   (elixir 1.15.0) lib/access.ex:305: Access.get/3
# =>   iex:201: (file)

Map.get(user, :name)
# => "John"

@doc """
    Еще с помощью атрибута enforce_keys можно добавить проверку на инициализацию данных по ключу при создании структуры:
"""
defmodule User do
  @enforce_keys [:name, :age]
  defstruct [:name, :age]
end

%User{}
# => ** (ArgumentError) the following keys must also be given when building struct User: [:name, :age]
# =>   expanding struct: User.__struct__/1
# =>   iex:204: (file)

%User{name: "John"}
# => ** (ArgumentError) the following keys must also be given when building struct User: [:age]
# =>   expanding struct: User.__struct__/1
# =>   iex:205: (file)

%User{name: "John", age: 20}
# => %User{name: "John", age: 20}

@doc """
    Такая проверка работает только во время компиляции и только при создании структуры. Проверка не будет запускаться при изменении данных по ключу.
"""

###### ASSIGNMENT ######
@doc """
    Создайте функцию calculate_stats, которая подсчитывает, сколько в списке людей и питомцев:

    users_and_pets = [%User{}, %User{}, %Pet{}]

    Solution.calculate_stats(users_and_pets)
    # => %{humans: 2, pets: 1}

    Solution.calculate_stats([])
    # => %{humans: 0, pets: 0}

    only_pets = [%Pet{}, %Pet{}, %Pet{}]
    # => %{humans: 0, pets: 3}

    Обратите внимание, что структуры в модуле заранее определены.
"""
defmodule User do
  defstruct name: "John"
end

defmodule Pet do
  defstruct name: "Barkley"
end

defmodule Solution do
  def calculate_stats(list) do
    Enum.reduce(list, %{humans: 0, pets: 0}, fn
        %User{} = _u, acc -> Map.update(acc, :humans, 1, &(&1 + 1))
        %Pet{} = _p, acc -> Map.update(acc, :pets, 1, &(&1 + 1))
    end)
  end
end

# ALTERNATIVE SOLUTIOn
defmodule User do
  defstruct name: "John"
end

defmodule Pet do
  defstruct name: "Barkley"
end

defmodule Solution do
  @default_stats %{humans: 0, pets: 0}

  def calculate_stats([]), do: @default_stats

  def calculate_stats(humans_and_pets) do
    Enum.reduce(humans_and_pets, @default_stats, &stat_member/2)
  end

  defp stat_member(%User{}, acc) do
    Map.update(acc, :humans, 0, fn curr -> curr + 1 end)
  end

  defp stat_member(%Pet{}, acc) do
    Map.update(acc, :pets, 0, fn curr -> curr + 1 end)
  end
end