@doc """
    В прошлом упражнении мы создали процесс-калькулятор, который только обрабатывает входящие запросы, не храня никакого состояния. Но как его сохранить? 
    Основная идея процесса, который обрабатывает более одного сообщения за раз, это вызов рекурсивной функции. Повторный вызов которой, продолжит основной 
    цикл обработки сообщений. Рассмотрим пример с процессом-счетчиком:
"""
defmodule Counter do
  def init(parent, initial_state \\ 0) do
    process(parent, initial_state)
  end

  defp process(parent, state) do
    receive do
      :inc ->
        new_state = state + 1
        send(parent, {:ok, new_state})
        process(parent, new_state)

      :dec ->
        new_state = state - 1
        send(parent, {:ok, new_state})
        process(parent, new_state)

      :current ->
        send(parent, {:ok, state})
        process(parent, state)

      :reset ->
        send(parent, {:ok, 0})
        process(parent, 0)
    end
  end
end

@doc """
    В процессе-счетчике мы вынесли функцию запуска процесса, запомнили процесс-родитель и инициализировали состояние процесса-счетчика нулем. Затем при 
    обработке сообщения изменяется состояние процесса, которое передается дальше в рекурсивный вызов функции process. Теперь запустим счетчик и проверим 
    его работу:

    Важно, что идентификатор родительского процесса мы передаем снаружи, так как вызов self() внутри модуля вернет иной идентификатор.
"""
parent = self()
counter = spawn(fn -> Counter.init(parent) end)

send(counter, :current)
# для просмотра почтового ящика родительского процесса
# далее по коду будет подразумеваться, что эта строчка кода
# будет вызываться после каждой отправки сообщения другому процессу
Process.info(parent, :messages)
# => {:messages, [ok: 0]}

send(counter, :inc)
# => {:ok, 1}
send(counter, :inc)
# => {:ok, 2}

send(counter, :dec)
# => {:ok, 1}

send(counter, :inc)
# => {:ok, 2}

send(counter, :reset)
# => {:ok, 0}

send(counter, :dec)
# => {:ok, -1}

@doc """
    Важно заметить, что каждый процесс хранит свое состояние отдельно от других процессов:
"""
parent = self()
first_counter = spawn(fn -> Counter.init(parent) end)
second_counter = spawn(fn -> Counter.init(parent) end)

send(first_counter, :inc)
send(first_counter, :inc)
send(first_counter, :inc)

send(second_counter, :dec)
send(second_counter, :dec)

send(first_counter, :current)
# => {:ok, 3}

send(second_counter, :current)
# => {:ok, -2}

@doc """
    Состояние не обязательно выражается числом, в него можно складывать что-угодно, начиная от чисел и заканчивая словарем со ссылками на другие процессы, 
    к примеру.
"""

###### ASSIGNMENT ######
@doc """
   В этот раз создайте процесс кеш-сервер, который хранит в состоянии словарь. Напишите функцию init, которая принимает родительский процесс и начальное 
   состояние (как в примерах выше). Затем добавьте обработку следующих сообщений:

    - :put положить по переданному ключу key значение value в состояние кеш-сервера, возвращает кортеж {:ok, value};
    - :get достать из состояния процесса значение по переданному ключу, при отсутствии значения вернуть кортеж {:error, :not_found};
    - :drop убрать из состояния процесса переданный ключ;
    - :exit перестать обрабатывать входящие сообщения кеш-сервером, возвращает кортеж {:ok, :exited};
    - а еще добавьте обработку невалидных сообщений, чтобы процесс не ломался, если ему передать что-то не то (вернуть кортеж {:error, :unrecognized_operation}).

    parent = self()
    cache_server = spawn(fn -> CacheServer.init(parent) end)

    send(cache_server, {:put, {:hello, "world"}})
    # => {:ok, "world"}

    send(cache_server, {:get, {:hello}})
    # => {:ok, "world"}

    send(cache_server, {:get, {:some}})
    # => {:error, :not_found})

    send(cache_server, {:drop, {:hello}})
    # => {:ok, :hello}

    send(cache_server, {:get, {:hello}})
    # => {:error, :not_found})

    send(cache_server, {:something, {1, 2, 3}})
    # => {:error, :unrecognized_operation}
    Process.alive?(cache_server)
    # => true

    send(cache_server, :boom)
    # => {:error, :unrecognized_operation}
    Process.alive?(cache_server)
    # => true

    send(cache_server, {:exit})
    # => {:ok, :exited}
    Process.alive?(cache_server)
    # => false
"""
defmodule CacheServer do
  def init(parent, initial_state \\ %{}) do
    process(parent, initial_state)
  end

  defp process(parent, state) do
    receive do
        {:put, {key, value}} ->
            new_state = Map.put(state, key, value)
            send(parent, {:ok, value})
            process(parent, new_state)

        {:get, {key}} ->
            case Map.fetch(state, key) do
                {:ok, value} ->
                    send(parent, {:ok, value})
                :error -> 
                    send(parent, {:error, :not_found})
            end
            process(parent, state)

        {:drop, {key}} ->
            new_state = Map.delete(state, key)
            send(parent, {:ok, key})
            process(parent, new_state)

        {:exit} -> 
            send(parent, {:ok, :exited})
            :ok

        _other -> 
            send(parent, {:error, :unrecognized_operation})
            process(parent, state)
    end
  end
end

# ALTERNATIVE SOLUTION
defmodule CacheServer do
  def init(parent, initial_state \\ %{}) do
    process_requests(parent, initial_state)
  end

  defp process_requests(parent, state) do
    receive do
      {operation, args} ->
        {response, result, new_state} = exec(operation, args, state)
        send(parent, {response, result})
        process_requests(parent, new_state)

      {:exit} ->
        send(parent, {:ok, :exited})

      _ ->
        send(parent, {:error, :unrecognized_operation})
        process_requests(parent, state)
    end
  end

  defp exec(:put, {key, value}, state) do
    {:ok, value, Map.put(state, key, value)}
  end

  defp exec(:get, {key}, state) do
    if Map.has_key?(state, key) do
      value = Map.get(state, key)
      {:ok, value, state}
    else
      {:error, :not_found, state}
    end
  end

  defp exec(:drop, {key}, state) do
    new_state = Map.delete(state, key)
    {:ok, key, new_state}
  end

  defp exec(_, _, state) do
    {:error, :unrecognized_operation, state}
  end
end