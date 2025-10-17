@doc """
    С помощью протоколов в Elixir реализуется полиморфное поведение в зависимости от типа данных. Начнем с примера реализации полиморфного поведения с 
    помощью сопоставления с образцом:
"""
defmodule Typer do
  def type(value) when is_binary(value), do: "string"
  def type(value) when is_integer(value), do: "integer"
  def type(value) when is_list(value), do: "array"
  def type(value) when is_map(value), do: "hash"
  # ... other implementations
end

Typer.type(2)
# => "integer"

Typer.type([])
# => "array"

Typer.type(%{})
# => "hash"

@doc """
    С этим кодом не будет проблем, если он используется в рамках одного приложения в небольшом количестве мест. Однако, поддерживать такой код станет 
    заметно сложнее, если он превратится в зависимость для нескольких приложений (см. expression problem), так как нет простых способов расширять 
    функциональность такого модуля.

    Как раз для таких случаев и используются протоколы. По сути протоколы позволяют выполнять диспетчеризацию на любом типе данных, который реализуют 
    соответствующий протокол. Важно, что протоколы могут быть реализованы в любом месте, где это нужно. Теперь перепишем модуль Typer:
"""
defprotocol Typer do
  @spec type(t) :: String.t()
  def type(value)
end

defimpl Typer, for: BitString do
  def type(_value), do: "string"
end

defimpl Typer, for: Integer do
  def type(_value), do: "integer"
end

defimpl Typer, for: List do
  def type(_value), do: "array"
end

defimpl Typer, for: Map do
  def type(_value), do: "hash"
end

Typer.type(2)
# => "integer"

Typer.type([])
# => "array"

Typer.type(%{})
# => "hash"

@doc """
    Мы определили протокол с помощью defprotocol - описали в нем функцию со спецификацией. Затем через defimpl мы описали реализацию протокола для 
    соответствующих типов данных.

    С помощью протоколов мы получили преимущество. Теперь мы не привязаны к модулю, в котором определили протокол, если нужно добавить реализацию для 
    какого-либо нового типа. Например, реализацию протокола Typer мы можем разнести по разным файлам и модулям, а Elixir найдет и вызовет нужную реализацию 
    протокола для описанных нами данных.

    Функции, определенные в протоколе, могут принимать больше одного аргумента, но диспетчеризация произойдет по первому аргументу.

    Протоколы можно определить для всех типов Elixir:

    - Atom
    - BitString
    - Float
    - Function
    - Integer
    - List
    - Map
    - PID
    - Port
    - Reference
    - Tuple

    Помимо встроенных типов, протоколы можно определять для структур:
"""
defmodule User do
  defstruct [:name, :age]
end

defimpl Typer, for: User do
  def type(_value), do: "user"
end

Typer.type(%User{age: 20, name: "John"})
# => "user"

###### ASSIGNMENT ######
@doc """
   Определите три структуры Human, Dog и Cat с полем name. Затем определите функцию say_something для протокола Teller для каждого из модулей, 
   которая возвращает строку в зависимости от типа:

    - Для Human Hello, world!
    - Для Cat Meow, world!
    - Для Dog Bark, world!

    Teller.say_something(%Human{name: "John"}) # => "Hello, world!"
    Teller.say_something(%Dog{name: "Barkinson"}) # => "Bark, world!"
    Teller.say_something(%Cat{name: "Meowington"}) # => "Meow, world!"
"""
defmodule Human do
  defstruct [:name]
end

defmodule Dog do
  defstruct [:name]
end

defmodule Cat do
  defstruct [:name]
end

defprotocol Teller do
  @spec say_something(any()) :: String.t()
  def say_something(someone)
end

defimpl Teller, for: Human do
  def say_something(_value), do: "Hello, world!"
end

defimpl Teller, for: Dog do
  def say_something(_value), do: "Bark, world!"
end

defimpl Teller, for: Cat do
  def say_something(_value), do: "Meow, world!"
end