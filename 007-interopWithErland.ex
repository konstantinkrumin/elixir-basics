@doc """
    Так как Elixir имеет доступ к виртуальной машине Эрланг (Erlang VM), то это позволяет 
    использовать все библиотеки, включая стандартную библиотеку Erlang, в коде на Elixir.

    Модули Erlang представлены атомами в нижнем регистре, такими как :os и :timer. 
    Атомы - специальные строки, которые начинаются с символа :. Тему атомов подробнее 
    рассмотрим в следующем модуле, а пока вернемся к примерам вызова Erlang кода 
    из Elixir:
"""
# функция которая переводит секунды в миллисекунды
:timer.seconds(5)
# => 5000

:os.cmd(~c"whoami")
# => ~c"root\n"

:os.getenv(~c"SHELL")
# => ~c"/bin/zsh"

# Для подключения пакетов Erlang достаточно указать их в mix.exs:
# в mix.exs
def deps do
  [{:png, github: "yuce/png"}]
end

# теперь мы можем пользоваться этой библиотекой
png =
  :png.create(%{:size => {30, 30}, :mode => {:indexed, 8}, :file => file, :palette => palette})

# Однако есть и некоторые различия, например в атомах:
# в эликсире
:my_atom
# в эрланге
my_atom.

@doc """
    Когда мы говорим о строках в Elixir, имеются ввиду бинарные объекты в UTF-8. В Erlang 
    строки тоже используют двойные кавычки, но являются списком символов:
"""
# в эликсире
is_list('Example') # => true
is_list("Example") # => false
is_binary("Example") # => true
<<"Example">> === "Example" # => true
# в эрланге
is_list('Example'). # => false
is_list("Example"). # => true
is_binary("Example"). # => false
is_binary(<<"Example">>). # => true

@doc """
    Многие старые библиотеки Erlang могут не поддерживать бинарные строки, потому нужно 
    превращать строки Elixir в строковые списки. Это достигается функцией to_charlist 
    или с помощью сигиля ~c. Сигили - особенные метки, которые выполняют преобразования 
    над строками, подробнее их рассмотрим в следующем упражнении, а пока вернемся 
    к примерам:
"""
# функция подсчитывающее количество слов из erlang
:string.words("Hello World")
# => ** (FunctionClauseError) no function clause matching in :string.strip_left/2
# =>
# =>   The following arguments were given to :string.strip_left/2:
# =>
# =>       # 1
# =>       "Hello World"
# =>
# =>       # 2
# =>       32
# =>
# =>   (stdlib) string.erl:1661: :string.strip_left/2
# =>   (stdlib) string.erl:1659: :string.strip/3
# =>   (stdlib) string.erl:1597: :string.words/2

words = to_charlist("Hello World")
:string.words(words) # => 2

# или с помощью сигиля
:string.words(~c"Hello World") # => 2

@doc """
    В Erlang переменные начинаются с заглавной буквы, и повторная привязка (присваивание) 
    не допускается:
"""
# в эликсире
x = 10
x = 20
x1 = x + 10 # => 30
# в эрланге
X = 10.
X = 20.
# ** exception error: no match of right hand side value 20
X1 = X + 10. # => 20

###### ASSIGNMENT ######
@doc """
    Создайте функцию hours_to_milliseconds которая конвертирует часы в миллисекунды, 
    обратите внимание на :timer библиотеку из Erlang:

    Solution.hours_to_milliseconds(0)
    # => 0
    Solution.hours_to_milliseconds(1.5)
    # => 5400000.0
    Solution.hours_to_milliseconds(2)
    # => 7200000
"""
defmodule Solution do
  def hours_to_milliseconds(hours) do
    :timer.hours(hours)
  end
end