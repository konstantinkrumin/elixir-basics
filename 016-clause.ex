@doc """
    В Эликсир одна функция может иметь несколько тел -- несколько разных блоков кода. 
    В зависимости от входящих аргументов выполняется только один из этих блоков.

    По английски термин "тело функции" пишется clause и произносится [klôz]. Поскольку 
    это короче, то все Эликсир разработчики предпочитают говорить "клоз" вместо 
    "тело функции".
"""

def handle({:dog, name}, :add) do
  IO.puts("add dog #{name}")
end

def handle({:dog, name}, :remove) do
  IO.puts("remove dog #{name}")
end

def handle({:cat, name}, :add) do
  IO.puts("add cat #{name}")
end

def handle({:cat, name}, :remove) do
  IO.puts("remove cat #{name}")
end

@doc """
    Здесь функция handle/2 имеет 4 тела. Шаблоны описываются прямо в аргументах функции, 
    отдельно для каждого тела. Принцип такой же, как и с конструкцией case -- шаблоны 
    проверяются по очереди на совпадение с входящими аргументами функции. Первый совпавший 
    шаблон вызывает соответствующий блок кода и останавливает дальнейший перебор. 
    Если ни один шаблон не совпал, то генерируется исключение.

    Как и в случае с case, здесь тоже важна очередность шаблонов. Типичная ошибка -- 
    расположить более общий шаблон выше, чем более специфичный шаблон:
"""

def handle(animal, action) do
  IO.puts("do something")
end

def handle({:dog, name}, :add) do
  IO.puts("add dog #{name}")
end

# Во многих таких случаях компилятор выдаст предупреждение:
# warning: this clause for handle/2 cannot match because a previous clause at line 27 always matches

@doc """
    Но бывает, что компилятор не замечает проблему.

    Как и с case, с телами функций могут использоваться охранные выражения:
"""

def handle({:dog, name, age}) when age > 10 do
  IO.puts("#{name} is a dog older than 10")
end

def handle({:dog, name, _age}) do
  IO.puts("#{name} is a 10 years old or younger dog")
end

def handle({:cat, name, age}) when age > 10 do
  IO.puts("#{name} is a cat older than 10")
end

def handle({:cat, name, _age}) do
  IO.puts("#{name} is a 10 years old or younger cat")
end

@doc """
    Конструкция case и тела функций полностью эквивалентны друг другу. Выбор того или иного 
    варианта является личным предпочтением разработчика.
"""

###### ASSIGNMENT ######
@doc """
    Поиграем в "крестики-нолики". Игровая доска размером 3х3 ячеек представлена кортежем из 
    3-х кортежей:

    {
        {:x, :o, :f},
        {:f, :o, :f},
        {:f, :f, :f}
    }

    Каждая ячейка может находиться в одном из 3-х состояний:
    - :x в ячейке стоит крестик;
    - :o в ячейке стоит нолик;
    - :f ячейка свободна.

    Реализовать функцию valid_game?(state), которая получает на вход состояние игры, и 
    проверяет, является ли это состояние валидным. То есть, имеет ли состояние правильную 
    структуру, и заполнены ли ячейки только валидными значениями. Функция возвращает 
    булевое значение.

    Реализовать функцию check_who_win(state), которая получает состояние и возвращает 
    победителя, если он есть. Функция должна определить наличие трех крестиков или трех 
    ноликов по горизонтали, или по вертикали, или по диагонали. В случае победы крестиков 
    функция возвращает {:win, :x}, в случае победы ноликов функция возвращает {:win, :o}, 
    если победы нет, функция возвращает :no_win.

    Solution.valid_game?({{:x, :x, :x}, {:x, :x, :x}, {:x, :x, :x}})
    # => true
    Solution.valid_game?({{:f, :f, :f}, {:f, :f, :f}, {:f, :f, :f}})
    # => true

    Solution.valid_game?({{:x, :o, :some}, {:f, :x, :o}, {:o, :o, :x}})
    # => false
    Solution.valid_game?({{:x, :o, :f}, {:f, :x, :x, :o}, {:o, :o, :x}})
    # => false

    Solution.check_who_win({{:x, :x, :x}, {:f, :f, :o}, {:f, :f, :o}})
    # => {:win, :x}
    Solution.check_who_win({{:o, :x, :f}, {:o, :f, :x}, {:o, :f, :f}})
    # => {:win, :o}
    Solution.check_who_win({{:x, :f, :f}, {:f, :x, :x}, {:f, :f, :o}})
    # => :no_win
"""

defmodule Solution do
  def valid_game?({row1, row2, row3}) do
    valid_row(row1) and valid_row(row2) and valid_row(row3)
  end

  def valid_game?(_), do: false

  def valid_row({cell1, cell2, cell3}) do
    valid_cell(cell1) and valid_cell(cell2) and valid_cell(cell3)
  end

  def valid_row(_), do: false

  def valid_cell(:x), do: true
  def valid_cell(:o), do: true
  def valid_cell(:f), do: true
  def valid_cell(_), do: false

  def check_who_win({{c, c, c}, _, _}) when c != :f, do: {:win, c}
  def check_who_win({_, {c, c, c}, _}) when c != :f, do: {:win, c}
  def check_who_win({_, _, {c, c, c}}) when c != :f, do: {:win, c}
  def check_who_win({{c, _, _}, {c, _, _}, {c, _, _}}) when c != :f, do: {:win, c}
  def check_who_win({{_, c, _}, {_, c, _}, {_, c, _}}) when c != :f, do: {:win, c}
  def check_who_win({{_, _, c}, {_, _, c}, {_, _, c}}) when c != :f, do: {:win, c}
  def check_who_win({{c, _, _}, {_, c, _}, {_, _, c}}) when c != :f, do: {:win, c}
  def check_who_win({{_, _, c}, {_, c, _}, {c, _, _}}) when c != :f, do: {:win, c}
  def check_who_win(_), do: :no_win
end