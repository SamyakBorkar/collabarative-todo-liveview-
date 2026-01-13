defmodule CollaberativeTodoWeb.TodoLive do
  use CollaberativeTodoWeb, :live_view

  alias CollaberativeTodo.Todos

  def mount(_params, _session, socket) do
    items = Todos.list_items()
    {:ok, assign(socket, items: items)}
  end

def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-indigo-500 via-purple-500 to-pink-500 flex items-center justify-center py-10 px-4">
      <div class="w-full max-w-lg bg-white rounded-2xl shadow-2xl overflow-hidden">

        <div class="bg-gray-50 px-6 py-8 border-b border-gray-100 text-center">
          <h1 class="text-3xl font-extrabold text-gray-800 tracking-tight">
            Collaborative <span class="text-indigo-600">Tasks</span>
          </h1>
          <p class="text-gray-500 mt-2 text-sm">Real-time updates across all screens</p>
        </div>

        <div class="p-6 space-y-4">
          <%= for item <- @items do %>
            <div phx-click="toggle" phx-value-id={item.id} class="group flex items-center justify-between p-4 bg-white border border-gray-200 rounded-xl shadow-sm hover:shadow-md hover:border-indigo-300 transition-all duration-200 cursor-pointer">

              <div class="flex items-center gap-3">
                <div class={"w-6 h-6 rounded-full border-2 flex items-center justify-center " <>
                  if(item.is_complete, do: "bg-green-500 border-green-500", else: "border-gray-300 group-hover:border-indigo-400")
                }>
                  <%= if item.is_complete do %>
                    <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                  <% end %>
                </div>

                <span class={"text-lg font-medium " <> if(item.is_complete, do: "text-gray-400 line-through", else: "text-gray-700")}>
                  <%= item.title %>
                </span>
              </div>

              <span class={"px-3 py-1 text-xs font-bold uppercase tracking-wider rounded-full " <>
                if(item.is_complete, do: "bg-green-100 text-green-700", else: "bg-yellow-100 text-yellow-700")
              }>
                <%= if item.is_complete, do: "Done", else: "Pending" %>
              </span>

            </div>
          <% end %>
        </div>

        <div class="bg-gray-50 px-6 py-4 border-t border-gray-100">
          <form phx-submit="add" class="flex gap-2">
            <input type="text" name="title" placeholder="Add a new task..." class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all" required autocomplete="off" />
            <button type="submit" class="bg-indigo-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-indigo-700 transition-colors shadow-lg">
              Add
            </button>
          </form>
        </div>

      </div>
    </div>
    """
  end

  def handle_event("add", %{"title"=> title}, socket) do
    {:ok, _item} = Todos.create_item(%{title: title, is_complete: false})
    items = Todos.list_items()
    {:noreply, assign(socket, items: items)}
  end

  def handle_event("toggle", %{"id" => id}, socket) do
      items = Todos.get_item!(id)

      {:ok, _updated_item} = Todos.update_item(items, %{is_complete: !items.is_complete})

      items = Todos.list_items()
      {:noreply, assign(socket, items: items)}
  end
end
