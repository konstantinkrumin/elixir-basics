@doc """
    Помимо обычной обработки, Elixir имеет еще один механизм для взаимодействия со 
    строками, называется он строковыми метками или сигилями. Благодаря им, можно 
    упростить работу со специфичными для домена текстовыми данными.

    Классическим примером являются регулярные выражения:
"""
# это регулярное выражение проверяет вхождение слов foo или bar
regex = ~r/foo|bar/

"foo" =~ regex
# => true
"bat" =~ regex
# => false

@doc """
    Помимо этого, в конце сигиля можно указать специальный модификатор, который будет 
    влиять на его поведение. Например, если к регулярному выражению добавить 
    модификатор i, то регулярное выражение будет регистронезависимым:
"""
"HELLO" =~ ~r/hello/
# => false

"HELLO" =~ ~r/hello/i
# => true

@doc """
    Есть еще сигили, например ~w для слов или ~s для строк, в которых содержатся 
    двойные кавычки:
"""
~w(foo bar bat)
# => ["foo", "bar", "bat"]

~s(this is a string with "double" quotes, not 'single' ones)
# => "this is a string with \"double\" quotes, not 'single' ones"

@doc """
    Помимо сигилей, доступных в самом языке, мы можем создавать свои, с помощью 
    объявления функции sigil_[x], где x - название сигиля. Создадим сигиль ~u 
    который переводит переданную строку в верхний регистр, для перевода воспользуемся 
    функций String.upcase:
"""
defmodule MySigils do
  def sigil_u(string, []), do: String.upcase(string)
end

# для работы с новыми сигилями, нужно импортировать модуль, где они объявлены
import MySigils

~u(code basics)
# => CODE BASICS

@doc """
    Важно, что функция-сигиль принимает два аргумента, саму строку и список модификаторов.

    Теперь добавим к сигилю ~u два модификатора f и l, которые возвращают первый или 
    последний символ строки:
"""
defmodule MySigils do
  def sigil_u(string, []), do: String.upcase(string)
  def sigil_u(string, [?f]), do: String.first(String.upcase(string))
  def sigil_u(string, [?l]), do: String.last(String.upcase(string))
end

~u(code basics)f
# => C
~u(code basics)l
# => S

###### ASSIGNMENT ######
@doc """
    Создайте сигиль ~i который переводит переданную в него строку в целое число и если 
    указан модификатор n, который переводит переданное строку-число в отрицательное:

    ~i(40)
    # => 40

    ~i(21)n
    # => -21

    Для перевода строки в число воспользуйтесь функцией to_integer из модуля String.
"""
defmodule Solution do
  def sigil_i(string, []), do: String.to_integer(string)
  def sigil_i(string, [?n]), do: -String.to_integer(string)
end
