defmodule Servy.Plugins do
  require Logger

  def track(%{status: 404, path: path} = conv) do
    Logger.info "404 -  #{path} is on the loose!"
    conv
  end

  def track(%{status: 403, path: path, method: method} = conv) do
    Logger.warning "403 - Attempted #{method} of #{path}"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path(conv), do: conv

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  def rewrite_path_captures(conv, nil), do: conv
end
