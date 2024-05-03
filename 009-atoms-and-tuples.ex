@doc """
    Атомы типичны для функциональных языков, но редко встречаются в языках императивных. 
    Это некие константные значения, которые можно сравнивать друг с другом. Собственно, 
    сравнивать — это единственное, что с ними можно делать. Сами по себе они не очень 
    полезны, но становятся полезны в комплекте с кортежами и сопоставлением с 
    образцом (pattern matching).
"""
:user
:point
:ip_address

@doc """
    Кортеж (tuple) — это структура данных, объединяющая несколько разных значений. 
    Кортеж похож на список, но в отличие от списка имеет фиксированную длину.
"""
{"Bob", :male, 23}
{1, 2}
{127, 0, 0, 1}

@doc """
    В кортежах на первой позиции часто ставят атом, чтобы обозначить, что за данные собраны 
    в кортеже. Таким образом кортеж помечается тэгом (tagged tuple).
"""
{:user, "Bob", :male, 23}
{:point, 1, 2}
{:ip_address, 127, 0, 0, 1}

# Кортежи могут быть вложенными:
{:rectangle, {:point, 0, 0}, {:point, 10, 10}}
{:ip4, {127, 0, 0, 1}}

@doc """
    Небольшие объекты, состоящие из 2-4 полей, удобно представлять в виде кортежей, 
    если роль полей понятна из контекста. В ином случае нужно использовать 
    словарь (map) или структуру (struct).

    Атомы и кортежи — это легковесные объекты, они используют меньше памяти, чем словари 
    и структуры, и операции над ними выполняются быстрее.

    Сопоставление с образцом мы будем изучать подробно. Сейчас важно знать, что это 
    способ извлечь отдельные значения из кортежа:
"""
my_point = {:point, 5, 10}
{:point, x, y} = my_point
IO.puts(x) # => 5
IO.puts(y) # => 10

@doc """
    Рассмотрим реализацию функции distance, которая вычисляет расстояние между 
    двумя точками:
"""
def distance(point1, point2) do
  {:point, x1, y1} = point1
  {:point, x2, y2} = point2
  x_dist = abs(x1 - x2)
  y_dist = abs(y1 - y2)
  :math.sqrt(:math.pow(x_dist, 2) + :math.pow(y_dist, 2))
end

@doc """
    Функция принимает в аргументах две точки, извлекает их координаты с помощью 
    сопоставления с образцом, и по теореме Пифагора вычисляет расстояние между точками.

    Для этого применяется модуль :math из языка Эрланг, потому что у Эликсир нет 
    своего такого модуля в стандартной библиотеке (есть в сторонних библиотеках). 
    Если бы такой модуль был, то код выглядел бы так:

    Math.sqrt(Math.pow(x_dist, 2) + Math.pow(y_dist, 2))
"""

@doc """
    Обычно извлечение значений из кортежа с помощью сопоставления с образцом делают прямо 
    в аргументах функции:
"""
def distance({:point, x1, y1}, {:point, x2, y2}) do
  x_dist = abs(x1 - x2)
  y_dist = abs(y1 - y2)
  :math.sqrt(:math.pow(x_dist, 2) + :math.pow(y_dist, 2))
end

# Результат работы функции:
distance({:point, 0, 0}, {:point, 0, 5})  # 5.0
distance({:point, 2, 2}, {:point, 10, 12})  # 12.806248474865697
distance({:point, -5, -5}, {:point, 10, 10})  # 21.213203435596427

@doc """
    При объявлении, атом сохраняется внутри памяти программы в виде числа, из-за чего 
    сравнения атомов происходят быстрее, чем строк. Однако, если бесконтрольно объявлять 
    атомы, например, из пользовательского ввода, то память приложения переполнится. 
    Атомы не вычищаются сборщиком мусора BEAM. Хоть и максимальное число атомов, 
    которые можно создать - 1,048,576, не стоит заводить атомы на каждое действие.
"""

###### ASSIGNMENT ######
@doc """
    Реализовать функцию is_point_inside_circle(point, circle), которая принимает точку 
    и окружность, и возвращает true, если точка находится внутри окружности, или false, 
    если точка находится снаружи.

    Реализовать функцию is_point_inside_rect(point, rect), которая принимает точку и 
    прямоугольник, и возвращает true, если точка находится внутри прямоугольника, 
    или false, если точка находится снаружи.

    Точка представлена кортежем {:point, x, y}.

    Окружность представлена кортежем {:circle, center, radius}, где center — 
    это кортеж :point.

    Прямоугольник представлен кортежем {:rect, left_top, right_bottom}, где left_top 
    и right_bottom — это кортежи :point.

    Уже реализованная функция distance может вам пригодиться:

    Solution.is_point_inside_circle(point, {:circle, {:point, 10, 10}, 100})
    # => true
    Solution.is_point_inside_circle(point, {:circle, {:point, -10, -10}, 20})
    # => false

    Solution.is_point_inside_rect(point, {:rect, {:point, -20, 30}, {:point, 20, 10}})
    # => true
    Solution.is_point_inside_rect(point, {:rect, {:point, 0, 0}, {:point, 10, 10}})
    # => false
"""
defmodule Solution do
  def distance({:point, x1, y1}, {:point, x2, y2}) do
    x_dist = abs(x1 - x2)
    y_dist = abs(y1 - y2)
    :math.sqrt(:math.pow(x_dist, 2) + :math.pow(y_dist, 2))
  end

  def is_point_inside_circle(point, circle) do
    {:circle, center, r} = circle

    distance(point, center) <= r
  end

  def is_point_inside_rect(point, rect) do
    {:point, x, y} = point
    {:rect, {:point, left_x, top_y}, {:point, right_x, bottom_y}} = rect

    x >= left_x and x <= right_x and y <= top_y and y >= bottom_y
  end
end