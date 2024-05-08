@doc """
    Список — коллекция элементов. В отличие от кортежа, в список можно динамически добавлять 
    и удалять элементы.

    Список совсем не похож на массив ни по своему внутреннему устройству, ни по способу 
    работы с ним. По внутреннему устройству это однонаправленный связанный список 
    (singly linked list). А работа с ним сводится к двум простым операциям: 
    добавление нового элемента к голове списка, и разделение списка на голову и хвост.

    Создадим список, и добавим в него новый элемент:
"""
my_list = [1, 2, 3, 4] # [1, 2, 3, 4]
other_list = [0 | my_list] # [0, 1, 2, 3, 4]

@doc """
    Оператор | добавляет новый элемент к голове списка и возвращает новый список.

    Разделение списка на голову и хвост выглядит похоже:
"""
[head | tail] = my_list
IO.puts(head) # => 1
IO.puts(inspect(tail)) # => [2, 3, 4]

@doc """
    Здесь мы используем сопоставление с образцом. Шаблон (образец) [head | tail] 
    сопоставляется со списком. Первый элемент списка попадает в переменную head, 
    остаток списка (хвост) попадает в переменную tail.

    Можно извлечь несколько элементов одновременно:
"""
[item1, item2, item3 | tail] = my_list
IO.puts(item1) # => 1
IO.puts(item2) # => 2
IO.puts(item3) # => 3
IO.puts(inspect(tail)) # => [4]

@doc """
    Таким образом мы извлекли три элемента, и в списке остался только один.

    Есть еще функции hd и tl, которые извлекают голову и хвост списка:
"""
hd(my_list) # 1
tl(my_list) # [2, 3, 4]

@doc """
    Зачем нужны такие странные операции? На них основана итерация по элементам списка. 
    А на итерации основана вообще любая работа со списками и с другими коллекциями. 
    Это станет понятно позже, когда мы начнем изучать рекурсию и основы функционального 
    программирования.
"""

###### ASSIGNMENT ######
@doc """
    Реализуйте функцию get_second_item, которая возвращает сумму первого и второго 
    элементов списка.

    Внимательный читатель спросит: "а что функция должна сделать, если в списке только 
    один элемент, или список вообще пустой?". На этот вопрос мы ответим в следующем 
    модуле, где будем изучать ветвления в коде и сопоставление с образцом. Пока будем 
    считать, что функция всегда вызывается со списком, содержащим два или больше 
    элементов.

    Solution.get_second_item([20, 22, 24])
    # => 42
    Solution.get_second_item([1, 2, 3, 4])
    # => 3

    Еще более внимательный читатель спросит: "а что, если список содержит элементы 
    такого типа, для которого не определена операция суммирования?". В этом случае 
    возникнет исключение. Исключения и обработку ошибок изучим в соответствующем 
    модуле.
"""
defmodule Solution do
  def get_second_item(list) do
    [item1, item2 | tail] = list
    item1 + item2
  end
end