@doc """
    Ручная реализация протоколов для всех типов может быстро стать повторяющейся и утомительной. В таких случаях Elixir предоставляет два варианта: можно 
    явно вывести (derive) реализацию протокола для наших типов или автоматически реализовать протокол для всех типов. В обоих случаях необходимо реализовать 
    протокол для Any.

    Опишем явное выведение (derive) протокола из примера Typer прошлого модуля:
"""
defprotocol Typer do
  @spec type(t) :: String.t()
  def type(value)
end

defimpl Typer, for: Any do
  def type(_value), do: "something"
end

@doc """
    Конечно, реализация получилось странной, потому что для любого типа будет возвращаться something, однако это учебный пример. Теперь опишем пользователя 
    и явно выведем для него протокол:
"""
defmodule SomeUser do
  @derive [Typer]
  defstruct [:name, :age]
end

Typer.type(%SomeUser{})
# => "something"

@doc """
    В другом случае, в протоколе указывается опция fallback_to_any и если не будет найден нужный протокол под тип, то будет использована реализация 
    протокола для Any:
"""
defprotocol Typer do
  @fallback_to_any true

  def type(value)
end

defimpl Typer, for: Any do
  def type(_value), do: "something new"
end

defmodule AnotherUser do
  defstruct [:name]
end

Typer.type(%AnotherUser{})
# => "something new"

@doc """
    Как было сказано выше, не всегда реализация протокола для Any необходима, так как может не иметь смысла для некоторых типов данных. Например, протокол 
    Size имеет смысл для перечислимых типов данных, но не для чисел. Поэтому зачастую выброс ошибки при отсутствии необходимой реализации протокола 
    является ожидаемым поведением.

    Какой выбрать из вариантов между явным выведением (derive) или опцией fallback_to_any зависит от ситуации. Тем не менее явное лучше, чем неявное, 
    поэтому зачастую в Elixir библиотеках используется подход с derive.
"""

###### ASSIGNMENT ######
@doc """
   Продолжим упражнение из прошлого модуля, теперь опишите структуру Robot с явным указанием протокола Teller и реализуйте протокол для Any который 
   возвращает строку World!:

    Teller.say_something(%Human{name: "John"}) # => "Hello, world!"
    Teller.say_something(%Dog{name: "Barkinson"}) # => "Bark, world!"
    Teller.say_something(%Cat{name: "Meowington"}) # => "Meow, world!"
    Teller.say_something(%Robot{name: "Roberto"}) # => "World!"
"""
defprotocol Teller do
  @spec say_something(any()) :: String.t()
  def say_something(someone)
end

defmodule Human do
  defstruct [:name]
end

defmodule Dog do
  defstruct [:name]
end

defmodule Cat do
  defstruct [:name]
end

defimpl Teller, for: Human do
  def say_something(_), do: "Hello, world!"
end

defimpl Teller, for: Dog do
  def say_something(_), do: "Bark, world!"
end

defimpl Teller, for: Cat do
  def say_something(_), do: "Meow, world!"
end

defimpl Teller, for: Any do
  def say_something(_), do: "World!"
end

defmodule Robot do
  @derive [Teller]
  defstruct [:name]
end