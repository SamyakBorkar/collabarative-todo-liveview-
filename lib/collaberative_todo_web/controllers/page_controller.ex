defmodule CollaberativeTodoWeb.PageController do
  use CollaberativeTodoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
