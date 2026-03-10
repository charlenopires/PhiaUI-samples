defmodule PhiaDemo.News do
  @moduledoc "Compile-time markdown news articles from priv/content/news/."

  alias PhiaDemo.News.Article

  @news_dir Path.join(:code.priv_dir(:phia_demo), "content/news")

  paths =
    @news_dir
    |> Path.join("*.md")
    |> Path.wildcard()

  for path <- paths do
    @external_resource path
  end

  @articles (
    paths
    |> Enum.map(fn path ->
      raw = File.read!(path)
      [_, frontmatter, body] = String.split(raw, "---", parts: 3)

      meta =
        frontmatter
        |> String.split("\n", trim: true)
        |> Enum.reduce(%{}, fn line, acc ->
          case String.split(line, ":", parts: 2) do
            [key, value] -> Map.put(acc, String.trim(key), String.trim(value) |> String.trim("\""))
            _ -> acc
          end
        end)

      {:ok, html, _} = Earmark.as_html(String.trim(body))

      %Article{
        slug: meta["slug"],
        title: meta["title"],
        date: Date.from_iso8601!(meta["date"]),
        summary: meta["summary"],
        tags: String.split(meta["tags"] || "", ",", trim: true),
        icon: meta["icon"] || "file",
        body_html: html
      }
    end)
    |> Enum.sort_by(& &1.date, {:desc, Date})
  )

  @doc "All articles sorted by date descending."
  def list_articles, do: @articles

  @doc "Get an article by slug."
  def get_article(slug) do
    Enum.find(@articles, &(&1.slug == slug))
  end

  @doc "Most recent article."
  def latest_article do
    List.first(@articles)
  end
end
