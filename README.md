# ⚡ Collaborative Todo List
> A real-time, multi-user task manager built with the PETAL stack (Phoenix, Elixir, Tailwind, Alpine, LiveView).

![Elixir](https://img.shields.io/badge/Elixir-4B275F?style=for-the-badge&logo=elixir&logoColor=white)
![Phoenix](https://img.shields.io/badge/Phoenix-FD4F00?style=for-the-badge&logo=phoenixframework&logoColor=white)
![LiveView](https://img.shields.io/badge/LiveView-FF6347?style=for-the-badge&logo=html5&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

---

## 🚀 Project Overview
This project demonstrates the power of Phoenix LiveView by creating a Todo List where interactions happen instantly on the server. No heavy JavaScript framework is required.

**Key Features**
- Create tasks instantly
- Toggle between Done / Pending
- Real-time UI via WebSockets
- Data persisted with PostgreSQL + Ecto
- Tailwind-styled modern UI

---

## 🛠️ Step-by-Step Build Log
History of the core commands and steps used to build the app.

### Phase 1: Initialization
```bash
# Install the Phoenix generator
mix archive.install hex phx_new

# Create the project
mix phx.new collaborative_todo

# Enter the directory
cd collaborative_todo

# Create the PostgreSQL database (ensure config/dev.exs is correct)
mix ecto.create
```

### Phase 2: Database Layer (Ecto)
```bash
# Generate context and schema (Todos/Item) with CRUD and migration
mix phx.gen.context Todos Item items title:string is_complete:boolean

# Run migrations
mix ecto.migrate
```
Context: lib/collaborative_todo/todos.ex
Schema: lib/collaborative_todo/todos/item.ex

### Phase 3: User Interface (LiveView)
```bash
# Add the LiveView route
scope "/", CollaborativeTodoWeb do
  pipe_through :browser
  live "/todos", TodoLive
end
```
LiveView module: lib/collaborative_todo_web/live/todo_live.ex

Responsibilities:
- mount/3: fetch items on load
- render/1: display the Tailwind UI
- handle_event/3: handle "add" and "toggle"

### Phase 4: Logic & Interactivity
```bash
# Add new item
handle_event("add", params, socket)

# Toggle completion
handle_event("toggle", %{"id" => id}, socket)
```
Flow:
- Form submit → Todos.create_item/1 → assign updated list
- Row click → Todos.get_item!/1 + Todos.update_item/2 → assign updated list

### Phase 5: Real-Time Collaboration (PubSub)
We unlocked true multi-user synchronization so changes instantly appear on all connected browsers—no refresh needed.

**Context Layer Changes (todos.ex)**
```elixir
# Subscribe a LiveView process to the todos topic
def subscribe do
  Phoenix.PubSub.subscribe(CollaberativeTodo.PubSub, "todos_topic")
end

# Broadcast updates whenever an item changes
defp broadcast(msg) do
  Phoenix.PubSub.broadcast(
    CollaberativeTodo.PubSub,
    "todos_topic",
    msg
  )
end
```

**LiveView Layer Changes (todo_live.ex)**
```elixir
# Mount: Subscribe when user joins
def mount(_params, _session, socket) do
  Todos.subscribe()
  items = Todos.list_items()
  {:ok, assign(socket, items: items)}
end

# Handle: Listen for broadcasts and auto-refresh
def handle_info({:todos_updated, _item}, socket) do
  items = Todos.list_items()
  {:noreply, assign(socket, items: items)}
end
```

Flow:
- User A creates/updates task → broadcast({:todos_updated, item})
- LiveView process receives via PubSub → handle_info callback triggers
- All connected users see the change instantly via WebSocket
- No polling, no manual refresh—true collaborative magic ✨

---

## 💻 How to Run
```bash
# Install dependencies
mix deps.get

# One-time asset setup (if needed)
mix assets.setup

# Create and migrate the database
mix ecto.setup

# Start the server with live reloading
mix phx.server
```
Visit: **http://localhost:4000/todos**

Open in multiple browser tabs/windows to see real-time sync in action!

---

## 📁 Project Structure
```
lib/
├── collaberative_todo/
│   ├── todos.ex          (context: CRUD + PubSub)
│   └── todos/
│       └── item.ex       (schema)
├── collaberative_todo_web/
│   ├── live/
│   │   └── todo_live.ex  (LiveView UI + events + subscriptions)
│   └── router.ex         (routes)
assets/
├── css/
│   └── app.css          (Tailwind + custom styles)
└── js/
    └── app.js            (LiveSocket + hooks)
```

---

## 🎯 What Makes This Cool
✨ **Zero JavaScript boilerplate** — LiveView handles interactivity  
🔄 **PubSub magic** — Multi-user sync with no polling  
📡 **WebSocket efficiency** — Only deltas sent over the wire  
🎨 **Beautiful by default** — Tailwind + modern component patterns  
🚀 **Server-centric** — All logic lives in safe, testable Elixir