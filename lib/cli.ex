defmodule CommandLine.CLI do
  def main([path | _opts]) do
    path
    |> String.trim
    |> list_files
    |> parse_directories
    |> add_directories_to_github(path)
  end

  def list_files(path) do
    System.cmd("ls", [path])
  end

  def parse_directories({ directories, _ }) do
    directories
    |> String.split("\n")
  end

  def add_directories_to_github([], _current_path) do
    IO.inspect "Finished"
  end

  def add_directories_to_github([repo | the_rest], current_path) do
    task = Task.async fn () ->
      File.cd!("#{current_path}/#{repo}", fn () ->
        IO.inspect "Pushing to #{current_path}/#{repo}"
        repo
        |> set_remote_url
        |> create_remote_repo
        |> push_to_remote
      end)
    end
    Task.await(task)
    add_directories_to_github(the_rest, current_path)
  end

  def set_remote_url(repo) do
    System.cmd("git", ["remote", "set-url", "origin", "git@github.com:programming-notes/#{repo}.git"])
    repo
  end

  def push_to_remote(_repo) do
    System.cmd("git", ["push", "origin", "master"]) 
  end

  def create_remote_repo(repo) do
    HTTPoison.post(
      "https://api.github.com/orgs/programming-notes/repos", 
      Jason.encode!(%{
        name: repo,
        private: false,
        has_issues: true,
        has_projects: false,
        has_wiki: false
      }),
      [{"Authorization", "token #{System.get_env("GIT_TOKEN")}"}]
    )
    repo
  end
end