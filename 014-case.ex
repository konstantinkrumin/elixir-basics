@doc """
    Условные переходы в функциональных языках отличаются от императивных, потому что 
    основаны на сопоставлении с образцом. Основная идея в том, что некое значение по 
    очереди сравнивается с несколькими шаблонами, и в зависимости от того, с каким 
    шаблоном оно совпадет, выполняется та или иная ветка кода.

    Есть несколько вариантов условных переходов:
    - конструкция case;
    - конструкция cond;
    - тело функции (function clause);
    - обработка исключений rescue, catch;
    - чтение сообщений из mailbox receive.

    Все они, кроме cond, реализуют эту идею.
"""

# Рассмотрим конструкцию case.

# Для примера рассмотрим вычисление наибольшего общего делителя:
def gcd(a, b) do
  case rem(a, b) do
    0 -> b
    c -> gcd(b, c)
  end
end

@doc """
    Здесь вычисляется значение rem(a, b) и сравнивается с двумя шаблонами. Первый шаблон -- 
    литерал 0. Если значение совпадает с ним, то выполняется код, завершающий рекурсию и 
    возвращающий b. Второй шаблон -- переменная c. С этим шаблоном совпадут любые значения, 
    и тогда выполняется вызов gcd(b, c).

    Второй пример:
"""

case Map.fetch(acc, word) do
  {:ok, count} -> Map.put(acc, word, count + 1)
  :error -> Map.put(acc, word, 1)
end

@doc """
    Здесь выполняется вызов функции Map.fetch(acc, word). Получившееся значение сравнивается 
    с двумя шаблонами и выполняется соответствующий код.

    Шаблонов может быть несколько. И важен их порядок, потому что первый совпавший шаблон 
    останавливает перебор оставшихся шаблонов. Если не совпал ни один из шаблонов, то 
    генерируется исключение.

    В общем виде конструкция case выглядит так:

    case Expr do
        Pattern1 [when GuardSequence1] ->
            Body1
        ...
        PatternN [when GuardSequenceN] ->
            BodyN
    end

    Что такое GuardSequence -- цепочка охранных выражений, мы рассмотрим позже.

    case могут быть вложенными друг в друга:
"""

def handle(animal, action) do
  case animal do
    {:dog, name} ->
      case action do
        :add -> IO.puts("add dog #{name}")
        :remove -> IO.puts("remove dog #{name}")
      end
    {:cat, name} ->
      case action do
        :add -> IO.puts("add cat #{name}")
        :remove -> IO.puts("remove cat #{name}")
      end
  end
end

@doc """
    Вложенный даже на два уровня код плохо читается. Обычно этого можно избежать. Данный 
    пример можно реализовать без вложенного case таким образом:
"""
def handle(animal, action) do
  case {animal, action} do
    {{:dog, name}, :add} -> IO.puts("add dog #{name}")
    {{:dog, name}, :remove} -> IO.puts("remove dog #{name}")
    {{:cat, name}, :add} -> IO.puts("add cat #{name}")
    {{:cat, name}, :remove} -> IO.puts("remove cat #{name}")
  end
end

# Охранные выражения (Guards)

@doc """
    Теперь вернемся к упомянутым выше охранным выражениям.

    Не всегда достаточно шаблона, чтобы проверить все условия для ветвления в коде. 
    Например, шаблоном нельзя проверить попадание числа в определенный диапазон.
"""
def handle4(animal) do
  case animal do
    {:dog, name, age} when age > 10 -> IO.puts("#{name} is a dog older than 10")
    {:dog, name, _} -> IO.puts("#{name} is a 10 years old or younger dog")
    {:cat, name, age} when age > 10 -> IO.puts("#{name} is a cat older than 10")
    {:cat, name, _} -> IO.puts("#{name} is a 10 years old or younger cat")
  end
end

@doc """
    Охранное выражение представляет собой предикат или цепочку предикатов:

    when predicat1 and predicat2 or ... predicatN ->

    В предикатах можно использовать ограниченный набор функций, описанный в документации. 
    Некоторые функциональные языки разрешают вызывать любые функции в охранных выражениях. 
    Но Эликсир не относится к таким языкам.

    Если при вычислении охранного выражения возникает исключение, то оно не приводит к 
    остановке процесса, а приводит к тому, что все выражение вычисляется в false. Это позволяет писать выражения проще. Вместо:

    when is_map(a) and map_size(a) > 10 ->

    можно сразу писать:

    when map_size(a) > 10 ->
"""

###### ASSIGNMENT ######
@doc """
    Реализовать функцию join_game(user), которая принимает игрока в виде кортежа 
    {:user, name, age, role} и определяет, разрешено ли данному игроку подключиться к игре. 
    Если игроку уже исполнилось 18 лет, то он может войти в игру. Если роль игрока :admin 
    или :moderator, то он может войти в игру независимо от возраста. Функция должна 
    вернуть :ok или :error.

    Реализовать функцию move_allowed?(current_color, figure) которая определяет, разрешено 
    ли данной шахматной фигуре сделать ход. Параметр current_color может быть либо :white 
    либо :black, и он указывает, фигурам какого цвета разрешено сделать ход. Параметр 
    figure представлен кортежем {type, color}, где type может быть один из: :pawn, :rock, 
    :bishop, :knight, :queen, :king, а color может быть :white или :black. Фигура может 
    сделать ход если её тип :pawn или :rock и её цвет совпадает с current_color. 
    Функция должна вернуть true или false.

    Solution.join_game({:user, "Bob", 17, :admin})
    # => :ok

    Solution.join_game({:user, "Bob", 17, :moderator})
    # => :ok

    Solution.join_game({:user, "Bob", 17, :member})
    # => :error

    Solution.move_allowed?(:white, {:pawn, :white})
    # => true

    Solution.move_allowed?(:black, {:pawn, :white})
    # => false
"""
defmodule Solution do
  def join_game(user) do
    case user do
        {:user, _name, _age, :admin} -> :ok
        {:user, _name, _age, :moderator} -> :ok
        {:user, _name, age, _} when age >= 18 -> :ok
        _ -> :error
    end
  end

  def move_allowed?(current_color, figure) do
    case figure do
        {:pawn, ^current_color} -> true
        {:rock, ^current_color} -> true
        _ -> false
    end
  end
end